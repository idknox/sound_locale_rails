require 'spec_helper'

feature "Reg Page" do
  scenario "User can fill out Registration form" do
    visit "/"
    fill_in("email", :with => "knoxid@gmail.com")
    fill_in("password", :with => "123")
    fill_in("body", :with => "blah blah blah blah blah")
    click_button("Submit")

    expect(page).to have_content("Thank you for signing up")

  end
end