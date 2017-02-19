class CommentRating < ApplicationRecord
  belongs_to :comment
  belongs_to :author
end
