require "rails_helper"

RSpec.describe "GithubEventsController", type: :request do
  describe "GET /github_events" do
    it "renders the form" do
      get github_events_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Github Username")
    end
  end

  describe "POST /github_events" do
    it "redirects to the show path with username" do
      post github_events_path, params: { username: "peppy" }
      expect(response).to redirect_to(github_event_path("peppy"))
    end
  end

  describe "GET /github_events/:username" do
    before do
      stub_request(:get, %r{https://api.github.com/users/.*/events/public})
        .to_return(status: 200, body: File.read("spec/fixtures/github_events.json"))
    end

    it "fetches events and renders them paginated" do
      get github_event_path("peppy")
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Github Activity for")
      expect(response.body).to include("Repo Created").or include("PR Merged").or include("Pushed Commit")
    end
  end
end
