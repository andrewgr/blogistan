module EventSourced
  class Post
    include Potoroo::AggregateRoot
    include Potoroo::Projection

    def state
      @state
    end

    def create(author_id, body)
      emit PostCreated, author_id: author_id, body: body
    end

    apply(PostCreated) { |_| @state = :hidden }
  end
end
