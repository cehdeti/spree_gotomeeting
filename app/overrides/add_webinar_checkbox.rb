
Deface::Override.new(virtual_path: "spree/admin/products/_form", 
                     name: "adds_webinar_to_product",
                     insert_bottom: "[data-hook='admin_product_form_right']", 
                     partial: "spree/admin/products/webinar_fields")
