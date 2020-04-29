class AddVimeoIdToSpreeProducts < ActiveRecord::Migration[4.2]
  def up
    add_column :spree_products, :vimeo_id, :integer unless ActiveRecord::Base.connection.column_exists?(:spree_products, :vimeo_id)
  end

  def down
    remove_column :spree_products, :vimeo_id if ActiveRecord::Base.connection.column_exists?(:spree_products, :vimeo_id)
  end
end
