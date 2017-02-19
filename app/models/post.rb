class Post < ApplicationRecord
  belongs_to :author

  validates :body, presence: true
  validates :author, presence: true
end
