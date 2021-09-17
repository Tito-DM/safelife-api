class CreateNotificationResquestToDonors < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_resquest_to_donors, id: :uuid do |t|
      t.references :request, null: false, type: :uuid, foreign_key: true
      t.references :donor, null: false, type: :uuid, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
