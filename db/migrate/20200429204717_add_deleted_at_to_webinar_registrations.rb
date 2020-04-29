class AddDeletedAtToWebinarRegistrations < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_webinar_registrations, :deleted_at, :datetime
    add_index :spree_webinar_registrations, :deleted_at
  end
end
