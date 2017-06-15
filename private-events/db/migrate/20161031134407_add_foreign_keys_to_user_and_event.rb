class AddForeignKeysToUserAndEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :creator_id, :integer
    remove_column :users, :created_event_id
  end
end
