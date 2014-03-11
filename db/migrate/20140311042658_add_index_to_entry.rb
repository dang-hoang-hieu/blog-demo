class AddIndexToEntry < ActiveRecord::Migration
  def change
  	add_index :entries, :id
  end
end
