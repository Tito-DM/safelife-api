class CreateDonors < ActiveRecord::Migration[6.0]
  def change
    create_table :donors, id: :uuid do |t|
      t.references :user, null: false, type: :uuid, foreign_key: true
      t.date :birthdate
      t.float :weight
      t.string :blood
      t.integer :status
      t.string :province
      t.string :gender

      t.timestamps
    end
  end
end
