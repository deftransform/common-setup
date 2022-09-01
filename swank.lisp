(in-package :common-setup)

#+(and sbcl swank)
(defmethod setup-editor ((_ (eql :swank)))
  (sb-ext:*ed-functions*))
