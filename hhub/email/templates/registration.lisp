(defmacro with-html-email-template ((&key title) &body body)
  `(cl-who:with-html-output-to-string (*standard-output* nil :prologue t :indent t)
    (:html :xmlns "http://www.w3.org/1999/xhtml"
     (:head
    (:meta :content "text/html; charset=UTF-8" :http-equiv "Content-Type")
    (:meta :content "telephone=no" :name "format-detection" )
    (:meta :content "width=device-width, initial-scale=1.0" :name "viewport")
    
    (:title ,title)
    (:link :href "https://fonts.googleapis.com/css?family=catamaran" :rel "stylesheet")
    
    (:style :type "text/css" ,*HHUB-EMAIL-CSS-CONTENTS*))
    (:body :style "margin:0; padding:0; background-color: #eeeeee;" :bgcolor "#eeeeee" 

	   (:table :width "100%" :cellpadding "0" :cellspacing "0" :border "1" :bgcolor "#eeeeee"
      (:div :class "Gmail" :style "height: 1px !important; margin-top: -1px !important; max-width: 600px !important; min-width: 600px !important; width: 600px !important;")
      (:div :style "display: none; max-height: 0px; overflow: hidden;"
        "Paste your preview text here***")
      (:div :style "display: none; max-height: 0px; overflow: hidden;" 
        "&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&zwnj;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")

      (:tr
        (:td :width "100%" :valign "top" :align "center" :class "padding-container" :style "padding: 18px 0px 0px 0px!important; mso-padding-alt: 18px 0px 0px 0px;"
          (:table :width "600" :cellpadding "0" :cellspacing "0" :border "1" :align "center" :class "wrapper" :bgcolor "#eeeeee"
            (:tr
              (:td :align "center" :bgcolor "#eeeeee"
                (:a :href "http://paulgoddarddesign.com/emails/material-design" :target "_blank" :style "font-size: 12px; line-height: 14px; font-weight: 500; font-family: 'Roboto Mono', monospace; color: #212121; text-decoration: underline;padding: 0px; border: 1px solid #eeeeee; display: inline-block;" "View Online"))))))
,@body)))))


(defun hhub-email-logo ()
(cl-who:with-html-output-to-string (*standard-output* nil :prologue t :indent t)
  (:tr
    (:td :width "100%" :valign "top" :align "center" :class "padding-container" :style "padding: 18px 0px 18px 0px!important; mso-padding-alt: 18px 0px 18px 0px;" 
	 (:table :width "600" :cellpadding "0" :cellspacing "0" :border "1" :align "center" :class "wrapper"
		 (:tr
		  (:td :align "center"
		       (:table :cellpadding "0" :cellspacing "0" :border "1" 
                  (:tr
                    (:td :width "100%" :valign "top" :align "center" 
                      (:table :width "600" :cellpadding "0" :cellspacing "0" :border "1" :align "center" :class "wrapper" :bgcolor "#eeeeee" 
                        (:tr 
                          (:td :align "center" 
                            (:table :width "600" :cellpadding "0" :cellspacing "0" :border "1" :class "container" :align "center" 
                              ; START HEADER IMAGE -- 
                              (:tr 
                                (:td :align "center" :class "hund" :width "600" 
     				     (:img :src "https://highrisehub.com/img/logo.png"  :width "300" :alt "Logo" :border "1" :style "max-width: 300px; display:block; " 
                                )))))))))))))))))

(defmacro with-single-column-email ((&key title) &body body)
 `(with-html-email-template (:title ,title)
  ;;;;;;;;;;;;;Put the logo here ;;;;;;;;;;;;;
   (cl-who:str (hhub-email-logo))
   (:tr
   (:td :width "100%" :valign "top" :align "center" :class "padding-container" :style "padding-top: 0px!important; padding-bottom: 18px!important; mso-padding-alt: 0px 0px 18px 0px;" 
	(:table :width "600" :cellpadding "0" :cellspacing "0" :border "1" :align "center" :class "wrapper" 
		(:tr
		 (:td 
		  (:table :cellpadding "0" :cellspacing "0" :border "1" 
			  (:tr
			   (:td :style ":border-radius: 3px; :border-bottom: 2px solid #d4d4d4;" :class "card-1" :width "100%" :valign "top" :align "center" 
				(:table :style ":border-radius: 3px;" :width "600" :cellpadding "0" :cellspacing "0" :border "1" :align "center" :class "wrapper" :bgcolor "#ffffff" 
					(:tr
					 (:td :align "center" 
					       (cl-who:str ,@body))))))))))))))

(defun customer-registration-html-content (customer verify-url)
  :documentation "You can insert any html table content here. It will be merged with the html display template on the upward journey" 
  (let* ((cust-name (slot-value customer 'name))
	(id (slot-value customer 'row-id)))
   (cl-who:with-html-output-to-string (*standard-output* nil :prologue t :indent t)
					      (:table :width "600" :cellpadding "0" :cellspacing "0" :border "1" :class "container" 
						      (:tr 
						       (:td :class "td-padding" :align "left" (cl-who:str (format nil "Welcome ~A!" cust-name)))
						       (:tr
							(:td :class "td-padding" :align "left" :style "font-family: 'Roboto Mono', monospace; color: #212121!important; font-size: 24px; line-height: 30px; padding-top: 18px; padding-left: 18px!important; padding-right: 18px!important; padding-bottom: 0px!important; mso-line-height-rule: exactly; mso-padding-alt: 18px 18px 0px 13px;" 
							     "Thank you for registering. We appreciate your memebership. "))
						
						       (:tr
							(:td :class "td-padding" :align "left" :style "font-family: 'Roboto Mono', monospace; color: #212121!important; font-size: 16px; line-height: 24px; padding-top: 18px; padding-left: 18px!important; padding-right: 18px!important; padding-bottom: 0px!important; mso-line-height-rule: exactly; mso-padding-alt: 18px 18px 0px 18px;" 
							     "Please click on the verification link below. "
							    ) )
						      						       
						       (:tr
							(:td :align "left" :style "padding: 18px 18px 18px 18px; mso-alt-padding: 18px 18px 18px 18px!important;" 
							     (:table :width "100%" :border "1" :cellspacing "0" :cellpadding "0" 
								     (:tr
								      (:td 
								       (:table :border "1" :cellspacing "0" :cellpadding "0" 
									       (:tr
										(:td :align "left" :style ":border-radius: 3px;" :bgcolor "#17bef7" 
										     (:a :class "button raised" :href verify-url :target "_blank" :style "font-size: 14px; line-height: 14px; font-weight: 500; font-family: Helvetica, Arial, sans-serif; color: #ffffff; text-decoration: none; :border-radius: 3px; padding: 10px 25px; :border: 1px solid #17bef7; display: inline-block;" "Activate Your Account") )))))))))))))
	   
(defmethod send-test-email (customer)
  (let* ((verify-url "http://highrisehub.com/hhub/account-activate")
	(reg-templ-str (hhub-read-file (format nil "~A/~A" *HHUB-EMAIL-TEMPLATES-FOLDER* *HHUB-CUST-REG-TEMPLATE-FILE*)))
	(cust-reg-email (format nil reg-templ-str (slot-value customer 'name)))) 
  (hhubsendmail "pawan.deshpande@gmail.com" "Welcome to highrisehub" cust-reg-email)))


