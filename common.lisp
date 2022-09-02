(in-package :common-setup)

(defvar *ed-functions* (make-hash-table))

(defun maybe-wrap-ed-function (ed-function)
  (or
   #+sbcl
   (lambda (&rest a) (prog1 t (apply ed-function a)))
   ed-function))

(defun intern-ed-function (ed-function)
  (or (gethash ed-function *ed-functions*)
      (setf (gethash ed-function *ed-functions*)
            (maybe-wrap-ed-function ed-function))))

(defun unintern-ed-function (ed-function)
  (remhash ed-function *ed-functions*))

(defun register-ed-function (f)
  (block nil
    #+sbcl
     (progn
       (pushnew (intern-ed-function f) sb-ext:*ed-functions*)
       (return))
    (error "unavailable")))

(defun unregister-ed-function (f)
  (block nil
    #+sbcl
    (progn
      (setf sb-ext:*ed-functions*
            (remove (intern-ed-function f) sb-ext:*ed-functions*))
      (unintern-ed-function f)
      (return))
    (error "unavailable")))

(defun activate-repl-evaluation-mode ())
(defun deactivate-repl-evaluation-mode ())
  
