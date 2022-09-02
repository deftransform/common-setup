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

(defvar *eval-form-preprocessor* #'identity)
(defvar *eval-around* #'funcall)

(defun sbcl-listener-eval-function (form)
  (funcall *eval-around*
           #'swank-repl::repl-eval
           (funcall *eval-form-preprocessor* form)))

#+sbcl
(cond
  ((eq swank-repl::*listener-eval-function* 'swank-repl::repl-eval)
   (setf swank-repl::*listener-eval-function*
         #'sbcl-listener-eval-function))
  (t
   (warn "Cannot setup listener eval function safely")))

#+sbcl
(defun activate-repl-evaluation-mode (&optional (mode :interpret))
  (check-type mode (member :interpret :compile))
  (setf *eval-around*
        (lambda (eval input)
          (let ((sb-ext:*evaluator-mode* mode))
            (funcall eval input)))))

#+sbcl
(defun deactivate-repl-evaluation-mode ()
  (setf *eval-around* #'funcall))

(unless (fboundp 'activate-repl-evaluation-mode)
  (defun activate-repl-evaluation-mode ())
  (defun deactivate-repl-evaluation-mode ()))
  
