class GithubEventService
  GITHUB_API_URL = "https://api.github.com"

  def self.fetch(username)
    response = Faraday.get("#{GITHUB_API_URL}/users/#{username}/events/public")
    Rails.logger.info "$$$$$$$$$$$$$$#{response}"

    if response.success?
      response.body
    else
      []
    end
  end
end
