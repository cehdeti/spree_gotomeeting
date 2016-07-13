class AddIsWebinarToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :is_webinar, :boolean
  end
end
