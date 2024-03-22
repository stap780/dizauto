class NotificationsController < ApplicationController
    load_and_authorize_resource

    def index
        # @notifications = current_user.notifications.newest_first.includes(event: :record)
        @search = current_user.notifications.newest_first.includes(event: :record).ransack(params[:q])
        # @search.sorts = "id asc" if @search.sorts.empty?
        @notifications = @search.result.paginate(page: params[:page], per_page: 50)
    end

end