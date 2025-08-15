class AddDefaultToIsCompletedTasks < ActiveRecord::Migration[7.1]
  def change
    change_column_default :tasks, :is_completed, from: nil, to: false
  end
end
