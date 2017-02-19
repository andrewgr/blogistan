module EventSourced
  class Post
    include Potoroo::AggregateRoot
    include Potoroo::Projection

    def state
      @state
    end

    def create(author_id, body)
      raise(ArgumentError, 'author_id cannot be empty') if author_id.blank?
      raise(ArgumentError, 'body cannot be empty')      if body.blank?

      emit PostCreated, author_id: author_id, body: body
    end

    apply(PostCreated) { |_| @state = :hidden }
  end
end
