(in-package :dairyondemand)
(clsql:file-enable-sql-reader-syntax)


;(defun dod-controller-list-products ()
 ;   (if (is-dod-session-valid?)
;	(let ((prd-ini (initialize-products (get-login-company))) ; This will initialize all the; functions required for products
;		 ( dodproducts (select-products-by-company))
;		 (header (list  "Name" "Vendor" "Quantity Per Unit" "Unit Price")))
;	    (if dodproducts (ui-list-products header dodproducts) "No Products"))
;	(hunchentoot:redirect "/login")))




(defun ui-list-products (header data)
    (standard-page (:title "List DOD Products")
	(:h3 "Products") 
	(:table :class "table table-striped"  (:thead (:tr
							  (mapcar (lambda (item) (htm (:th (str item)))) header))) (:tbody
														       (mapcar (lambda (product)
																   (let ((prd-vendor  (product-vendor product)))
																       (htm (:tr 
																		(:td  :height "12px" (str (slot-value product 'prd-name)))
																		(:td  :height "12px" (str (slot-value prd-vendor 'name)))
																		(:td  :height "12px" (str (slot-value product  'qty-per-unit)))
																		(:td  :height "12px" (str (slot-value product 'unit-price)))
	     
																		(:td :height "12px" (:a :href  (format nil  "delproduct?id=~A" (slot-value product 'row-id)):onclick "return false" "Delete")
																		    (:a :href (format nil  "editproduct?id=~A" (slot-value product 'row-id)) :onclick "return false"  "Edit")
		 
																		    ))))) data)))))

(defun ui-list-prod-catg-dropdown (name catglist)
  (cl-who:with-html-output (*standard-output* nil)
    (htm (:select :class "form-control"  :name name  
      (loop for catg in catglist
	 do   (htm  (:option :value  (slot-value catg 'row-id) (str (slot-value catg 'catg-name)))))))))

(defun ui-list-yes-no-dropdown () 
(cl-who:with-html-output (*standard-output* nil) 
  (:select :class "form-control" :name "yesno"
	   (:option :value "N" "NO")
	   (:option :value "Y" "YES"))))
	   
(defun ui-list-prod-catg (catglist)
  (cl-who:with-html-output (*standard-output* nil :prologue t :indent t)
	(:div :class "row-fluid"	  (mapcar (lambda (prdcatg)
						      (htm (:div :class "col-sm-12 col-xs-12 col-md-6 col-lg-4" 
							       (:div :class "prdcatg-box"   (prdcatg-card prdcatg )))))
					     catglist))))


(defun ui-list-vendor-products (data)
  (cl-who:with-html-output (*standard-output* nil)
    	(:a :class "btn btn-primary" :role "button" :href "dodvenaddprodpage" (:span :class "glyphicon glyphicon-shopping-cart") " Add New Product  ")
	(:hr)
	(:div :class "row-fluid"	  (mapcar (lambda (product)
						      (htm (:div :class "col-sm-12 col-xs-12 col-md-6 col-lg-4" 
							       (:div :class "product-box"   (product-card-for-vendor  product )))))
					      data))))
  

(defun ui-list-customer-products (data lstshopcart)
  (cl-who:with-html-output-to-string (*standard-output* nil :prologue t :indent t)	
    (:div :id "finalResult"  
    (:div :class "row-fluid"	  (mapcar (lambda (product)
						      (htm (:div :class "col-sm-12 col-xs-12 col-md-6 col-lg-4" 
							       (:div :class "product-box"   (product-card product (prdinlist-p (slot-value product 'row-id)  lstshopcart))))))
					      data)))))


(defun product-card-shopcart (product-instance odt-instance)
    (let ((prd-name (slot-value product-instance 'prd-name))
	     (qty-per-unit (slot-value product-instance 'qty-per-unit))
	     (unit-price (slot-value product-instance 'unit-price))
	     (prd-image-path (slot-value product-instance 'prd-image-path))
	     (prd-id (slot-value product-instance 'row-id))
	     (prd-vendor (product-vendor product-instance)))
	(cl-who:with-html-output (*standard-output* nil)
	    (:form :class "form-shopcart"  :method "POST" :action "dodcustupdatecart" 
		(:div :class "row"
		    (:div :class "col-sm-6" 
					; Product image
			(:img  :src  (str (format nil "~A.png" prd-image-path)) :height "83" :width "100" :alt prd-name " "))
					;Remove button.
		    (:div :class "col-sm-6" :align "right"
			(htm (:a  :href (format nil "dodcustremshctitem?action=remitem&id=~A" prd-id) (:span :class "glyphicon glyphicon-remove")))))
					;Product name and other details
		(:div :class "row"
		    (:div :class "col-sm-6"
		(:h5 :class "product-name"  (str prd-name) )
			(:p  (str (format nil "  ~A. Fulfilled By: ~A" qty-per-unit (vendor-name prd-vendor)))))
					    (:div :class "col-sm-6"
			(:div  (:h3(:span :class "label label-default" (str (format nil "Rs. ~$"  unit-price))) ))))
		
		
		(:div :class "row"
		    (:div :class "col-sm-6"
			(:input :type "hidden" :name "prd-id" :value (format nil "~A" prd-id))
			(:input :class "form-control" :name "nprdqty" :value (slot-value odt-instance 'prd-qty) :type "text" :maxlength "2" ))
		    (:div :class "col-sm-6" 
			(:button :class "btn btn-sm btn-primary" :type "submit" "Update")))))))
	  

(defun prdcatg-card (prdcatg-instance)
    (let ((catg-name (slot-value prdcatg-instance 'catg-name))
	  (row-id (slot-value prdcatg-instance 'row-id)))
	(cl-who:with-html-output (*standard-output* nil)
		(:div :class "row"
		(:div :class "col-sm-12" (:a :href (format nil "dodproducts?id=~A" row-id) (str catg-name)))))))
		


	

(defun product-card-for-vendor (product-instance)
    (let ((prd-name (slot-value product-instance 'prd-name))
	  (unit-price (slot-value product-instance 'unit-price))
	  (description (slot-value product-instance 'description))
	  (prd-image-path (slot-value product-instance 'prd-image-path))
	  (prd-id (slot-value product-instance 'row-id))
	  (subscribe-flag (slot-value product-instance 'subscribe-flag)))
	    
	(cl-who:with-html-output (*standard-output* nil)
	  
		(:div :class "row"
		    
		(:div :class "col-xs-6" (:a :href (format nil "dodprddetailsforvendor?id=~A" prd-id)  (:img :src  (format nil "~A" prd-image-path) :height "83" :width "100" :alt prd-name " ")))
		(:div :class "col-xs-3" (:h3 (:span :class "label label-default" (str (format nil "Rs. ~$"  unit-price)))))
		(:div :class "col-xs-3" :align "right"
		  (:a :onclick "return DeleteConfirm();"  :href (format nil "dodvenddelprod?id=~A" prd-id) (:span :class "glyphicon glyphicon-remove"))))
				
		(:div :class "row"
		      (:div :class "col-xs-6"
			    (:h5 :class "product-name"  (str prd-name))))
		(:div :class "row"
		      (if (equal subscribe-flag "Y") (htm (:div :class "col-xs-6"  (:h5 (:span :class "label label-default" "Can be Subscribed"))))))
		(:div :class "row" 
		      (:div :class "col-xs-12" 
			    (:h6 (str (if (> (length description) 150)  (subseq description  0 150) description)))))
		
		)))

(defun product-card (product-instance prdincart-p)
    (let ((prd-name (slot-value product-instance 'prd-name))
	  (unit-price (slot-value product-instance 'unit-price))
	  (prd-image-path (slot-value product-instance 'prd-image-path))
	  (description (slot-value product-instance 'description))
	  (prd-id (slot-value product-instance 'row-id))
	  (subscribe-flag (slot-value product-instance 'subscribe-flag)))

	(cl-who:with-html-output (*standard-output* nil)
	  
		(:div :class "row"
		    
		(:div  :class "col-xs-6" (:a :href (format nil "dodprddetailsforcust?id=~A" prd-id) (:img :src  (format nil "~A" prd-image-path) :height "83" :width "100" :alt prd-name " ")))
		(:div  :class "col-xs-3"	(:div  (:h3 (:span :class "label label-default" (str (format nil "Rs. ~$"  unit-price)))))))

				
		(:div :class "row"
		      (:div :class "col-xs-12" 		(:h5 :class "product-name"  (str prd-name))))
		
		(:div :class "row"
			
			  (if (equal subscribe-flag "Y") (htm 
							(:form :class "form-subscribe" :method "POST" :action "dodprodsubscribe"
							       (:input :type "hidden" :name "prd-id" :value (format nil "~A" prd-id))
							(:div :class "col-xs-6"  (:button :data-toggle "tooltip" :title "Subscribe"  :class "btn btn-sm btn-primary" :name "btnsubscribe" :type "submit" (:span :class "glyphicon glyphicon glyphicon-hand-up") " Subscribe")))))

			  (if  prdincart-p (htm   (:div :class "col-xs-6"  (:a :class "btn btn-sm btn-success" :role "button"  :onclick "return false;" :href (format nil "javascript:void(0);") (:span :class "glyphicon glyphicon-ok"  ))))
			 ;else 
			 
		     (htm    (:form :class "form-product" :method "POST" :action "dodcustaddtocart" 
		      (:input :type "hidden" :name "prd-id" :value (format nil "~A" prd-id))
			  (:div  :class "col-xs-6"   (:button :data-toggle "tooltip" :title "Add to cart"  :class "btn btn-sm btn-primary" :type "submit" :name "btnaddtocart" (:span :class "glyphicon glyphicon-plus") " Add"))))) )

		(:div :class "row" 
		      (:div :class "col-xs-12 col-sm-12 col-md-12 col-lg-12" 
			    (:h6 (str (if (> (length description) 150)  (subseq description  0 150) description)))))
		
)))

(defun product-card-with-details-for-customer (product-instance prdincart-p)
    (let ((prd-name (slot-value product-instance 'prd-name))
	  (qty-per-unit (slot-value product-instance 'qty-per-unit))
	  (unit-price (slot-value product-instance 'unit-price))
	  (description (slot-value product-instance 'description))
	  (prd-image-path (slot-value product-instance 'prd-image-path))
	     (prd-id (slot-value product-instance 'row-id))
	     (prd-vendor (product-vendor product-instance)))
	(cl-who:with-html-output (*standard-output* nil)
	    (:div :class "container"
		(:div :class "row"
		    ; Product image only here
		    (:div :class "col-sm-12 col-xs-12 col-md-6 col-lg-6 image-responsive"
(:img :src  (format nil "~A" prd-image-path) :height "300" :width "400" :alt prd-name " "))
(:div :class "col-sm-12 col-xs-12 col-md-6 col-lg-6"
    	    (:form :class "form-product" :method "POST" :action "dodcustaddtocart" 
		(:h1  (str prd-name))
		(:div (str qty-per-unit))
		(:div (str (format nil "Supplier - "))  (:a :href (format nil  "dodvendordetails?id=~A" (slot-value prd-vendor 'row-id)) (str (vendor-name prd-vendor))))
		(:hr)
		(:div  (:h2 (:span :class "label label-default" (str (format nil "Rs. ~$"  unit-price))) ))
		(:hr)
		(:div (:h4 (str description)))
		(if  prdincart-p (htm (:a :class "btn btn-success" :role "button"  :onclick "return false;" :href (format nil "javascript:void(0);") (:span :class "glyphicon glyphicon-ok"  )))
		    (htm (:input :type "hidden" :name "prd-id" :value (format nil "~A" prd-id))
			(:input :type "hidden" :name "action" :value "addtocart")
			(:button :class "btn btn-primary" :type "submit" "Add To Cart"))))))))))



(defun product-card-with-details-for-vendor (product-instance)
    (let ((prd-name (slot-value product-instance 'prd-name))
	  (qty-per-unit (slot-value product-instance 'qty-per-unit))
	  (unit-price (slot-value product-instance 'unit-price))
	  (description (slot-value product-instance 'description))   
	  (prd-image-path (slot-value product-instance 'prd-image-path)))
	     

	(cl-who:with-html-output (*standard-output* nil)
	    (:div :class "container"
		(:div :class "row"
		    ; Product image only here
		    (:div :class "col-sm-12 col-xs-12 col-md-6 col-lg-6 image-responsive"
(:img :src  (format nil "~A" prd-image-path) :height "300" :width "400" :alt prd-name " "))
(:div :class "col-sm-12 col-xs-12 col-md-6 col-lg-6"
    	    (:form :class "form-product" :method "POST" :action "dodcustaddtocart" 
		(:h1  (str prd-name))
		(:div (str qty-per-unit))
		
		(:hr)
		(:div  (:h2 (:span :class "label label-default" (str (format nil "Rs. ~$"  unit-price))) ))
		(:hr)
				(:div (:h4 (str description)))
		)))))))

