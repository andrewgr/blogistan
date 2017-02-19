module EventSourced
  class Author
    include Potoroo::AggregateRoot
    include Potoroo::Projection

    attr_reader :name

    def create(name)
      emit AuthorCreated, name: name
    end

    apply(AuthorCreated) { |e| @name = e.name }
  end
end
