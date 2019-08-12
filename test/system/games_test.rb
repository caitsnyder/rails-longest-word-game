require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert_text: "New game"
    assert_selector ".tile", count: 9
  end

  test "You can fill the form with a random word, click the play button, and get a message that the word is not in the grid." do
    random_letter = ('a'..'z').to_a.shuffle[0, 9].join("")
    visit new_url
    fill_in "text", with: "#{random_letter}"
    click_on "check"
    assert_text "Your word was not found"
  end

  test "You can fill the form with a one-letter consonant word, click play, and get a message it's not a valid English word." do
    letter = "b"
    visit new_url
    fill_in "text", with: "#{letter}"
    click_on "check"
    assert_text "That is not an English word."
  end
end
