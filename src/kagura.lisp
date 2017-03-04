;;;;
;;;; A HTML Parser KAGURA
;;;; HTML5.1
;;;;

(in-package :cl-user)
(defpackage kagura
  (:use :cl)
  (:export :make-memory))
(in-package :kagura)

(cl-annot:enable-annot-syntax)
;; blah blah blah.

@export
(defstruct node
  (name "" :type string)
  (attributes (list) :type list)
  (parent nil)
  (children (make-array 1 :fill-pointer 0
                          :adjustable t
                          :element-type 'node)
    :type (vector node)))

@export
(defstruct html-element
  (tag "" :type string)
  (attributes (list) :type list))

@export
(defstruct memory
  (stack (make-array 8 :fill-pointer 0
                       :adjustable t
                       :element-type 'character)
    :type (vector character))
  (closep nil)
  (tagp nil)
  (current-node (make-node :name "Document"))
  (state nil))

@export
(defmacro init-memory (mem)
  `(setf (memory-stack ,mem) (make-array 8 :fill-pointer t :adjustable t :element-type 'character)
         (memory-closep ,mem) nil
         (memory-state ,mem) nil
         (memory-tagp ,mem) nil))

(setf *print-circle* t)

@export
(defun state-machine (data cursor mem)
  (if (>= cursor (- (length data) 1))
    (memory-current-node mem)
    (let ((c (char data cursor))
        (next-state nil))
    (case c
      (#\Space )
      (#\< (if (null (memory-state mem))
             (setf next-state :tag-open
                   (memory-tagp mem) t)
             (format t "irregular of tag-open")))
      (#\/ (if (eq (memory-state mem) :tag-open)
             (setf next-state :close-tag-open
                   (memory-closep mem) t)
             (format t "irregular of close-tag-open")))
      (#\> (if (eq (memory-state mem) :tag-name)
             (progn (setf next-state nil)
                    (let ((current (memory-current-node mem)))
                      (if (memory-closep mem)
                          (setf (memory-current-node mem) (node-parent current))
                          (let ((grandchild (make-array 1 :fill-pointer 0 :adjustable t :element-type 'node)))
                            (vector-push-extend (make-html-element :tag (memory-stack mem)) grandchild)
                            (let ((child (make-node :children grandchild
                                                    :parent current)))
                              (vector-push-extend child (node-children current))
                              (setf (memory-current-node mem) child))))
                      (init-memory mem)))
               (format t "irregular of tag-close")))
      (otherwise (if (or (eq (memory-state mem) :tag-open)
                         (eq (memory-state mem) :close-tag-open)
                         (eq (memory-state mem) :tag-name))
                     (setf next-state :tag-name))
                 (vector-push-extend c (memory-stack mem))))
      (setf (memory-state mem) next-state)
      (state-machine data (1+ cursor) mem)))
  )

(defvar *test*
  "<html><head><title>hage</title></head><body><h1>hoge</h1>hagehage</body></html>")


(defun test ()
  (state-machine *test* 0 (make-memory)))
