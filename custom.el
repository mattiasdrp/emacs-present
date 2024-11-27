;;; package --- Customization for emacs
;;; Commentary:
;; Global customization should be made with M-x customize-variable/face
;; so everything can be found in this file
;;;
;; If there is any question about what these variables/faces do just
;; M-x customize-variable/face <ret> name_of_the_variable/face and see the doc
;;; Code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode t)
 '(cursor-intangible-mode t t)
 '(cursor-type t)
 '(doom-themes-enable-bold t)
 '(doom-themes-enable-italic t)
 '(electric-indent-mode t)
 '(fill-column 80)
 '(mixed-pitch-fixed-pitch-faces
   '(diff-added diff-context diff-file-header diff-function diff-header
		            diff-hunk-header diff-removed font-latex-math-face
		            font-latex-sedate-face font-latex-warning-face
		            font-latex-sectioning-5-face font-lock-builtin-face
		            font-lock-comment-delimiter-face font-lock-constant-face
		            font-lock-doc-face font-lock-function-name-face
		            font-lock-keyword-face font-lock-negation-char-face
		            font-lock-preprocessor-face font-lock-regexp-grouping-backslash
		            font-lock-regexp-grouping-construct font-lock-string-face
		            font-lock-type-face font-lock-variable-name-face line-number
		            line-number-current-line line-number-major-tick
		            line-number-minor-tick markdown-code-face
		            markdown-gfm-checkbox-face markdown-inline-code-face
		            markdown-language-info-face markdown-language-keyword-face
		            markdown-math-face message-header-name message-header-to
		            message-header-cc message-header-newsgroups
		            message-header-xheader message-header-subject
		            message-header-other mu4e-header-key-face mu4e-header-value-face
		            mu4e-link-face mu4e-contact-face mu4e-compose-separator-face
		            mu4e-compose-header-face org-block org-block-begin-line
		            org-block-end-line org-document-info-keyword org-code org-indent
		            org-latex-and-related org-checkbox org-formula org-meta-line
		            org-table org-verbatim tree-sitter-hl-face:function
		            tree-sitter-hl-face:punctuation.delimiter
		            tree-sitter-hl-face:doc tree-sitter-hl-face:tag
		            tree-sitter-hl-face:type tree-sitter-hl-face:label
		            tree-sitter-hl-face:escape tree-sitter-hl-face:method
		            tree-sitter-hl-face:number tree-sitter-hl-face:string
		            tree-sitter-hl-face:comment tree-sitter-hl-face:keyword
		            tree-sitter-hl-face:constant tree-sitter-hl-face:embedded
		            tree-sitter-hl-face:operator tree-sitter-hl-face:property
		            tree-sitter-hl-face:variable tree-sitter-hl-face:attribute
		            tree-sitter-hl-face:type.super tree-sitter-hl-face:constructor
		            tree-sitter-hl-face:method.call tree-sitter-hl-face:punctuation
		            tree-sitter-hl-face:type.builtin
		            tree-sitter-hl-face:function.call
		            tree-sitter-hl-face:type.argument
		            tree-sitter-hl-face:function.macro
		            tree-sitter-hl-face:string.special
		            tree-sitter-hl-face:type.parameter
		            tree-sitter-hl-face:constant.builtin
		            tree-sitter-hl-face:function.builtin
		            tree-sitter-hl-face:function.special
		            tree-sitter-hl-face:variable.builtin
		            tree-sitter-hl-face:variable.special
		            tree-sitter-hl-face:variable.parameter
		            tree-sitter-hl-face:property.definition
		            tree-sitter-hl-face:punctuation.bracket
		            tree-sitter-hl-face:punctuation.special))
 '(package-selected-packages nil)
 '(pokemacs-theme 'doom-solarized-dark)
 '(show-paren-style 'expression)
 '(tuple-mono-font
   (if (window-system)
       (cond
        ((x-list-fonts "Fira Code") '(:font "Fira Code"))
	      ((x-list-fonts "Inconsolata") '(:font "Inconsolata"))
	      ((x-family-fonts "DejaVu") '(:family "DejaVu"))
	      (nil (warn "Cannot find a monospaced font.")))
     '(:family "Monospace")) t)
 '(tuple-variable-font
   (if (window-system)
       (cond
        ((x-list-fonts "Iosevka Aile") '(:font "Iosevka Aile"))
	      ((x-list-fonts "ETBembo") '(:font "ETBembo"))
	      ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
	      ((x-list-fonts "Lucida Grande") '(:font "Lucida Grande"))
	      ((x-list-fonts "Verdana") '(:font "Verdana"))
	      ((x-family-fonts "Sans Serif") '(:family "Sans Serif"))
	      (nil (warn "Cannot find a Sans Serif Font.")))
     '(:family "Monospace")) t)
 '(vertico-multiform-categories
   '((imenu buffer) (file (vertico-sort-function . sort-directories-first))
     (corfu (vertico-sort-function . vertico-sort-alpha))
     (jinx grid (vertico-grid-annotate . 20))
     (symbol (vertico-sort-function . vertico-sort-history-length-alpha))))
 '(vertico-multiform-commands
   '((consult-imenu buffer) (consult-line buffer) (execute-extended-command mouse)
     (find-file (vertico-sort-function . sort-directories-first))
     (insert-char (vertico-sort-function . sort-characters))
     (describe-symbol (vertico-sort-override-function . vertico-sort-alpha))
     (posframe
      (vertico-posframe-poshandler . posframe-poshandler-frame-top-center)
      (vertico-posframe-border-width . 10))
     (t posframe)))
 '(warning-suppress-types '((comp)))
 '(x-stretch-cursor nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 `(default ((t (,@tuple-mono-font :slant normal :weight normal :height 118 :width normal :foundry "CTDB"))))
 `(fixed-pitch ((t (,@tuple-mono-font :slant normal :weight normal :height 118 :width normal :foundry "CTDB"))))
 '(tree-sitter-hl-face:punctuation ((t (:inherit tuareg-font-lock-operator-face))))
 '(tuareg-font-lock-constructor-face ((t (:inherit font-lock-type-face))))
 `(variable-pitch ((t (,@tuple-variable-font :weight light :height 1.3)))))

(provide 'custom)
;;; custom.el ends here
