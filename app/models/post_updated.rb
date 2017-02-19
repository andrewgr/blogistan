class PostUpdated < Event
  define_method :author_id, -> { payload['author_id'] }
  define_method :updated_at, -> { payload['updated_at'] }
  define_method :body, -> { payload['body'] }
end
