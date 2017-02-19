class CommentPosted < Event
  define_method :post_id,   -> { payload['post_id'] }
  define_method :author_id, -> { payload['author_id'] }
  define_method :body,      -> { payload['body'] }
end
