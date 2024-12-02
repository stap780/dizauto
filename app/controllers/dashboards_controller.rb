#  encoding : utf-8
#  dashboard values
#  
class DashboardsController < ApplicationController
  load_and_authorize_resource
  before_action :set_dashboard, only: %i[show edit update destroy]
  before_action :product_created_at_count_chart_data

  def index
    @chart_data, @chart_options = product_created_at_count_chart_data
    @orders_data = orders_info
    @sale_chart_data, @sale_chart_options = collect_sale_chart_data
  end

  def fullsearch
    if params[:query].present?
      @search_results = Dashboard.search(params[:query])
      render turbo_stream: turbo_stream.replace('fullsearch_result', partial: 'dashboards/search/result')
    else
      render turbo_stream: turbo_stream.replace('fullsearch_result', partial: 'dashboards/search/result_empty')
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
        label: 'Появление товаров',
        fill: true,
        backgroundColor: 'transparent',
        borderColor: '#3B82F6',
        data: created_at_products_count_per_day
      }]
    }
    chart_options = {
      maintainAspectRatio: false,
      legend: {
        display: false
      },
      tooltips: {
        intersect: false
      },
      hover: {
        intersect: true
      },
      plugins: {
        filler: {
          propagate: false
        }
      },
      scales: {
        xAxes: [{
          reverse: true,
          gridLines: {
            color: 'rgba(0,0,0,0.0)'
          }
        }],
        yAxes: [{
          ticks: {
            stepSize: 1000
          },
          display: true,
          borderDash: [3, 3],
          gridLines: {
              color: 'rgba(0,0,0,0.0)',
              fontColor: '#fff'
          }
        }]
      }
    }
    [chart_data, chart_options]
  end

  def orders_info
    hash = {}
    order_count = Order.all.count
    hash[:count] = order_count
    today = Date.today
    this_week = Order.where(created_at: (today.beginning_of_week..today))
    this_week_count = this_week.count.zero? ? 1 : this_week.count
    # puts "this_week_count => #{this_week_count}"
    last_week = Order.where(created_at: (today.last_week.beginning_of_week..today.last_week.end_of_week))
    last_week_count = last_week.count.zero? ? 1 : last_week.count
    # puts "last_week_count => #{last_week_count}"
    procent = last_week_count.zero? ? ((this_week_count / 1.0 - 1) * 100).round(2) : ((this_week_count / last_week_count.to_f - 1) * 100).round(2)
    hash[:procent] = procent
    # puts hash
    hash
  end

  def collect_sale_chart_data
    chart_data = {
      labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
      datasets: [{
        label: 'сумма',
        backgroundColor: '#3B7DDD',
        borderColor: '#3B7DDD',
        hoverBackgroundColor: '#3B7DDD',
        hoverBorderColor: '#3B7DDD',
        data: [54, 67, 41, 55, 62, 45, 55, 73, 60, 76, 48, 79],
        barPercentage: 0.75,
        categoryPercentage: 0.5
      }]
    }
    chart_options = {
      maintainAspectRatio: false,
      legend: {
        display: false
      },
      scales: {
        yAxes: [{
          gridLines: {
            display: false
          },
          stacked: false,
          ticks: {
            stepSize: 20
          }
        }],
        xAxes: [{
          stacked: false,
          gridLines: {
            color: 'transparent'
          }
        }]
      }
    }
    [chart_data, chart_options]
  end

end
