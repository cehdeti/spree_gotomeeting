class ChangeIsWebinarToWebinar < ActiveRecord::Migration
  def change
    rename_column :spree_products, :is_webinar, :webinar
  end
end
