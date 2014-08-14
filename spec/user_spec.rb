require 'rails_helper'
require 'capybara/rails'

feature "Home Page" do
  scenario "User can register" do
    visit "/"

    click_on "Register"

    fill_in "First name", :with => "Ian"
    fill_in "Last name", :with => "Knox"
    fill_in "Password", :with => "123"
    fill_in "Password confirmation", :with => "123"
    fill_in "Birthdate", :with => "08-08-1984"
    click_on "Sign Up"

    expect(page).to have_content "Thank you for registering"
  end
end