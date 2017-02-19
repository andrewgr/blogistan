class PostDeleted < Event
  define_method :deleted_at, -> { payload['deleted_at'] }
end
