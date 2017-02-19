module EventSourced
  class Post
    include Potoroo::AggregateRoot
    include Potoroo::Projection

    attr_reader(
      :body,
      :state,
      :created_at,
      :published_at,
      :deleted_at,
      :updated_at
    )

    def update(author_id, body)
      raise(StandardError, 'cannot update post that has been deleted') if deleted?
      raise(ArgumentError, 'author_id cannot be empty') if author_id.blank?
      raise(ArgumentError, 'body cannot be empty')      if body.blank?

      emit PostUpdated, author_id: author_id, body: body, updated_at: DateTime.now
    end

    apply(PostCreated) do |e|
      @state = :hidden if @state.nil?
      @created_at = e.created_at if author_ids.empty?
      (@author_ids ||= []) << e.author_id
      @body = e.body
      @updated_at = e.updated_at
    end

    apply(PostUpdated) do |e|
      @state = :hidden if @state.nil?
      @created_at = e.updated_at if author_ids.empty?
      (@author_ids ||= []) << e.author_id
      @body = e.body
      @updated_at = e.updated_at
    end

    def author_ids
      (@author_ids ||= []).uniq
    end

    def publish
      raise(StandardError, 'cannot publish post that has not been created') if state == nil
      return self if state == :published
      emit PostPublished, published_at: DateTime.now
    end

    apply(PostPublished) do |e|
      @state = :published
      @published_at = e.published_at
    end

    def unpublish
      raise(StandardError, 'cannot unpublish post that has not been created') if state == nil
      raise(StandardError, 'cannot unpublish post that has been deleted') if deleted?
      return self if state == :hidden

      emit PostUnpublished
    end

    apply(PostUnpublished) do |e|
      @state = :hidden
      @published_at = nil
    end

    def published?
      state == :published
    end

    def delete
      raise(StandardError, 'cannot delete post that has not been created') if state == nil
      return self if state == :deleted

      emit PostDeleted, deleted_at: DateTime.now
    end

    apply(PostDeleted) do |e|
      @state = :deleted
      @published_at = nil
      @deleted_at = e.deleted_at
    end

    def deleted?
      state == :deleted
    end
  end
end
