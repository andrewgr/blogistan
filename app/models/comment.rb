class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :author

  validates :post, presence: true
  validates :author, presence: true
  validates :body, presence: true
end
