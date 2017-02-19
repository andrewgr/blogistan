class Follower < ApplicationRecord
  belongs_to :author
  belongs_to :followee, class_name: Author
end
