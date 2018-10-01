class AddWebinarRegistration < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_webinar_registrations do |t|
      t.references :user
      t.references :product

      t.string  :registrant_key
      t.string :registration_status
      t.string :join_url
      t.timestamps null: false
    end
    add_index :spree_webinar_registrations, :user_id
    add_index :spree_webinar_registrations, :product_id
  end
end
