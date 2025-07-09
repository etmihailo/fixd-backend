class GithubEventService
  GITHUB_API_URL = "https://api.github.com"

  def self.fetch(username)
    response = Faraday.get("#{GITHUB_API_URL}/users/#{username}/events/public")
    Rails.logger.info "$$$$$$$$$$$$$$#{response}"

    if response.success?
      parse_events(JSON.parse(response.body))
    else
      []
    end
  end

  def self.parse_events(events)
    events.map do |event|
      case event["type"]
      when "CreateEvent"
        { type: "Repo Created", repo: event["repo"]["name"], time: event["created_at"] }
      when "PullRequestEvent"
        pr = event.dig("payload", "pull_request")
        next unless pr
        merged = pr["merged_at"].present?
        {
          type: merged ? "PR Merged" : "PR Opened",
          repo: event["repo"]["name"],
          time: event["created_at"]
        }
      when "PushEvent"
        { type: "Pushed Commit", repo: event["repo"]["name"], time: event["created_at"] }
      end
    end.compact
  end
end
