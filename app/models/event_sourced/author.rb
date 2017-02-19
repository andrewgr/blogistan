module EventSourced
  class Author
    include Potoroo::AggregateRoot
    include Potoroo::Projection

    attr_reader :name

    def create(name)
      raise(ArgumentError, 'name cannot be empty') if name.blank?
      emit AuthorCreated, name: name
    end

    apply(AuthorCreated) { |e| @name = e.name }
  end
end
