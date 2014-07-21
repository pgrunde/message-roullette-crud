require "rspec"
require "capybara"

feature "Messages" do
  scenario "As a user, I can submit a message" do
    visit "/"

    expect(page).to have_content("Message Roullete")

    fill_in "Message", :with => "Hello Everyone!"

    click_button "Submit"

    expect(page).to have_content("Hello Everyone!")
  end

  scenario "As a user, I see an error message if I enter a message > 140 characters" do
    visit "/"

    fill_in "Message", :with => "a" * 141

    click_button "Submit"

    expect(page).to have_content("Message must be less than 140 characters.")
  end

  scenario "user sees populated edit form when clicking 'edit'" do
    visit "/"

    fill_in "Message", :with => "Hello Everyone!"

    click_button "Submit"

    expect(page).to have_content("Hello Everyone!")

    click_link "Edit"
    expect(page).to have_content("Hello Everyone!")
  end

  scenario "user can submit an edited message which fails if char leng > 140" do
    visit "/"

    fill_in "Message", :with => "Hello Everyone!"

    click_button "Submit"

    click_link "Edit"

    fill_in "Message", :with => "Sup people!"

    click_button "Submit"

    expect(page).to have_content("Sup people!")

    click_link "Edit"

    fill_in "Message", :with => "a" * 141

    click_button "Submit"

    expect(page).to have_content("Message must be less than 140 characters.")
  end

  scenario "user can click delete to remove a message" do
    visit "/"

    fill_in "Message", :with => "Hello Everyone!"

    click_button "Submit"

    click_button "Delete"

    expect(page).to_not have_content("Hello Everyone!")
  end


end

feature "comments" do
  before(:each) do
    visit "/"

    fill_in "Message", :with => "Hello Everyone!"

    click_button "Submit"

    click_link "Comment"

    fill_in "Comment", :with => "Terrible idea!"

    click_button "Add Comment"
  end

  scenario "user can click comment to add a comment which displays below messages" do
    expect(page).to have_content("Terrible idea!")
  end

  scenario "user can click a message to view all comments on a separate page" do
    click_link "Comment"

    fill_in "Comment", :with => "Wonderful concept!"

    click_button "Add Comment"

    click_link "Hello Everyone!"

    expect(page).to have_content("Terrible idea!")
    expect(page).to have_content("Wonderful concept!")
  end
end
