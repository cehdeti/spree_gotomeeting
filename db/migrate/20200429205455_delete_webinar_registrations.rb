class DeleteWebinarRegistrations < ActiveRecord::Migration[5.2]
  def up
    [:spree_products, :spree_users].each do |table|
      execute("
        UPDATE spree_webinar_registrations AS wr
        SET deleted_at = r.deleted_at
        FROM #{table} AS r
        WHERE wr.product_id = r.id AND r.deleted_at IS NOT NULL
      ")
    end
  end
end
