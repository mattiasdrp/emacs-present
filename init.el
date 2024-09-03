;;; Configure Elpaca -----------------------------

(setq elpaca-core-date '(20240411))
(defvar elpaca-installer-version 0.7)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
			                        :ref nil :depth 1
			                        :files (:defaults "elpaca-test.el" (:exclude "extensions"))
			                        :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
	      (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
		             ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
						                                     ,@(when-let ((depth (plist-get order :depth)))
						                                         (list (format "--depth=%d" depth) "--no-single-branch"))
						                                     ,(plist-get order :repo) ,repo))))
		             ((zerop (call-process "git" nil buffer t "checkout"
				                               (or (plist-get order :ref) "--"))))
		             (emacs (concat invocation-directory invocation-name))
		             ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
				                               "--eval" "(byte-recompile-directory \".\" 0 'force)")))
		             ((require 'elpaca))
		             ((elpaca-generate-autoloads "elpaca" repo)))
	          (progn (message "%s" (buffer-string)) (kill-buffer buffer))
	        (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Install use-package support
(elpaca bind-key)

(elpaca elpaca-use-package
  ;; Enable :ensure use-package keyword.
  (elpaca-use-package-mode)
  ;; Assume :ensure t unless otherwise specified.
  (setq elpaca-use-package-by-default t))

(elpaca-wait)

(eval-and-compile
  (setq
   use-package-verbose t
   use-package-expand-minimally t
   use-package-compute-statistics t
   use-package-enable-imenu-support t))

(use-package general
  :demand t
  :config (message "`general' loaded"))

(elpaca-wait)

;;; Basic Appearance ---------------------------------------

;; More minimal UI
(setq inhibit-startup-screen t)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(defcustom pokemacs-theme 'doom-solarized-dark
  "Theme to load."
  :group 'pokemacs-appearance
  :type 'symbol
  :tag "󰔎 Theme")

(setq user-init-file (or load-file-name (buffer-file-name)))
(setq user-emacs-directory (file-name-directory user-init-file))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)


;;; Org Mode Appearance ------------------------------------

;; Load org-faces to make sure we can set appropriate faces
(use-package org
  :disabled
  :ensure t
  :mode ("\\.org\\'" . org-mode)
  :config
  ;; Hide emphasis markers on formatted text
  (setq org-hide-emphasis-markers t))

;; Appearance etc

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (load-theme pokemacs-theme t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;; (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config)
  (message "`doom-themes' loaded"))

(use-package nerd-icons
  :config
  (set-fontset-font t '(#x25d0 . #xf10d7) "Symbols Nerd Font Mono")
  (set-fontset-font t '(#xe3d0 . #xe3d9) "Material Icons")
  (message "`nerd-icons' loaded"))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode)
  :config
  (message "`nerd-icons-dired' loaded"))

(use-package nerd-icons-completion
  :after (marginalia nerd-icons)
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup)
  :config
  (nerd-icons-completion-mode)
  (message "`nerd-icons-completion' loaded"))

(use-package ligature
  :defer t
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Fira Code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '(
                                       "www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "::"
                                       ":::" ":=" "!!" "!=" "!==" "-}" "----" "-->" "->" "->>"
                                       "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?" "#_"
                                       "#_(" ".-" ".=""..<""?=" "??" ";;" "/*" "/**"
                                       ;; "..""..."
                                       "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
                                       "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<="
                                       "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
                                       "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
                                       "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
                                       "<~" "<~~" "</" "</>" "~@" "~-" "~>" "~~" "~~>" "%%" "[|" "|]"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t)
  (message "`ligature' loaded"))

(use-package projectile
  :demand t
  :hook (prog-mode . projectile-mode)
  :config (message "`projectile' loaded"))

;;; Miscellaneous --------------------------------

;; Install visual-fill-column
(use-package visual-fill-column
  :ensure t
  :hook org-mode
  :config
  ;; Configure fill width
  (setq visual-fill-column-width 150)
  (setq visual-fill-column-center-text t)
  (message "`visual-fill-column' loaded"))

