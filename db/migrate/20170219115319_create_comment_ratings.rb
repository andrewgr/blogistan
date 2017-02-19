class CreateCommentRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :comment_ratings do |t|
      t.references :comment, foreign_key: true
      t.references :author, foreign_key: true
      t.string :rating

      t.timestamps
    end
  end
end
