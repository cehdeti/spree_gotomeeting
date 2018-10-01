class ChangeIsWebinarToWebinar < ActiveRecord::Migration[4.2]
  def change
    rename_column :spree_products, :is_webinar, :webinar
  end
end
