(in-package :common-setup)

#-swank
(error "This file requires the :SWANK feature")

(eval-when (:compile-toplevel :load-toplevel :execute)
  (swank-loader:init :load-contribs t))

#+sbcl
(progn
  (defvar *eval-form-preprocessor* #'identity)

  (defvar *eval-around* #'funcall)

  (defun sbcl-listener-eval-function (form)
    (funcall *eval-around*
             #'swank-repl::repl-eval
             (funcall *eval-form-preprocessor* form)))

  (register-ed-function 'swank:ed-in-emacs)

  (cond
    ((eq swank-repl::*listener-eval-function* 'swank-repl::repl-eval)
     (setf swank-repl::*listener-eval-function*
           #'sbcl-listener-eval-function))
    (t
     (warn "Cannot setup listener eval function safely")))

  (defun activate-repl-evaluation-mode (&optional (mode :interpret))
    (check-type mode (member :interpret :compile))
    (setf *eval-around*
          (lambda (eval input)
            (let ((sb-ext:*evaluator-mode* mode))
              (funcall eval input)))))

  (defun deactivate-repl-evaluation-mode ()
    (setf *eval-around* #'funcall)))
