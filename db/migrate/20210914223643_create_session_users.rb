class CreateSessionUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :session_users do |t|
      t.text :token

      t.timestamps
    end
  end
end
