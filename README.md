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

## REPL evaluation mode

This is mostly useful for SBCL, which by default compiles code: while
compiling code in general is good, in the REPL most of the warnings are in
fact not very interesting: doing `(SETQ TEST ...)` in the REPL to
store an intermediate result doesn't need to trigger the *undefined
variable* warning (as long as the code is only used in your
environment, you don't need to be strict about portability as you
might need in actual files).

By invoking the `ACTIVATE-REPL-EVALUATION-MODE` function with
`:INTERPRET` mode, the REPL (and only the REPL) evaluates code in
`:INTERPRET` mode, which notably doesn't warn as much (e.g. you can
modify quoted value without warnings, which can be acceptable in the
context of a REPL).

    USER> (common-setup:activate-repl-evaluation-mode :interpret)
    ...
    
    USER> sb-ext:*evaluator-mode*
    :INTERPRET
    
You can also force the `:COMPILE` mode if the default binding is `:INTERPRET`.

In order to stop overriding the default value, call `DEACTIVATE-REPL-EVALUATION-MODE`:

    USER> (common-setup:deactivate-repl-evaluation-mode)
    ...
    
This works by configuring `swank-repl::*listener-eval-function*` (in
Swank), so evaluation from a buffer is not affected by this mechanism.
