class DashboardsController < ApplicationController
  load_and_authorize_resource
  before_action :set_dashboard, only: %i[show edit update destroy]
  before_action :product_created_at_count_chart_data

  # GET /dashboards or /dashboards.json
  def index
    @chart_data, @chart_options = product_created_at_count_chart_data
  end

  def fullsearch
    if params[:query].present?
      @search_results = Dashboard.search(params[:query])
      render turbo_stream: turbo_stream.replace("fullsearch_result", partial: "dashboards/search/result")
    else
      render turbo_stream: turbo_stream.replace("fullsearch_result", partial: "dashboards/search/result_empty")
    end
  end

  def product_created_at_count_chart
    @chart_data, @chart_options = product_created_at_count_chart_data
    respond_to do |format|
      # flash.now[:success] = t(".success")
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('product_created_at_count_chart_canvas', partial: '/dashboards/charts/product/created_at_count_canvas' )
        ]
      end
    end
  end

  private

  # # Use callbacks to share common setup or constraints between actions.
  # def set_dashboard
  #   @dashboard = Dashboard.find(params[:id])
  # end

  # # Only allow a list of trusted parameters through.
  # def dashboard_params
  #   params.fetch(:dashboard, {})
  # end
  def product_created_at_count_chart_data
    start_param = params[:product_created_at_count_chart_start_at]
    end_param = params[:product_created_at_count_chart_end_at]
    start_day = start_param.present? ? start_param.to_date : 1.month.ago.to_date
    end_day = end_param.present? ? end_param.to_date : Date.today

    period = (start_day..end_day)
    month_dates = period.map(&:to_s)
    month_days = period.map { |d| d.day }
    created_at_products_count_per_day = month_dates.map { |d| Product.where(created_at: (Time.new(d).beginning_of_day..Time.new(d).end_of_day)).count }
    chart_data = {
      labels: month_days,  # %w[January February March April May June July],
      datasets: [{
        label: "\u041F\u043E\u044F\u0432\u043B\u0435\u043D\u0438\u0435 \u0442\u043E\u0432\u0430\u0440\u043E\u0432",
        backgroundColor: "transparent",
        borderColor: "#3B82F6",
        data: created_at_products_count_per_day
      }]
    }
    chart_options = {
      scales: {
        yAxes: [{
          ticks: {
            beginAtZero: true
          }
        }]
      }
    }
    [chart_data, chart_options]
  end

end
