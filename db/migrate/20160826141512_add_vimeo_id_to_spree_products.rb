class AddVimeoIdToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :vimeo_id, :integer
  end
end
