class AddIsWebinarToSpreeProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_products, :is_webinar, :boolean
  end
end
