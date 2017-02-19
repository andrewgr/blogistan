class AuthorCreated < Event
  define_method :name, -> { payload['name'] }
end
