# common-setup

Setup code for Common Lisp in editors.

Currently supports Emacs.

## Installation

Load one of the available system to setup the environment:

    ;; when using Slime/Swank
    (ql:quickload :common-setup.swank)

    ;; when using Sly/Slynk
    (ql:quickload :common-setup.slynk)

## Editor integration

Loading the system automatically configures the `ED` function.

    ;; should work and open the file in Emacs
    (ed "/path/to/some/file")

## REPL evaluation mode (sbcl/swank)

- `ACTIVATE-REPL-EVALUATION-MODE [ :COMPILE | :INTERPRET ]`
- `DEACTIVATE-REPL-EVALUATION-MODE` 

Locally override how SBCL evaluates code in the REPL. This works by
configuring `swank-repl::*listener-eval-function*` (in Swank), so
evaluation from a buffer is not affected by this mechanism.

The two functions do nothing on other implementations or with a
different environment than Slime/Swank (yet).

By default SBCL compiles code: while compiling code in general is
good, in the REPL most of the warnings are in fact not very
interesting: doing `(SETQ TEST ...)` in the REPL to store an
intermediate result doesn't need to trigger an `UNBOUND-VARIABLE`
warning (as long as the code is only used in your environment, you
don't need to be strict about portability as you might need in actual
files).

By invoking the `ACTIVATE-REPL-EVALUATION-MODE` function with
`:INTERPRET` mode, the REPL (and only the REPL) evaluates code in
`:INTERPRET` mode, which notably doesn't warn as much as the
compiler..

    USER> (common-setup:activate-repl-evaluation-mode :interpret)
    ...
    
    USER> sb-ext:*evaluator-mode*
    :INTERPRET
    
Note that this is bound around each evaluated form, so doing `SETQ` in
the REPL doesn't change the binding.

You can also force the `:COMPILE` mode if the default binding is `:INTERPRET`.

In order to stop overriding the default value, call `DEACTIVATE-REPL-EVALUATION-MODE`:

    USER> (common-setup:deactivate-repl-evaluation-mode)
    ...
    

