object @webinar

node(:webinar_key) { |w| w.webinar_key }
node(:webinar_date) { |w| w.webinar_date }

extends "spree/api/v1/products/show"
