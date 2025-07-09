require "rails_helper"

RSpec.describe GithubEventService do
  describe ".fetch" do
    it "returns parsed events on success" do
      stub_request(:get, %r{https://api.github.com/users/.*/events/public})
        .to_return(status: 200, body: File.read("spec/fixtures/github_events.json"))

      events = described_class.fetch("peppy")

      expect(events).to all(include(:type, :repo, :time))
      expect(events.first[:type]).to eq("Repo Created").or eq("PR Merged").or eq("Pushed Commit")
    end

    it "returns empty array on failure" do
      stub_request(:get, %r{https://api.github.com/users/.*/events/public})
        .to_return(status: 404)

      expect(described_class.fetch("unknown")).to eq([])
    end
  end
end
