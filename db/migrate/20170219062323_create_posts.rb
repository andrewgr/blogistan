class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.references :author, foreign_key: true, null: false
      t.text :body, null: false
      t.string :state

      t.timestamps
    end
  end
end
