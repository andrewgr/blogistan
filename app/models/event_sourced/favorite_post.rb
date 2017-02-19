module EventSourced
  class FavoritePost
    include Potoroo::AggregateRoot
    include Potoroo::Projection

    attr_reader :post_id, :author_id

    def favorite(post_id, author_id)

    end

    def unfavorite

    end
  end
end
