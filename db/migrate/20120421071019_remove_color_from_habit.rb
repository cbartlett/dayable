class RemoveColorFromHabit < ActiveRecord::Migration
  def up
    remove_column :habits, :color
      end

  def down
    add_column :habits, :color, :integer
  end
end
