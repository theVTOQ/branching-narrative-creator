require 'rails_helper'

RSpec.describe Document, :type => :model do
  before(:example) do
    @user = User.new(
      name: "Wiflred",
      password: "will will",
      email: "will@will.com"
    )

    @equinox = Narrative.new(
      title: "equinox",
      author_id: @user.id
    )  

    @solstice = Narrative.new(
      title: "solstice",
      author_id: @user.id
    )

    @equinox_ritual_commenced = Document.new(
      title: "Perform the Ritual",
      passage: "I perform the ritual. Now, do I project solemnity or triumph?",
      narrative_id: @equinox.id,
      is_root: true
    )

    @solemnity_projected = Document.new(
      title: "Project Solemnity",
      passage: "I project solemnity in the aftermath of the ritual. Now, do I seek penance, or do I seek retribution?",
      narrative_id: @equinox.id
    )

    @triumph_projected = Document.new(
      title: "Project Triumph",
      passage: "I project triumph in the aftermath of the ritual. Now, do I give absolution, or seek absolution?",
      narrative_id: @equinox.id
    )
  
    @solemnity_projected_insincerely = Document.new(
      title: "Project Solemnity",
      passage: "I do my best to pretend to be solemn while I revel in the aftermath of the ritual.",
      narrative_id: @equinox.id
    )
  end

  it "is valid with a title, passage, and narrative_id" do
    expect(@equinox_ritual_commenced).to be_valid
  end

  it "defaults to false for the is_root attribute" do
    expect(@solemnity_projected.is_root).to eq(false)
  end

  it "is valid even if given a title from a document in an different existing narrative" do
    @equinox.add_document(@equinox_ritual_commenced)
    @solstice.add_document(@equinox_ritual_commenced)
    expect(@equniox).to be_valid
    expect(@solstice).to be_valid
  end

  it "is invalid if given the same title as an existing document in the same narrative" do
    @equinox.add_document(@solemnity_projected)
    @equinox.add_document(@solemnity_projected_insincerely)
    @equinox.save
    expect(@solemnity_projected_insincerely.errors[:title]).to eq("A document in this narrative already has this title.")
  end

  it "has many parent and child branches" do
    triumph_branch = Branch.new(
      parent_document_id: @equinox_ritual_commenced.id, 
      child_document_id: @triumph_projected.id
    )
    solemnity_branch = Branch.new(
      parent_document_id: @equinox_ritual_commenced.id, 
      child_document_id: @solemnity_projected.id
    )
    @equinox_ritual_commenced.child_branches << triumph_branch
    @equinox_ritual_commenced.child_branches << solemnity_branch
    
    expect(@equinox_ritual_commenced.child_documents).to eq([@triumph_projected, @solemnity_projected])
    expect(@triumph_projected.parent_documents).to eq([@equinox_ritual_commenced])
  end
end