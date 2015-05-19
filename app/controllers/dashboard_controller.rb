class DashboardController < AdminController
  before_action :validate_group_by, except: [:index]

  def index
  end

  def users_created
    render json: User.send(:"group_by_#{@group_by}", :created_at).count
  end

  def users_device_platform
    render json: User.group(:device_platform).count
  end

  def users_status
    render json: User.group(:status).count
  end

  def messages_sent
    events_metric :messages_sent
  end

  def active_users
    events_metric :active_users
  end

  private

  def events_api
    EventsApi.new
  end

  def events_metric(metric)
    render json: events_api.metric_data(metric, group_by: @group_by)
  end

  private

  def validate_group_by
    @group_by = params[:group_by].try(:to_sym) || :day
    @group_by.in?(Groupdate::FIELDS) || render_error("invalid group_by value: #{@group_by.inspect}, valid fields are #{Groupdate::FIELDS}")
  end
end
