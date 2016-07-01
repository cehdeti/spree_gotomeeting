object @webinar_registration
node(:product_id) { |w| w.product_id }
node(:webinar_key) { |w| w.product.webinar_key }
node(:webinar_date) { |w| w.product.webinar_date }

node(:user_id) { |w| w.user_id }
node(:registration_date) { |w| w.updated_at }
node(:registrant_key) { |w| w.registrant_key }
node(:join_url) { |w| w.join_url }
node(:registration_status) { |w| w.registration_status }