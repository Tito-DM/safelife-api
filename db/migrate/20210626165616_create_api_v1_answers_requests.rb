class CreateApiV1AnswersRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :api_v1_answers_requests do |t|

      t.timestamps
    end
  end
end
