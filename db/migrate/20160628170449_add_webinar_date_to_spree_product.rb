class AddWebinarDateToSpreeProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :webinar_date, :datetime
  end
end
