class CreateAnswersRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :answers_requests do |t|
      t.references :request, null: false, foreign_key: true
      t.references :donor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
