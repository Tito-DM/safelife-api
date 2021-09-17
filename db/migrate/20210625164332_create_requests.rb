class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests, id: :uuid do |t|
      t.references :user, null: false, type: :uuid, foreign_key: true
      t.integer :type_request
      t.string :description
      t.string :province
      t.date :date_limit

      t.timestamps
    end
  end
end
