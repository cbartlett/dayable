class CreateHabits < ActiveRecord::Migration
  def change
    create_table :habits do |t|
      t.string :content
      t.integer :color
      t.integer :user_id

      t.timestamps
    end
  end
end
