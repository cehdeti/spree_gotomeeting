class AddWebinarKeyToSpreeProduct < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_products, :webinar_key, :char
  end
end
