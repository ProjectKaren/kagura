(in-package :cl-user)
(defpackage kagura-test
  (:use :cl
        :prove))
(in-package :kagura-test)

;; NOTE: To run this test file, execute `(asdf:test-system :kagura)' in your Lisp.

(plan nil)

(defvar *test*
"<html><head><title>hage</title></head><body><h1>hoge</h1>hagehage</body></html>")

(print (kagura:state-machine *test* 0 (kagura:make-memory)))
;; blah blah blah.

(finalize)
