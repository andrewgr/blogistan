class PostCreated < Event
  define_method :author_id, -> { payload['author_id'] }
  define_method :body,      -> { payload['body'] }
end
