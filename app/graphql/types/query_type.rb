module Types
  class QueryType < Types::BaseObject
    field :github_events, [GithubEventType], null: false do
      argument :username, String, required: true
    end

    def github_events(username:)
      events = GithubEventService.fetch(username)
      events
    end
  end
end
