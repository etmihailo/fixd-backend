class GithubEventsController < ApplicationController
  include Pagy::Backend

  def index; end

  def create
    redirect_to github_event_path(params[:username])
  end

  def show
    @username = params[:username]
    Rails.logger.info "@@@@@@@@@@@@@@@@@#{@username}"
    events = Array.new(50) do |i|
      {
        id: i + 1,
        name: "#{@username}#{i + 1}"
      }
    end
    Rails.logger.info "!!!!!!!!!!!!!!!!!!!#{events}"

    @pagy, @paginated_events = pagy_array(events, items: 10)
  end
end
