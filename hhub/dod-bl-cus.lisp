(in-package :dairyondemand)
(clsql:file-enable-sql-reader-syntax)



(defun list-cust-profiles (company)
 (with-database (dbinst *dod-dbconn-spec* :if-exists :old :pool t :database-type :mysql )
  (let ((tenant-id (slot-value company 'row-id)))
  (clsql:select 'dod-cust-profile  :where [and [= [:deleted-state] "N"] [= [:tenant-id] tenant-id]]  :database dbinst   :caching *dod-database-caching*  :flatp t ))))



(defun select-customer-by-name (name-like-clause company)
(let ((tenant-id (slot-value company 'row-id)))
  (car (clsql:select 'dod-cust-profile :where [and
		[= [:deleted-state] "N"]
		[= [:tenant-id] tenant-id]
		[like  [:name] name-like-clause]]
		:caching *dod-database-caching* :flatp t))))

(defun select-customer-by-phone (phone company)
(let ((tenant-id (slot-value company 'row-id)))
  (car (clsql:select 'dod-cust-profile :where [and
		[= [:deleted-state] "N"]
		[= [:tenant-id] tenant-id]
		[like  [:phone] phone]]
		:caching *dod-database-caching* :flatp t))))


(defun duplicate-customerp(phone company)
  (if (select-customer-by-phone phone company) T NIL))
    

(defun select-customer-by-id (id company)
(let ((tenant-id (slot-value company 'row-id)))
  (car (clsql:select 'dod-cust-profile :where [and
		[= [:deleted-state] "N"]
		[= [:tenant-id] tenant-id]
		[=  [:row-id] id]]
		:caching *dod-database-caching* :flatp t))))



(defun select-deleted-customer-by-id (id company)
(let ((tenant-id (slot-value company 'row-id)))
  (car (clsql:select 'dod-cust-profile :where [and
		[= [:deleted-state] "Y"]
		[= [:tenant-id] tenant-id]
		[=  [:row-id] id]]
		:caching *dod-database-caching* :flatp t))))


(defun delete-customer (object)
  (let ((cust-id (slot-value object 'row-id))
	 (tenant-id (slot-value object 'tenant-id)))
	 (delete-cust-profile cust-id tenant-id)))

(defun restore-deleted-customer (object)
  (let ((cust-id (slot-value object 'row-id))
	(tenant-id (slot-value object 'tenant-id)))
    (restore-deleted-cust-profile (list cust-id) tenant-id)))

    

(defun delete-cust-profile( id tenant-id )
  (let ((dodcust (car (clsql:select 'dod-cust-profile :where [and [= [:row-id] id] [= [:tenant-id] tenant-id]] :flatp t :caching *dod-database-caching*))))
    (setf (slot-value dodcust 'deleted-state) "Y")
    (clsql:update-record-from-slot dodcust 'deleted-state)))

(defun delete-cust-profiles ( list company)
(let ((tenant-id (slot-value company 'row-id)))  
  (mapcar (lambda (id)  (let ((doduser (car (clsql:select 'dod-cust-profile :where [and [= [:row-id] id] [= [:tenant-id] tenant-id]] :flatp t :caching *dod-database-caching*))))
			  (setf (slot-value doduser 'deleted-state) "Y")
			  (clsql:update-record-from-slot doduser  'deleted-state))) list )))


(defun restore-deleted-cust-profile ( list tenant-id )
(mapcar (lambda (id)  (let ((doduser (car (clsql:select 'dod-cust-profile :where [and [= [:row-id] id] [= [:tenant-id] tenant-id]] :flatp t :caching *dod-database-caching*))))
    (setf (slot-value doduser 'deleted-state) "N")
    (clsql:update-record-from-slot doduser 'deleted-state))) list ))


(defun create-customer(name address phone  email birthdate password salt city state zipcode company  )
  (let ((tenant-id (slot-value company 'row-id)))
 (clsql:update-records-from-instance (make-instance 'dod-cust-profile
						    :name name
						    :address address
						    :email email 
						    :password password 
						    :salt salt
						    :birthdate birthdate 
						    :phone phone
						    :city city 
						    :state state 
						    :zipcode zipcode
						    :tenant-id tenant-id
						    :deleted-state "N"))))
 




;;;;; Customer wallet related functions ;;;;;


(defun create-wallet(customer vendor company  )
  (let ((tenant-id (slot-value company 'row-id))
	(cust-id (slot-value customer 'row-id))
	(vendor-id (slot-value vendor 'row-id)))
    (persist-wallet cust-id vendor-id tenant-id)))

(defun persist-wallet (cust-id vendor-id tenant-id)
 (clsql:update-records-from-instance (make-instance 'dod-cust-wallet
						    :cust-id cust-id
						    :vendor-id vendor-id 
						    :tenant-id tenant-id
				    		    :deleted-state "N")))

(defun check-wallet-balance (amount customer-wallet)
(let ((cur-balance (slot-value customer-wallet  'balance)))
  (if (> cur-balance amount) T nil)))

(defun check-low-wallet-balance (customer-wallet) 
(if (< (slot-value customer-wallet 'balance) 50.00) T nil))

(defun check-zero-wallet-balance (customer-wallet)
(if (< (slot-value customer-wallet 'balance) 0.00) T nil)) 


(defun deduct-wallet-balance (amount customer-wallet)
(let ((cur-balance (slot-value customer-wallet 'balance)))
(progn  (setf (slot-value customer-wallet 'balance) (- cur-balance amount))
  (clsql:update-record-from-slot customer-wallet 'balance))))

(defun set-wallet-balance (amount customer-wallet)
 (progn  (setf (slot-value customer-wallet 'balance) amount)
	 (clsql:update-record-from-slot customer-wallet 'balance)))

(defun get-cust-wallet-by-vendor (customer vendor company) 
  (let ((tenant-id (slot-value company 'row-id))
	(cust-id (slot-value customer 'row-id))
	(vendor-id (slot-value vendor 'row-id)))
  (car (clsql:select 'dod-cust-wallet :where [and
		[= [:deleted-state] "N"]
		[= [:tenant-id] tenant-id]
		[= [:cust-id] cust-id]
		[=  [:vendor-id] vendor-id]]
		:caching *dod-database-caching* :flatp t))))

(defun get-cust-wallets (customer company) 
  (let ((tenant-id (slot-value company 'row-id))
	(cust-id (slot-value customer 'row-id)))
   (clsql:select 'dod-cust-wallet :where [and
		[= [:deleted-state] "N"]
		[= [:tenant-id] tenant-id]
		[= [:cust-id] cust-id]]
		:caching *dod-database-caching* :flatp t)))





(defun get-cust-wallet-by-id (id company) 
  (let ((tenant-id (slot-value company 'row-id)))
	
   (car (clsql:select 'dod-cust-wallet :where [and
		[= [:deleted-state] "N"]
		[= [:tenant-id] tenant-id]
		[= [:row-id] id]]
	
		:caching *dod-database-caching* :flatp t))))



