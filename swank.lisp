(in-package :common-setup)

#-swank
(error "This file requires the :SWANK feature")

#+sbcl
(register-ed-function 'swank:ed-in-emacs)

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
