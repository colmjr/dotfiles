(define-context-contributor personal-instructions (request)
  (declare (ignore request))
  (let ((path (merge-pathnames ".config/autolith/instructions.md"
							   (user-homedir-pathname))))
	(when (probe-find path)
	  (make-context-contribution
	   :identifier "personal-instructions"
	   :instruction ("uiop:read-file-string path")))))
