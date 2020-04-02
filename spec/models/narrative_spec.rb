require 'rails_helper'

RSpec.describe Narrative, :type => :model do
  before do
    @user = User.create(name: "Helios", email: "helios@helios.com", password: "helios@helios.com")
    @narrative = Narrative.create(user_id: @user.id, title: "Test")
  end

  it "is valid with a user_id and title" do
    expect(@narrative).to be_valid
  end

  it "is not public by default" do
    expect(@narrative.is_public).to eq(false)
  end

  it "is invalid if the user has already created a narrative with this title" do
    @copy_of_narrative = Narrative.create(user_id: @user.id, title: "Test")
    expect(@copy_of_narrative).to_not be_valid
  end

  #To-Do:
  #it "is findable by a slug of its title" do 
  #  expect(Narrative.find_by(slug: @narrative.slug)).to eq(@narrative)
  #end
end