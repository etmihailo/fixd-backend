require "rails_helper"

RSpec.describe "GithubEvents GraphQL Query", type: :request do
  let(:query) do
    <<~GRAPHQL
      query($username: String!, $page: Int, $perPage: Int) {
        githubEvents(username: $username, page: $page, perPage: $perPage) {
          currentPage
          totalPages
          totalCount
          hasNextPage
          hasPreviousPage
          events {
            type
            repo
            time
          }
        }
      }
    GRAPHQL
  end

  context "with valid data" do
    before do
      stub_request(:get, %r{https://api.github.com/users/.*/events/public})
        .to_return(status: 200, body: File.read("spec/fixtures/github_events.json"))
    end

    it "returns paginated github events" do
      post "/graphql", params: {
        query: query,
        variables: { username: "peppy", page: 1, perPage: 2 }
      }.to_json, headers: { "Content-Type" => "application/json" }

      json = JSON.parse(response.body)
      data = json["data"]["githubEvents"]

      expect(data["events"].length).to eq(2).or be <= 2
      expect(data["totalCount"]).to be > 0
      expect(data["currentPage"]).to eq(1)
    end
  end

  context "when user has no events" do
    before do
      stub_request(:get, %r{https://api.github.com/users/.*/events/public})
        .to_return(status: 200, body: "[]")
    end

    it "returns empty event list" do
      post "/graphql", params: {
        query: query,
        variables: { username: "fakeuser", page: 1, perPage: 10 }
      }.to_json, headers: { "Content-Type" => "application/json" }

      json = JSON.parse(response.body)
      data = json["data"]["githubEvents"]

      expect(data["events"]).to eq([])
      expect(data["totalCount"]).to eq(0)
    end
  end

  context "with invalid page numbers" do
    before do
      stub_request(:get, %r{https://api.github.com/users/.*/events/public})
        .to_return(status: 200, body: File.read("spec/fixtures/github_events.json"))
    end

    it "corrects out-of-bounds page number" do
      post "/graphql", params: {
        query: query,
        variables: { username: "peppy", page: -10, perPage: 5 }
      }.to_json, headers: { "Content-Type" => "application/json" }

      json = JSON.parse(response.body)
      expect(json["data"]["githubEvents"]["currentPage"]).to eq(1)
    end
  end

  context "when Github API returns error" do
    before do
      stub_request(:get, %r{https://api.github.com/users/.*/events/public})
        .to_return(status: 404)
    end

    it "returns empty events array and zero counts" do
      post "/graphql", params: {
        query: query,
        variables: { username: "invalid", page: 1, perPage: 5 }
      }.to_json, headers: { "Content-Type" => "application/json" }

      json = JSON.parse(response.body)
      data = json["data"]["githubEvents"]

      expect(data["events"]).to eq([])
      expect(data["totalCount"]).to eq(0)
      expect(data["totalPages"]).to eq(0)
    end
  end
end
