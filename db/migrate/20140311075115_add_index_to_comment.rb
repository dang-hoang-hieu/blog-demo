class AddIndexToComment < ActiveRecord::Migration
  def change
  	add_index :comments, :user_id
  	add_index :comments, :entry_id
  	add_index :comments, [:user_id, :entry_id]
  end
end
