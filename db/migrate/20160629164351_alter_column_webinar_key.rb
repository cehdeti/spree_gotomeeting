class AlterColumnWebinarKey < ActiveRecord::Migration
  def change
    change_column(:spree_products, :webinar_key, :text, limit: 64)
  end
end
