class CreateFollowers < ActiveRecord::Migration[5.0]
  def change
    create_table :followers do |t|
      t.references :author, foreign_key: true
      t.integer :followee_id, null: false
      t.datetime :deleted_at

      t.timestamps
    end

    add_foreign_key :followers, :authors, column: :followee_id
  end
end