(use-package vertico
  :ensure (vertico :files (:defaults "extensions/*"))
  :defer t
  :after general
  :init
  (vertico-mode)
  :general
  (:keymaps 'vertico-map
            "<tab>" #'minibuffer-complete         ; common prefix
            "<escape>" #'minibuffer-keyboard-quit ; Close minibuffer
            "C-M-n" #'vertico-next-group
            "C-M-p" #'vertico-previous-group
            "?" #'minibuffer-completion-help
            "M-RET" #'embark-dwim ;; pick some comfortable binding
            ;; "C-<up>" #'other-window
            )
  (:keymaps 'minibuffer-local-map
            "M-h" #'backward-kill-word)
  :custom
  ;; Grow and shrink the Vertico minibuffer
  (vertico-resize t)
  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (vertico-cycle t)
  :config
  ;; (setq vertico-sort-function 'vertico-sort-alpha)
  ;; Use `consult-completion-in-region' if Vertico is enabled.
  ;; Otherwise use the default `completion--in-region' function.
  (setq completion-in-region-function
        (lambda (&rest args)
          (apply (if vertico-mode
                     #'consult-completion-in-region
                   #'completion--in-region)
                 args)))
  ;; Prefix the current candidate with “» ”. From
  ;; https://github.com/minad/vertico/wiki#prefix-current-candidate-with-arrow
  (advice-add #'vertico--format-candidate :around
              (lambda (orig cand prefix suffix index _start)
                (setq cand (funcall orig cand prefix suffix index _start))
                (concat
                 (if (= vertico--index index)
                     (propertize "⮕ " 'face 'vertico-current)
                   "  ")
                 cand)))
  (message "`vertico' loaded"))

(use-package vertico-directory
  :after vertico
  :ensure nil
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy)
  ;; More convenient directory navigation commands
  :general
  (:keymaps 'vertico-map
            "RET" 'vertico-directory-enter
            "<backspace>" 'vertico-directory-delete-char
            "M-<backspace>" 'vertico-directory-delete-word)
  ;; Tidy shadowed file names
  :config (message "`vertico-directory' loaded"))

(use-package vertico-multiform
  :after vertico
  :ensure nil
  :defer t
  :custom
  (vertico-buffer-display-action '(display-buffer-in-side-window
                                   (side . right)
                                   (window-width . 0.3)))
  :config
  ;; Sort directories before files
  (defun sort-characters (characters)
    (sort characters (lambda (name1 name2) (< (char-from-name name1) (char-from-name name2)))))

  ;; Sort directories before files
  (defun sort-directories-first (files)
    (nconc (vertico-sort-alpha (seq-remove (lambda (x) (string-suffix-p "/" x)) files))
           (vertico-sort-alpha (seq-filter (lambda (x) (string-suffix-p "/" x)) files))))

  (vertico-multiform-mode)
  (message "`vertico-multiform' loaded"))

(use-package consult
  :defer t
  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :defer t
  :ensure-system-package (rg . ripgrep)
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :general
  ;; C-c bindings (mode-specific-map)
  ("C-c h" 'consult-history)
  ("C-c m" 'consult-mode-command)
  ("C-c k" 'consult-kmacro)
  ;; C-x bindings (ctl-x-map)
  ([remap repeat-complex-command] 'consult-complex-command)
  ([remap switch-to-buffer] 'consult-buffer)
  ([remap switch-to-buffer-other-window] 'consult-buffer-other-window)
  ([remap switch-to-buffer-other-frame] 'consult-buffer-other-frame)
  ([remap bookmark-jump] 'consult-bookmark)
  ([remap project-switch-to-buffer] 'consult-project-buffer)
  ([remap yank-pop] 'consult-yank-replace)
  ([remap apropos-command] 'consult-apropos)
  ([remap goto-line] 'consult-goto-line)
  ;; ([remap isearch-forward] 'consult-line)
  ;; Custom M-# bindings for fast register access
  ("M-#" 'consult-register-load)
  ("M-'" 'consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
  ("C-M-#" 'consult-register)
  ;; Other custom bindings
  ("<help> a" 'consult-apropos)            ;; orig. apropos-command
  ;; M-g bindings (goto-map)
  ("M-g e" 'consult-compile-error)
  ("M-g o" 'consult-outline)               ;; Alternative: consult-org-heading
  ("M-g m" 'consult-mark)
  ("M-g k" 'consult-global-mark)
  ("M-g i" 'consult-imenu)
  ("M-g I" 'consult-imenu-multi)
  ;; M-s bindings (search-map)
  ("M-s d" 'consult-find)
  ("M-s D" 'consult-locate)
  ("M-s g" 'consult-grep)
  ("M-s r" 'consult-ripgrep)
  ("M-s l" 'consult-line)
  ("M-s L" 'consult-line-multi)
  ("M-s m" 'consult-multi-occur)
  ("M-s k" 'consult-keep-lines)
  ("M-s u" 'consult-focus-lines)
  ;; Isearch integration
  ("M-s e" 'consult-isearch-history)
  (:keymaps 'isearch-mode-map
            [remap isearch-edit-string] 'consult-isearch-history
            "M-s L" 'consult-line-multi            ;; needed by consult-line to detect isearch
            )
  ;; Minibuffer history
  (:keymaps 'minibuffer-local-map
            [remap next-matching-history-element] 'consult-history
            [remap prev-matching-history-element] 'consult-history)


  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config
  (consult-customize
   consult-ripgrep
   :keymap (let ((map (make-sparse-keymap)))
             (define-key map (kbd "M-l") #'consult-ripgrep-up-directory)
             map))

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key (kbd "M-."))
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)

   consult-bookmark consult-recent-file
   consult--source-project-recent-file
   consult--source-recent-file consult-buffer
   consult-ripgrep consult-git-grep consult-grep
   consult-xref consult--source-bookmark
   :preview-key '(:debounce 0.5 "M-."))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;; There are multiple reasonable alternatives to chose from.
    ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
    ;;;; 2. projectile.el (projectile-project-root)
  (autoload 'projectile-project-root "projectile")
  (setq consult-project-function (lambda (_) (projectile-project-root)))
    ;;;; 3. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
    ;;;; 4. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
  (message "`consult' loaded"))

(use-package embark
  :defer t
  :general
  ("C-." 'embark-act)          ;; pick some comfortable binding
  ("C-:" 'embark-default-act-noquit)  ;; good alternative: M-.
  ("C-h B" 'embark-bindings)   ;; alternative for `describe-bindings'
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (setq embark-quit-after-action nil)
  (defun embark-default-act-noquit ()
    (interactive)
    (let ((embark-quit-after-action nil))
      (embark-dwim)
      (when-let ((win (minibuffer-selected-window)))
        (select-window win))))

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none))))
  (message "`embark' loaded"))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :after (embark consult)
  :defer t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode)
  :config
  (message "`embark-consult' loaded"))

(use-package corfu
  :ensure (corfu :files (:defaults "extensions/*"))
  :defer t
  :init
  ;; Function definitions

  (defun corfu-enable-always-in-minibuffer ()
    "Enable Corfu in the minibuffer if Vertico/Mct are not active."
    (unless (or (bound-and-true-p mct--active)
                (bound-and-true-p vertico--input)
                (eq (current-local-map) read-passwd-map))
      ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
      (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
                  corfu-popupinfo-delay nil)
      (corfu-mode 1)))

  (defun corfu-move-to-minibuffer ()
    (interactive)
    (when completion-in-region--data
      (let ((completion-extra-properties corfu--extra)
            completion-cycle-threshold completion-cycling)
        (apply #'consult-completion-in-region completion-in-region--data))))

  ;; Activate mode globally
  (global-corfu-mode)

  :general
  (:keymaps 'corfu-map
            "C-g" 'corfu-quit
            "<return>" 'corfu-insert
            "M-d" 'corfu-info-documentation
            "M-l" 'corfu-info-location
            "TAB" 'corfu-insert-separator
            "M-SPC" 'corfu-insert-separator
            "M-m" 'corfu-move-to-minibuffer
            "<down>" 'corfu-next)
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-quit-no-match t)
  (corfu-auto-prefix 1)
  (corfu-auto-delay 0)
  (corfu-separator ?\s)
  ;; (corfu-quit-at-boundary nil)
  (corfu-on-exact-match nil)
  (corfu-preview-current 'insert)
  (corfu-echo-documentation t)
  (corfu-preview-current nil)    ;; Disable current candidate preview
  (corfu-preselect-first nil)    ;; Disable candidate preselection
  (corfu-min-width 80)
  (corfu-max-width 80)
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-echo-documentation nil) ;; Disable documentation in the echo area
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin
  :config
  (add-hook 'minibuffer-setup-hook #'corfu-enable-always-in-minibuffer 1)
  (message "`corfu' loaded"))

(use-package corfu-popupinfo
  :ensure nil
  :after corfu
  :hook (corfu-mode . corfu-popupinfo-mode)
  :general
  (:keymaps 'corfu-popupinfo-map
            "M-h" 'corfu-popupinfo-toggle
            "M-<up>" 'scroll-other-window-down
            "M-<down>"   'scroll-other-window)
  :custom
  (corfu-echo-delay nil) ;; Disable automatic echo and popup
  (corfu-popupinfo-delay nil)
  (corfu-popupinfo-min-width 80)
  (corfu-popupinfo-max-width 80))

(use-package corfu-prescient
  :config
  (corfu-prescient-mode 1)
  (message "`corfu-precient' loaded"))

(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default) ; Have background color be the same as `corfu' face background
  (kind-icon-blend-background nil)  ; Use midpoint color between foreground and background colors ("blended")?
  (kind-icon-blend-frac 0.08)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter) ; Enable `kind-icon'
  (setq kind-icon-mapping
        '((array "a" :icon "code-brackets" :face font-lock-type-face)
          (boolean "b" :icon "circle-half-full" :face font-lock-builtin-face)
          (class "c" :icon "view-grid-plus-outline" :face font-lock-type-face)
          (color "#" :icon "palette" :face success)
          (command "cm" :icon "code-greater-than" :face default)
          (constant "co" :icon "lock-remove-outline" :face font-lock-constant-face)
          (constructor "cn" :icon "table-column-plus-after" :face font-lock-function-name-face)
          (enummember "em" :icon "order-bool-ascending-variant" :face font-lock-builtin-face)
          (enum-member "em" :icon "order-bool-ascending-variant" :face font-lock-builtin-face)
          (enum "e" :icon "format-list-bulleted-square" :face font-lock-builtin-face)
          (event "ev" :icon "lightning-bolt-outline" :face font-lock-warning-face)
          (field "fd" :icon "application-braces-outline" :face font-lock-variable-name-face)
          (file "f" :icon "file-document-outline" :face font-lock-string-face)
          (folder "d" :icon "folder" :face font-lock-doc-face)
          (interface "if" :icon "application-brackets-outline" :face font-lock-type-face)
          (keyword "kw" :icon "key-variant" :face font-lock-keyword-face)
          (macro "mc" :icon "lambda" :face font-lock-keyword-face)
          (magic "ma" :icon "auto-fix" :face font-lock-builtin-face)
          (method "m" :icon "function-variant" :face font-lock-function-name-face)
          (function "f" :icon "function" :face font-lock-function-name-face)
          (module "{" :icon "file-code-outline" :face font-lock-preprocessor-face)
          (numeric "nu" :icon "numeric" :face font-lock-builtin-face)
          (operator "op" :icon "plus-minus" :face font-lock-comment-delimiter-face)
          (param "pa" :icon "cog" :face default)
          (property "pr" :icon "wrench" :face font-lock-variable-name-face)
          (reference "rf" :icon "library" :face font-lock-variable-name-face)
          (snippet "S" :icon "note-text-outline" :face font-lock-string-face)
          (string "s" :icon "sticker-text-outline" :face font-lock-string-face)
          (struct "%" :icon "code-braces" :face font-lock-variable-name-face)
          (text "tx" :icon "script-text-outline" :face font-lock-doc-face)
          (typeparameter "tp" :icon "format-list-bulleted-type" :face font-lock-type-face)
          (type-parameter "tp" :icon "format-list-bulleted-type" :face font-lock-type-face)
          (unit "u" :icon "ruler-square" :face font-lock-constant-face)
          (value "v" :icon "variable" :face font-lock-variable-name-face)
          (variable "va" :icon "variable" :face font-lock-variable-name-face)
          (t "." :icon "crosshairs-question" :face font-lock-warning-face)))
  :config (message "`kind-icon' loaded"))

(use-package savehist
  :ensure nil
  :init
  (savehist-mode t)
  ;; Remember recently opened files
  (recentf-mode t)
  :defer t
  :custom
  (history-delete-duplicates t)
  :config
  ;; Persist 'compile' history
  (add-to-list 'savehist-additional-variables 'compile-history)
  (message "`savehist' loaded"))

(use-package emacs
  :defer t
  :ensure nil
  :init
  ;; FRINGE
  ;; UI: the gutter looks less cramped with some space between it and  buffer.
  (setq-default fringes-outside-margins nil)
  (setq-default describe-mode-outline nil)

  ;; Try to indent and if already indented, complete
  (setq tab-always-indent 'complete)
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  (setq read-extended-command-predicate #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t)
  ;; (add-to-list 'completion-at-point-functions #'dabbrev-capf)
  :config
  (message "`emacs' loaded"))

(use-package orderless
  :defer t
  :custom
  (completion-styles '(substring orderless basic))
  (orderless-matching-styles '(orderless-prefixes))
  (orderless-component-separator 'orderless-escapable-split-on-space)
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (completion-ignore-case t)
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion))))
  :config (message "`orderless' loaded"))

(use-package cape
  :defer t
  :init
  (define-prefix-command 'mdrp-cape-map nil "Cape-")
  :general
  ("M-c" 'mdrp-cape-map)
  (:keymaps 'mdrp-cape-map
            "p" 'completion-at-point ;; capf
            "t" 'complete-tag        ;; etags
            "d" 'cape-dabbrev        ;; or dabbrev-completion
            "h" 'cape-history
            "f" 'cape-file
            "k" 'cape-keyword
            "s" 'cape-symbol
            "a" 'cape-abbrev
            "i" 'cape-ispell
            "l" 'cape-line
            "w" 'cape-dict
            "\\" 'cape-tex
            "_" 'cape-tex
            "^" 'cape-tex
            "&" 'cape-sgml
            "r" 'cape-rfc1345)
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  (add-to-list 'completion-at-point-functions #'cape-file)

  ;; Defining capf for specific modes
  (defalias 'cape-?dict+keyword
    (cape-capf-super #'cape-keyword))
  :hook
  (git-commit-mode . (lambda () (add-to-list 'completion-at-point-functions #'cape-?dict+keyword)))
  (text-mode . (lambda () (add-to-list 'completion-at-point-functions #'cape-?dict+keyword))))

(use-package marginalia
  :after vertico
  :defer t
  :init (marginalia-mode)
  :custom
  (marginalia-align 'center)
  (marginalia-align-offset -1)
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :config (message "`marginalia' loaded"))

(use-package tuareg
  :defer t
  :mode ("\\.ml\\'" . tuareg-mode)
  ;; The following line can be used instead of :ensure t to load
  ;; the tuareg.el file installed with tuareg when running opam install tuareg
  :config (message "`tuareg' loaded")
  :hook
  (tuareg-mode . (lambda ()
                   ;; Commented symbols are actually prettier with ligatures or just ugly
                   (setq prettify-symbols-alist
                         '(
                           ("sqrt" . ?√)
                           ("&&" . ?⋀)        ; 'N-ARY LOGICAL AND' (U+22C0)
                           ("||" . ?⋁)        ; 'N-ARY LOGICAL OR' (U+22C1)
                           ("<>" . ?≠)
                           ;; Some greek letters for type parameters.
                           ("'a" . ?α)
                           ("'b" . ?β)
                           ("'c" . ?γ)
                           ("'d" . ?δ)
                           ("'e" . ?ε)
                           ("'f" . ?φ)
                           ("'i" . ?ι)
                           ("'k" . ?κ)
                           ("'m" . ?μ)
                           ("'n" . ?ν)
                           ("'o" . ?ω)
                           ("'p" . ?π)
                           ("'r" . ?ρ)
                           ("'s" . ?σ)
                           ("'t" . ?τ)
                           ("'x" . ?ξ)
                           ("fun" . ?λ)
                           ("not" . ?￢)
                           (":=" . ?⟸)
                           )))))

(use-package org
  :defer t
  :ensure t
  :mode ("\\.org\\'" . org-mode)
  :init
  :custom
  ;; Babel
  (org-confirm-babel-evaluate nil)
  (org-insert-heading-respect-content nil)
  (org-special-ctrl-a/e t)
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-hide-block-startup t)
  ;; Rest
  (org-ellipsis " ▾")
  (org-startup-indented t)
  (org-adapt-indentation nil)
  (org-agenda-span 'week)
  (org-agenda-start-day "1d")
  (org-agenda-start-on-weekday nil)
  (org-agenda-start-with-log-mode t)
  (org-cycle-separator-lines -1)
  (org-fontify-done-headline t)
  (org-footnote-auto-adjust t)
  (org-hide-emphasis-markers t)
  (org-hide-leading-stars nil)
  (org-hide-macro-markers t)
  (org-image-actual-width '(600))
  (org-image-align 'center)
  (org-latex-compiler "latexmk")
  (org-log-done 'time)
  (org-odd-levels-only nil)
  (org-pretty-entities t)
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-startup-truncated nil)
  (org-startup-with-inline-images t)
  (org-support-shift-select 'always)
  (org-roam-v2-ack t) ; anonying startup message

  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '(
     (emacs-lisp . t)
     (ocaml . t)
     (shell . t)))
  (message "`org-mode' loaded"))

;;; Org Present --------------------------------------------

(use-package hide-mode-line
  :defer t
  :config (message "`hide-mode-line' loaded"))

;; Install org-present if needed
(use-package org-present
  :ensure t
  :demand t
  :after org
  :general
  (:keymaps 'org-present-mode-keymap
            "<right>"   'mdrp/org-next-visible-heading-and-expand
            "<left>"    'mdrp/org-prev-visible-heading-and-expand
            "C-<right>" 'org-present-next
            "C-<left>"  'org-present-prev)
  :init
  (defun mdrp/org-next-visible-heading-and-expand (arg)

    (interactive "p")
    (let ((res (call-interactively #'org-next-visible-heading arg)))
      (if (= (point) (point-max))
          (call-interactively #'org-present-next)
        (call-interactively #'org-fold-show-entry)))
    (outline-show-children)
    (recenter 0 t))

  (defun mdrp/org-prev-visible-heading-and-expand (arg)
    (interactive "p")
    (call-interactively #'org-fold-hide-entry)
    (when (= (point) (point-min))
      (call-interactively #'org-present-prev)
      (goto-char (point-max)))
    (call-interactively #'org-previous-visible-heading arg)
    (call-interactively #'org-fold-show-entry)
    (outline-show-children)
    (recenter 0 t))

  (defun mdrp/org-present-start ()
    (visual-fill-column-mode 1)
    (visual-line-mode 1)
    (setq-local cursor-type nil)
    (setq-local visual-fill-column-width 80)
    (setq-local line-spacing 0.7)
    ;; (mixed-pitch-mode 1)
    (setq-local face-remapping-alist
                '((default (:height 1.7) variable-pitch)
                  (header-line (:height 4.0) variable-pitch)
                  (org-document-title (:height 1.75) org-document-title)
                  (org-level-1 (:height 1.5) org-level-1)
                  (org-level-2 (:height 1.5) org-level-2)
                  (org-level-3 (:height 1.5) org-level-3)
                  (org-link fixed-pitch)
                  ;; (org-verbatim (:height 1.55) org-verbatim)
                  ;; (org-block (:height 1.25) org-block)
                  ;; (org-block-begin-line (:height 0.7) org-block-begin-line)
                  ))
    (setq header-line-format " ")
    (consult-theme 'doom-palenight)
    (hide-mode-line-mode 1)
    (set-frame-parameter (selected-frame) 'alpha '(97 . 100))
    (message "`org-present' start"))

  (defun mdrp/org-present-quit ()
    (setq cursor-type t)
    (visual-fill-column-mode 0)
    (visual-line-mode 0)
    (hide-mode-line-mode 0)
    (setq line-spacing nil)
    (consult-theme pokemacs-theme)
    (message "`org-present' quit"))

  (defun mdrp/org-present-prepare-slide (buffer-name heading)
    ;; Show only top-level headlines
    (org-overview)
    ;; Unfold the current entry
    (org-show-entry)
    ;; Show only direct subheadings of the slide but don't expand them
    (org-show-children))

  :hook ((org-present-mode . mdrp/org-present-start)
         (org-present-mode-quit . mdrp/org-present-quit))
  :config
  (add-hook 'org-present-after-navigate-functions 'mdrp/org-present-prepare-slide)
  (message "`org-present' loaded"))

;; End:
(provide 'init)

;;; init.el ends here
