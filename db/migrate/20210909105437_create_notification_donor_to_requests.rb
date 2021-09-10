class CreateNotificationDonorToRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_donor_to_requests do |t|
      t.references :request, null: false, foreign_key: true
      t.references :donor, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
