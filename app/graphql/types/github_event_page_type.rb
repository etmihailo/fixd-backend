module Types
  class GithubEventPageType < Types::BaseObject
    field :events, [GithubEventType], null: false
    field :current_page, Integer, null: false
    field :total_pages, Integer, null: false
    field :total_count, Integer, null: false
    field :has_next_page, Boolean, null: false
    field :has_previous_page, Boolean, null: false
  end
end
