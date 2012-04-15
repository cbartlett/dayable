class CreateChains < ActiveRecord::Migration
  def change
    create_table :chains do |t|
      t.integer :user_id
      t.integer :habit_id
      t.datetime :day

      t.timestamps
    end
  end
end
