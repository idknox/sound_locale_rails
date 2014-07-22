require 'spec_helper'

feature "Reg Page" do
  scenario "User can fill out Registration form" do
    visit "/"
    save_and_open_page
    click_link("Register")
    fill_in("First Name", :with => "123")
    fill_in("Last Name", :with => "123")
    fill_in("email", :with => "knoxid@gmail.com")
    fill_in("Password", :with => "123")
    fill_in("Confirm Password", :with => "123")
    fill_in("body", :with => "blah blah blah blah blah")
    click_button("Submit")

    expect(page).to have_content("Thank you for signing up")
  end
end