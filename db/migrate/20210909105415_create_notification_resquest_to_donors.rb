class CreateNotificationResquestToDonors < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_resquest_to_donors do |t|
      t.references :request, null: false, foreign_key: true
      t.references :donor, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
