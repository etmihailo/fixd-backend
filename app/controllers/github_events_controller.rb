class GithubEventsController < ApplicationController
  include Pagy::Backend

  def index; end

  def create
    redirect_to github_event_path(params[:username])
  end

  def show
    @username = params[:username]
    events = GithubEventService.fetch(@username)

    @pagy, @paginated_events = pagy_array(events, items: 10)
  end
end
