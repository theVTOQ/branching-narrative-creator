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

  it 'links from the user show page to the narratives index page, but only displays links to both public and private narratives if user is admin' do
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

  end

  it 'prevents users from viewing a list of all documents in the database if they are not admin' do
    visit '/documents'
    expect(current_path).to_not eq('/documents')
  end

  it 'allows admin users to view a list of all documents in the database' do
    visit '/documents'
    expect(current_path).to eq('/documents')
  end
end

describe 'Feature Test: Admin Flow', :type => :feature do

  before :each do
    @rollercoaster = Attraction.create(
      :name => "Roller Coaster",
      :tickets => 5,
      :nausea_rating => 2,
      :happiness_rating => 4,
      :min_height => 32
    )
    @ferriswheel = Attraction.create(
      :name => "Ferris Wheel",
      :tickets => 2,
      :nausea_rating => 2,
      :happiness_rating => 1,
      :min_height => 28
    )
    @teacups = Attraction.create(
      :name => "Teacups",
      :tickets => 1,
      :nausea_rating => 5,
      :happiness_rating => 1,
      :min_height => 28
    )
    visit '/users/new'
    admin_signup
  end

  it 'displays admin when logged in as an admin on user show page' do
    expect(page).to have_content("ADMIN")
  end

  it 'links to the attractions from the users show page when logged in as a admin' do
    expect(page).to have_content("See attractions")
  end

  it 'has a link from the user show page to the attractions index page when in admin mode' do
    click_link('See attractions')
    expect(page).to have_content("#{@teacups.name}")
    expect(page).to have_content("#{@rollercoaster.name}")
    expect(page).to have_content("#{@ferriswheel.name}")
  end

  it 'allows admins to add an attraction from the index page' do
    click_link('See attractions')
    expect(page).to have_content("New Attraction")
  end

  it 'allows admins to add an attraction' do
    click_link('See attractions')
    click_link("New Attraction")
    expect(current_path).to eq('/attractions/new')
    fill_in("attraction[name]", :with => "Haunted Mansion")
    fill_in("attraction[min_height]", :with => "32")
    fill_in("attraction[happiness_rating]", :with => "2")
    fill_in("attraction[nausea_rating]", :with => "1")
    fill_in("attraction[tickets]", :with => "4")
    click_button('Create Attraction')
    expect(current_path).to eq("/attractions/4")
    expect(page).to have_content("Haunted Mansion")
  end

  it "has link to attraction/show from attraction/index page for admins" do
    click_link('See attractions')
    expect(page).to have_content("Show #{@ferriswheel.name}")
  end

  it "does not suggest that admins go on a ride" do
    click_link('See attractions')
    expect(page).to_not have_content("Go on #{@ferriswheel.name}")
  end

  it "links to attractions/show page from attractions/index" do
    click_link('See attractions')
    click_link("Show #{@rollercoaster.name}")
    expect(current_path).to eq("/attractions/1")
  end

  it "does not suggest that an admin go on a ride from attractions/show page" do
    click_link('See attractions')
    click_link("Show #{@rollercoaster.name}")
    expect(page).to_not have_content("Go on this ride")
  end

  it "has a link for admin to edit attraction from the attractions/show page" do
    click_link('See attractions')
    click_link("Show #{@rollercoaster.name}")
    expect(page).to have_content("Edit Attraction")
  end

  it "links to attraction/edit page from attraction/show page when logged in as an admin" do
    click_link('See attractions')
    click_link("Show #{@rollercoaster.name}")
    click_link("Edit Attraction")
    expect(current_path).to eq("/attractions/1/edit")
  end

  it "updates an attraction when an admin edits it" do
    click_link('See attractions')
    click_link("Show #{@rollercoaster.name}")
    click_link("Edit Attraction")
    fill_in("attraction[name]", :with => "Nitro")
    click_button("Update Attraction")
    expect(current_path).to eq("/attractions/1")
    expect(page).to have_content("Nitro")
  end
end