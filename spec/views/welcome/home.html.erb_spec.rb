require 'rails_helper'

RSpec.describe "welcome/home", type: :view, developer_strategy: true  do

  it 'offers signup with GitHub' do
    render
    expect(rendered).to include('<a href="/auth/github">Signing in with the GitHub strategy</a>')
  end
end

