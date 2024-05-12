class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  include ActionView::RecordIdentifier

  after_create_commit do 
    broadcast_append_to [commentable, :comments], target: dom_id(commentable, :comments), 
                                                  partial: "comments/comment", 
                                                  locals: { comment: self, commentable: commentable, admin: false, user: false }
    broadcast_update_to [commentable, :comments], target: dom_id(commentable, dom_id(Comment.new)), html: ''

    
    broadcast_append_to [commentable, :comments, user&.to_gid_param], target: "controls_#{dom_id(commentable, dom_id(self))}", 
                                                          partial: "comments/user_controls", 
                                                          locals: { comment: self, commentable: commentable, admin: false, user: true}
                   
    broadcast_append_to [commentable, :comments, :admin], target: "controls_#{dom_id(commentable, dom_id(self))}", 
                                                          partial: "comments/admin_controls", 
                                                          locals: { comment: self, commentable: commentable, admin: true, user: false  }
  end
  
  after_update_commit do
    broadcast_replace_to [commentable, :comments], target: dom_id(commentable, dom_id(self)), 
                                                    partial: "comments/comment", 
                                                    locals: { comment: self, commentable: commentable, admin: false }
  end

  after_destroy_commit do
    broadcast_remove_to [commentable, :comments], target: dom_id(commentable, dom_id(self))
  end

end
