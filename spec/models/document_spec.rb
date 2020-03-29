require 'rails_helper'

RSpec.describe Document, :type => :model do
  let(:user) {
    User.create(
      :name => "Wilfred",
      :password => "will will",
      :email => "will@will.com"
    )
  }

  let(:narrative) {
    Narrative.create(
      :title => "Equinox",
      :author_id => user.id
    )
  }

  let(:document) {
    Document.create(
      :title => "Perform the ritual",
      :passage => "The ritual is performed. Now, project solemnity or triumph?",
      :narrative_id => narrative.id
    )
  }

  it "is valid with a title, passage, and narrative_id" do
    expect(document).to be_valid
  end

  it "is valid even if given a title from a document in an different existing narrative" do
    narrative_2 = Narrative.create(title: "Solstice", author_id: user.id)
    narrative_2.root_document = Document.create(title: "Perform the ritual", narrative_id: narrative_2.id)
    expect(narrative_2.root_document).to be_valid
  end

  it "is invalid if given the same title as an existing document in the same narrative" do
    identical_document = Document.create(title: "Perform the ritual", narrative_id: narrative.id)
    expect(identical_document).to be_invalid
  end

  it "has many parent and child branches" do
    triumph_choice = Document.create(title: "Project triumph")
    triumph_branch = Branch.create(parent_document_id: document.id, child_document_id: triumph_choice.id)
    solemnity_choice = Document.create(title: "Project solemnity")
    solemnity_branch = Branch.create(parent_document_id: document.id, child_document_id: solemnity_choice.id)
    document.child_branches << triumph_branch
    document.child_branches << solemnity_branch

    expect(document.child_documents).to eq([triumph_choice, solemnity_choice])
    expect(triumph_branch.parent_documents).to eq([document])
  end
end