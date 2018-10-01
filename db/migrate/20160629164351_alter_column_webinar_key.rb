class AlterColumnWebinarKey < ActiveRecord::Migration[4.2]
  def change
    change_column(:spree_products, :webinar_key, :text, limit: 64)
  end
end
