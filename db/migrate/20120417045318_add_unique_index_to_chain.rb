class AddUniqueIndexToChain < ActiveRecord::Migration
  def up
    #execute "ALTER TABLE chains ADD UNIQUE user_id_habit_id_day (user_id,habit_id, day)"
    execute "CREATE UNIQUE INDEX user_id_habit_id_day ON chains (user_id, habit_id, day)"
  end

  def down
    execute "DROP INDEX user_id_habit_id_day"
  end
end
