module EventSourced
  class Post
    include Potoroo::AggregateRoot
    include Potoroo::Projection

    attr_reader(
      :author_id,
      :body,
      :state,
      :published_at
    )

    def create(author_id, body)
      raise(ArgumentError, 'author_id cannot be empty') if author_id.blank?
      raise(ArgumentError, 'body cannot be empty')      if body.blank?

      emit PostCreated, author_id: author_id, body: body
    end

    apply(PostCreated) do |e|
      @state = :hidden
      @author_id = e.author_id
      @body = e.body
    end

    def publish
      raise(StandardError, 'cannot publish post that has not been created') unless state == :hidden
      emit PostPublished, published_at: DateTime.now
    end

    apply(PostPublished) do |e|
      @state = :published
      @published_at = e.published_at
    end
  end
end
