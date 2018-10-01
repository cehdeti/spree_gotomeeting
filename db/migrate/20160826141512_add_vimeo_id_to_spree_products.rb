class AddVimeoIdToSpreeProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_products, :vimeo_id, :integer
  end
end
