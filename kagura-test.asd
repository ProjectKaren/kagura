#|
  This file is a part of kagura project.
  Copyright (c) 2016 Tamamu
|#

(in-package :cl-user)
(defpackage kagura-test-asd
  (:use :cl :asdf))
(in-package :kagura-test-asd)

(defsystem kagura-test
  :author "Tamamu"
  :license "LLGPL"
  :depends-on (:kagura
               :prove)
  :components ((:module "t"
                :components
                ((:test-file "kagura"))))
  :description "Test system for kagura"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
