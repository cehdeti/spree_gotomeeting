class AddWebinarDateToSpreeProduct < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_products, :webinar_date, :datetime
  end
end
