(in-package :dairyondemand)
(clsql:file-enable-sql-reader-syntax)


(defun dod-controller-list-products ()
    (if (is-dod-session-valid?)
	(let ((prd-ini (initialize-products (get-login-company))) ; This will initialize all the functions required for products
		 ( dodproducts (select-products-by-company))
		 (header (list  "Name" "Vendor" "Quantity Per Unit" "Unit Price")))
	    (if dodproducts (ui-list-products header dodproducts) "No Products"))
	(hunchentoot:redirect "/login")))




(defun ui-list-products (header data)
    (standard-page (:title "List DOD Products")
	(:h3 "Products") 
	(:table :class "table table-striped"  (:thead (:tr
							  (mapcar (lambda (item) (htm (:th (str item)))) header))) (:tbody
														       (mapcar (lambda (product)
																   (let ((prd-vendor  (get-prd-vendor product)))
																       (htm (:tr 
																		(:td  :height "12px" (str (slot-value product 'prd-name)))
																		(:td  :height "12px" (str (slot-value prd-vendor 'name)))
																		(:td  :height "12px" (str (slot-value product  'qty-per-unit)))
																		(:td  :height "12px" (str (slot-value product 'unit-price)))
	     
																		(:td :height "12px" (:a :href  (format nil  "/delproduct?id=~A" (slot-value product 'row-id)):onclick "return false" "Delete")
																		    (:a :href (format nil  "/editproduct?id=~A" (slot-value product 'row-id)) :onclick "return false"  "Edit")
		 
																		    ))))) data)))))
(defun ui-list-customer-products (header data lstshopcart)
    (cl-who:with-html-output (*standard-output* nil)
	(:div :class "row-fluid"	  (mapcar (lambda (product)
						      (htm (:div :class "col-sm-12 col-xs-12 col-md-6 col-lg-3" 
							       (:div :class "thumbnail" (product-card product (prdinlist-p (slot-value product 'row-id)  lstshopcart))))))
					      data))))


(defun product-card-shopcart (product-instance odt-instance)
    (let ((prd-name (slot-value product-instance 'prd-name))
	     (qty-per-unit (slot-value product-instance 'qty-per-unit))
	     (unit-price (slot-value product-instance 'unit-price))
	     (prd-image-path (slot-value product-instance 'prd-image-path))
	     (prd-id (slot-value product-instance 'row-id))
	     (prd-vendor (get-prd-vendor product-instance)))
	(cl-who:with-html-output (*standard-output* nil)
	    (:form :class "form-shopcart"  :method "POST" :action "dodcustupdatecart" 
		(:div :class "row"
		    (:div :class "col-sm-6" 
					; Product image
			(:img :class "img-responsive" :src  prd-image-path :alt prd-name " "))
					;Remove button.
		    (:div :class "col-sm-6" :align "right"
			(htm (:a  :href (format nil "/dodcustremshctitem?action=remitem&id=~A" prd-id) (:span :class "glyphicon glyphicon-remove")))))
					;Product name and other details
		(:div :class "row"
		    (:div :class "col-sm-6"
		(:h5  (str prd-name) )
			(:p  (str (format nil "  ~A.    Fulfilled By: ~A" qty-per-unit (vendor-name prd-vendor)))))
					    (:div :class "col-sm-6"
			(:div  (:h3(:span :class "label label-default" (str (format nil "Rs. ~A"  unit-price))) ))))
		
		
		(:div :class "row"
		    (:div :class "col-sm-6"
			(:input :type "hidden" :name "prd-id" :value (format nil "~A" prd-id))
			(:input :class "form-control" :name "nprdqty" :value (slot-value odt-instance 'prd-qty) :type "text" :maxlength "1" ))
		    (:div :class "col-sm-6" 
			(:button :class "btn btn-primary" :type "submit" "Update")))))))
	  

(defun product-card (product-instance prdincart-p)
    (let ((prd-name (slot-value product-instance 'prd-name))
	     (qty-per-unit (slot-value product-instance 'qty-per-unit))
	     (unit-price (slot-value product-instance 'unit-price))
	     (prd-image-path (slot-value product-instance 'prd-image-path))
	     (prd-id (slot-value product-instance 'row-id))
	     (prd-vendor (get-prd-vendor product-instance)))
	(cl-who:with-html-output (*standard-output* nil)
	    (:form :class "form-product" :method "POST" :action "dodcustaddtocart" 
		(:h4 (str prd-name) )
		(:img :class "card-img-top img-responsive" :src  prd-image-path :alt prd-name " ")
		(:div (str qty-per-unit))
		(:div  (str (format nil "Fulfilled By: ~A" (vendor-name prd-vendor))))
		(:div  (:h4(:span :class "label label-default" (str (format nil "Rs. ~A"  unit-price))) ))
		(if  prdincart-p (htm (:a :class "btn btn-success" :role "button"  :onclick "return false;" :href (format nil "javascript:void(0);") (:span :class "glyphicon glyphicon-ok"  )))
		    (htm (:input :type "hidden" :name "prd-id" :value (format nil "~A" prd-id))
			(:input :type "hidden" :name "action" :value "addtocart")
			(:button :class "btn btn-primary" :type "submit" "Add")))))))
		  
