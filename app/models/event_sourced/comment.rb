module EventSourced
  class Comment
    include Potoroo::AggregateRoot
    include Potoroo::Projection

    attr_reader :post_id, :author_id, :body

    def post(post_id, author_id, body)
      emit CommentPosted, post_id: post_id, author_id: author_id, body: body
    end

    apply(CommentPosted) do |e|
      @post_id = e.post_id
      @author_id = e.author_id
      @body = e.body
    end
  end
end
