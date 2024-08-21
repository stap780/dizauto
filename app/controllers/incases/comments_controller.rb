module Incases
  class CommentsController < CommentsController

    private

    def set_commentable
      @commentable = Incase.find(params[:incase_id])
    end
    
  end
  
end