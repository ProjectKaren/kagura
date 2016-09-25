#|
  This file is a part of kagura project.
  Copyright (c) 2016 Tamamu
|#

#|
  Author: Tamamu
|#

(in-package :cl-user)
(defpackage kagura-asd
  (:use :cl :asdf))
(in-package :kagura-asd)

(defsystem kagura
  :version "0.1"
  :author "Tamamu"
  :license "LLGPL"
  :depends-on (:cl-annot)
  :components ((:module "src"
                :components
                ((:file "kagura"))))
  :description ""
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op kagura-test))))
