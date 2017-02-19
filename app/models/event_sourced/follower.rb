module EventSourced
  class Follower
    include Potoroo::AggregateRoot
    include Potoroo::Projection

    attr_reader :followee_id, :author_id

    def follow(followee_id, author_id)

    end

    def unfollow

    end
  end
end
