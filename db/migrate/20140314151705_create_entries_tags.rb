class CreateEntriesTags < ActiveRecord::Migration
  def change
    create_table :entries_tags, id: false do |t|
      t.integer :entry_id
      t.integer :tag_id

      t.timestamps
    end

    add_index :entries_tags, :entry_id
    add_index :entries_tags, :tag_id
  end
end
