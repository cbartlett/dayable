class ChangeDayToDate < ActiveRecord::Migration
  def up
    execute "ALTER TABLE chains ALTER COLUMN day TYPE date"
  end

  def down
    execute "ALTER TABLE chains ALTER COLUMN day TYPE timestamp"
  end
end
