class PostPublished < Event
  define_method :published_at, -> { payload['published_at'] }
end
