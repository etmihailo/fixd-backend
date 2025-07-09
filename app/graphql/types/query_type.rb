module Types
  class QueryType < Types::BaseObject
    field :github_events, GithubEventPageType, null: false do
      argument :username, String, required: true
      argument :page, Integer, required: false, default_value: 1
      argument :per_page, Integer, required: false, default_value: 10
    end

    def github_events(username:, page:, per_page:)
      events = GithubEventService.fetch(username)
      total_count = events.size
      total_pages = (total_count.to_f / per_page).ceil
      page = 1 if page < 1
      page = total_pages if page > total_pages && total_pages > 0

      start = (page - 1) * per_page
      paginated_events = events.slice(start, per_page) || []

      {
        events: paginated_events,
        current_page: page,
        total_pages: total_pages,
        total_count: total_count,
        has_next_page: page < total_pages,
        has_previous_page: page > 1
      }
    end

  end
end
