require "rails_helper"

RSpec.describe "Github UI Search", type: :system do
  it "enters a username and sees results" do
    stub_request(:get, "https://api.github.com/users/peppy/events/public")
      .to_return(
        status: 200,
        body: [
          {
            type: "PushEvent",
            repo: { name: "peppy/my-repo" },
            created_at: "2025-07-09T12:00:00Z"
          }
        ].to_json,
        headers: { "Content-Type" => "application/json" }
      )

    visit github_events_path

    fill_in "Github Username", with: "peppy"
    click_button "Fetch Github Events"

    expect(page).to have_content("Github Activity for peppy")
    expect(page).to have_content("Pushed Commit")
    expect(page).to have_content("peppy/my-repo")
  end
end
