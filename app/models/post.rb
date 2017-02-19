class Post < ApplicationRecord
  belongs_to :author

  validates :body, presence: true
  validates :author, presence: true

  def deleted?
    deleted_at?
  end

  def published?
    published_at?
  end

  def publish
    update(published_at: DateTime.now)
  end

  def unpublish
    update(published_at: nil) unless deleted?
  end
end
