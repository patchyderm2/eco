(asdf:defsystem eco-test
  :author "Fernando Borretti"
  :license "MIT"
  :depends-on (:eco :fiveam)
  :defsystem-depends-on (:eco)
  :components ((:module "t"
                :components
                ((:file "eco")
                 (:file "test")))))
