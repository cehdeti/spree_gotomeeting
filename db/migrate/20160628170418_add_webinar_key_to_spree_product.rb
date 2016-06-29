class AddWebinarKeyToSpreeProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :webinar_key, :char
  end
end
