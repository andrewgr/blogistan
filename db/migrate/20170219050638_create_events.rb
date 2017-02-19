class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :type, null: false
      t.uuid :aggregate_id, null: false
      t.jsonb :payload, null: false

      t.datetime :created_at, null: false
    end
  end
end
