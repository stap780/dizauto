module Orders
  # CommentsController < CommentsController
  class CommentsController < CommentsController

    private

    def set_commentable
      @commentable = Order.find(params[:order_id])
    end

  end
  
end