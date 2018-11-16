;; -*- lexical-binding: t -*-

(require 'pdf-view)
(require 'ert)

(ert-deftest pdf-view-handle-archived-file ()
  :expected-result :failed
  (skip-unless (executable-find "gzip"))
  (let ((tramp-verbose 0)
        (temp
         (make-temp-file "pdf-test")))
    (unwind-protect
        (progn
          (copy-file "test.pdf" temp t)
          (call-process "gzip" nil nil nil temp)
          (setq temp (concat temp ".gz"))
          (should (numberp (pdf-info-number-of-pages temp)))))
    (when (file-exists-p temp)
      (delete-file temp))))

(ert-deftest pdf-view-cua-copy-region ()
  (pdf-test-with-test-pdf
   (pdf-view-mark-whole-page)
   (should (string-match-p "PDF Tools\\(?:.\\|\n\\)*in memory"
			   (let (kill-ring)
			     (require 'cua-base)
			     (cua-copy-region)
			     (car kill-ring))))))
