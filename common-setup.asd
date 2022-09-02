(defsystem #:common-setup
  :depends-on ()
  :components ((:file "packages")
               (:file "common")))

(defsystem #:common-setup.swank
  :depends-on (#:common-setup :swank)
  :components ((:file "swank")))

(defsystem #:common-setup.slynk
  :depends-on (#:common-setup :slynk)
  :components ((:file "slynk")))
