class DropTodos < ActiveRecord::Migration[7.0]
  def change
    drop_table :todos
  end
end
