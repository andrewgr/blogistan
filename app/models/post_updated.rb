class PostUpdated < Event
  define_method :updated_at, -> { payload['updated_at'] }
  define_method :body, -> { payload['body'] }
end
