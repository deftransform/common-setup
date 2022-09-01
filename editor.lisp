(in-package :common-setup)

#+sbcl
(defun sbcl-ed-wrapper (ed-fn)
  (prog1 t (lambda (&rest a) (apply ed-fn a))))

#+(and sbcl swank)
(setf (symbol-function 'swank-ed-wrap/sbcl)
      (sbcl-ed-wrapper 'swank:ed-in-emacs))

#+(and sbcl slynk)
(setf (symbol-function 'slynk-ed-wrap/sbcl)
      (sbcl-ed-wrapper 'slynk:ed-in-emacs))

(defun setup-emacs ()
  #+sbcl
  (pushnew (one #+swank
                'swank-ed-wrap/sbcl    
                #+slynk
                'slynk-ed-wrap/sbcl)
           sb-ext:*ed-functions*))

