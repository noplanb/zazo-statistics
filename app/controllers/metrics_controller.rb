class MetricsController < AdminController
  before_action :validate_group_by, only: [:show]

  def index
    metrics_list = events_api.metric_list
    @metrics = metrics_list.is_a?(Array) && Settings.allowed_metrics.each_with_object([]) do |name, memo|
      metric = metrics_list.find { |m| m['name'] == name }
      memo << Metric.new(metric) if metric
    end
  end

  def show
    events_metric params[:id]
  end

  private

  def events_metric(metric)
    render json: events_api.metric_data(metric, group_by: @group_by)
  end

  def validate_group_by
    @group_by = params[:group_by].try(:to_sym) || :day
    @group_by.in?(Groupdate::FIELDS) || render_error("invalid group_by value: #{@group_by.inspect}, valid fields are #{Groupdate::FIELDS}")
  end
end
