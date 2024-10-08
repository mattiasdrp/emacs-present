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
 '(package-selected-packages nil)
 '(pokemacs-theme 'doom-solarized-dark)
 '(show-paren-style 'expression)
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
 '(default ((t (:family "Fira Code" :slant normal :weight normal :height 118 :width normal :foundry "CTDB"))))
 '(fixed-pitch ((t (:family "Fira Code" :slant normal :weight normal :height 118 :width normal :foundry "CTDB"))))
 '(tuareg-font-lock-constructor-face ((t (:inherit font-lock-type-face))))
 '(variable-pitch ((t (:font "Iosevka Aile" :weight light :height 1.3)))))

(provide 'custom)
;;; custom.el ends here
