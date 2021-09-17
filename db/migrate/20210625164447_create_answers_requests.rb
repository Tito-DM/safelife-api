class CreateAnswersRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :answers_requests, id: :uuid do |t|
      t.references :request, null: false, type: :uuid, foreign_key: true
      t.references :donor, null: false, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
