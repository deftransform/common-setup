(in-package :common-setup)

(defmacro one (&body body)
  (unless (= 1 (length body))
    (error "More than one expression"))
  (first body))

