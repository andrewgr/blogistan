module EventSourced
  class CommentRating
    include Potoroo::AggregateRoot
    include Potoroo::Projection

    attr_reader :comment_id, :author_id, :rating

    def rate(author_id, comment_id, rating)

    end

    def unrate

    end
  end
end
