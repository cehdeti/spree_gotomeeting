object @webinar

node(:webinar_key) { |w| w.webinar_key }
node(:webinar_date) { |w| w.webinar_date }
node(:vimeo_id) { |w| w.vimeo_id }

extends "spree/api/v1/products/show"
