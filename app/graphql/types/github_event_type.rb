module Types
  class GithubEventType < Types::BaseObject
    field :type, String, null: false
    field :repo, String, null: false
    field :time, String, null: false
  end
end
