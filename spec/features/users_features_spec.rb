require_relative "../rails_helper.rb"
describe 'Feature Test: User Signup', :type => :feature do

  it 'successfully signs up' do
    visit '/users/new'
    expect(current_path).to eq('/users/new')
    # user_signup method is defined in login_helper.rb
    user_signup
    expect(current_path).to eq('/users/1')
    expect(page).to have_content("Ziggy")
  end

  it "on sign up, successfully adds a session hash" do
    visit '/users/new'
    # user_signup method is defined in login_helper.rb
    user_signup
    expect(page.get_rack_session_key('user_id')).to_not be_nil
  end

  it "on log in, successfully adds a session hash" do
    create_standard_user
    visit '/signin'
    # user_login method is defined in login_helper.rb
    user_login
    expect(page.get_rack_session_key('user_id')).to_not be_nil
  end

  it 'prevents user from viewing user show page and redirects to home page if not logged in' do
    create_standard_user
    visit '/users/1'
    expect(current_path).to_not eq('/users/1')
    #expect(page).to have_content("Sign Up")
  end
end

describe 'Feature Test: User Signout', :type => :feature do

  it 'has a link to log out from the users/show page' do
    visit '/users/new'
    # user_signup method is defined in login_helper.rb
    user_signup
    expect(page).to have_content("Sign Out")
  end

  it 'redirects to home page after logging out' do
    visit '/users/new'
    # user_signup method is defined in login_helper.rb
    user_signup
    click_link("Sign Out")
    expect(current_path).to eq('/')
  end

  it "successfully destroys session hash when 'Log Out' is clicked" do
    visit '/users/new'
    # user_signup method is defined in login_helper.rb
    user_signup
    click_link("Log Out")
    expect(page.get_rack_session).to_not include("user_id")
  end
end

describe 'Feature Test: Create a Narrative', :type => :feature do

  before :each do
    visit '/users/new'
    user_signup
    new_user = Users.first
    new_user.admin = true
    new_user.save

    @public_narrative = Narrative.create(user_id: User.first.id, title: "Public Test", is_public)
    @private_narrative = Narrative.create(user_id: User.first.id, title: "Private Test")
  end

  it 'links from the user show page to the narratives index page' do
    click_link('Browse Narratives')
    expect(current_path).to eq('/narratives')
  end
  
  it 'links from the user show page to the narratives index page, but only displays links to public narratives if user is not admin' do
    click_link('Browse Narratives')
    expect(page).to have_content("Public Test")
    expect(page).to_not have_content("Private Test")
  end

  it 'links from the user show page to the narratives index page, and displays links to both public and private narratives if user is admin' do
    click_link('Sign Out')
    click_link('Sign In')
    admin_signup
    click_link('Browse Narratives')
    expect(page).to have_content("Public Test")
    expect(page).to have_content("Private Test")
  end

  it "displays a list of the users' authored narratives" do
    expect(page).to have_content("Your Narratives")
    expect(page).to have_content("Public Test")
    expect(page).to have_content("Private Test")
  end

  it 'allows users to create a new narrative from their show page' do
    fill_in("narrative[title]", :with => "Triumph")
    find(:css, "#narrative_is_public").set(true)
    click_button('Create Narrative')
    expect(current_path).to eq('/users/narratives/3')
    expect(page).to have_content("Triumph")    
  end

  it 'prevents users from creating, editing or deleting a narrative from the narrative index page' do
    click_link('Browse Narratives')
    expect(page).to_not have_content("edit")
    expect(page).to_not have_content("delete")
    expect(page).to_not have_content("new attraction")
  end

  it 'prevents users from creating, editing or deleting a narrative from the narrative index page, even when viewing the narratives they have authored' do
    click_link('Your Narratives')
    expect(current_path).to eq('/users/1/narratives')
    expect(page).to_not have_content("edit")
    expect(page).to_not have_content("delete")
    expect(page).to_not have_content("new attraction")
  end

  it "links from the narratives index page to the narratives' show pages" do
    click_link('Browse Narratives')
    click_link("#{@public_narrative.title}")
    expect(current_path).to eq("/narratives/1")
  end

  it 'allows users to edit/delete a narrative they have created' do
    click_link('Browse attractions')
    click_link("#{@public_narrative.name}")
    expect(page).to have_content("edit")
    expect(page).to have_content("delete")
  end

  it 'prevents users from editing/deleting a narrative they have not created, even if they are admin' do
    click_link('Sign Out')
    admin_login

    click_link('Browse Narratives')
    click_link("#{@public_narrative.name}")
    expect(page).to_not have_content("edit")
    expect(page).to_not have_content("delete")
  end

  it 'allows users to edit a narrative they have created' do
    click_link('Your Narratives')
    click_link("#{@public_narrative.name}")
    click_link("Edit Narrative")
    expect(current_path).to eq("users/1/narratives/1/edit")
    fill_in("narrative[title]", with: "Tribulation")
    find(:css, "#narrative_is_public").set(true)
    click_button("Update Narrative")
    expect(current_path).to eq("users/1/narratives/1")
    expect(page).to_not have_content("Triumph")
    expect(page).to have_content("Tribulation")
  end

  it "allows users to delete narratives they've created" do
    click_link("#{@public_narrative.title}")
    click_link("Delete Narrative")
    expect(current_path).to eq('/users/1/narratives')
    expect(page).to_not have_content("Public Test")
  end

  it 'prevents non-admin users from viewing a list of all documents in the database' do
    visit '/documents'
    expect(current_path).to_not eq('/documents')
  end

  it 'allows admin users to view a list of all documents in the database' do
    click_link("Sign Out")
    admin_login
    visit '/documents'
    expect(current_path).to eq('/documents')
  end
end