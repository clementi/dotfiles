;; -*- lexical-binding: t; -*-

;;; Code:
(setq package-archives
      '(("GNU ELPA"     . "https://elpa.gnu.org/packages/")
        ("MELPA"        . "https://melpa.org/packages/")
        ("ORG"          . "https://orgmode.org/elpa/")
        ("MELPA Stable" . "https://stable.melpa.org/packages/")
        ("nongnu"       . "https://elpa.nongnu.org/nongnu/"))
      package-archive-priorities
      '(("GNU ELPA"     . 20)
        ("MELPA"        . 15)
        ("ORG"          . 10)
        ("MELPA Stable" . 5)
        ("nongnu"       . 0)))
(package-initialize)

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (load-theme 'doom-one t))

(set-face-attribute 'default nil
		    :font "Ioskeley Mono-10.5")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(ag catppuccin-theme clojure-mode company consult doom-themes
	editorconfig embark embark-consult emmet-mode flycheck fuel
	haskell-mode kkp lsp-vtsls marginalia markdown-mode nerd-icons
	orderless rg ripgrep scala-mode sly sml-mode treemacs
	treemacs-nerd-icons vertico)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-file (let ((coding-system-for-read 'utf-8))
	     (shell-command-to-string "agda --emacs-mode locate")))

(let ((backup-dir (expand-file-name "tmp/backups/" user-emacs-directory))
      (auto-save-dir (expand-file-name "tmp/auto-saves/" user-emacs-directory)))
  (unless (file-exists-p backup-dir) (make-directory backup-dir t))
  (unless (file-exists-p auto-save-dir) (make-directory auto-save-dir t))

  (setq backup-directory-alist `(("." . ,backup-dir)))
  (setq auto-save-file-name-transforms `((".*" ,auto-save-dir t))))

; (setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))
; (setq auto-save-file-name-transforms `((".*" . ,(expand-file-name "tmp/auto-saves/" user-emacs-directory) t)))

(setq markdown-fontify-code-blocks-natively t)
(setq markdown-enable-math t)

(global-display-line-numbers-mode)

(use-package eglot
  :hook (((typescript-ts-mode
	   typescript-mode
	   haskell-ts-mode
	   haskell-mode
	   javascript-mode
	   javascript-ts-mode
	   ) . eglot-ensure))
  :bind (:map eglot-mode-map ("C-c a" . eglot-code-actions)))

(with-eval-after-load 'eglot
  (defclass eglot-deno (eglot-lsp-server) ()
    :documentation "Deno language server")

  (cl-defmethod eglot-initialization-options ((_ eglot-deno))
    "Deno needs these options to turn on."
    (list :enable t
	  :lint t))

  (defun my/eglot-js-ts-server (_)
    "Choose Deno or TypeScript server depending on the project."
    (cond
     ((or (file-exists-p (expand-file-name "deno.json" (project-root (project-current))))
	  (file-exists-p (expand-file-name "deno.jsonc" (project-root (project-current)))))
      '(eglot-deno "deno" "lsp"))

     (t
      '("tsc" "--lsp" "--stdio"))))
  
  (add-to-list 'eglot-server-programs
	       '((javascript-mode typescript-mode typescript-ts-mode tsx-ts-mode js-mode js-ts-mode)
		 . my/eglot-js-ts-server)))

(use-package flycheck
  :ensure t
  :hook (prog-mode . flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(save idle-change mode-enabled)
	flycheck-idle-change-delay 0.8
	flycheck-display-errors-delay 0.25)
  (setq flycheck-indication-mode 'left-fringe))
  

(use-package haskell-mode
  :ensure t
  :hook (haskell-mode . lsp-deferred))

;; (use-package typescript-mode
;;   :ensure t
;;   :hook ((typescript-mode . lsp-deferred)
;; 	 (typescript-ts-mode . lsp-deferred)))

(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'after-init-hook 'global-visual-line-mode)

(global-set-key (kbd "C-c C-r") 'restart-emacs)
(global-set-key (kbd "C-c l") 'display-line-numbers-mode)
(global-set-key (kbd "C-c w") 'global-visual-line-mode)
(global-set-key (kbd "C-c d") 'duplicate-line)

(when (eq system-type 'darwin)
  (setq mac-option-modifier 'meta))

(use-package nerd-icons
  :ensure t
  :config
  (when (display-graphic-p)
    (set-fontset-font "fontset-default" '(#xe5fa . #xe6b9) (font-spec :family "Symbols Nerd Font Mono") nil 'append)
    (set-fontset-font "fontset-default" '(#xe700 . #xe8ef) (font-spec :family "Symbols Nerd Font Mono") nil 'append)
    (set-fontset-font "fontset-default" '(#xed00 . #xf2ff) (font-spec :family "Symbols Nerd Font Mono") nil 'append)
    (set-fontset-font "fontset-default" '(#xe000 . #xf8ff) (font-spec :family "Symbols Nerd Font Mono") nil 'append)))

(use-package treemacs-nerd-icons
  :ensure t
  :config
  (treemacs-nerd-icons-config))

(use-package ripgrep
  :ensure t
  :bind-keymap
  ("C-c C-g" . ripgrep-regexp))

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package project
  :ensure nil
  :bind-keymap
  ("C-c p" . project-prefix-map)
  :config
  (setq project-switch-commands
	'((project-find-file "Find file")
	  (project-find-regexp "Find regexp")
	  (project-dired "Dired")
	  (project-eshell "Eshell")
	  (project-compile "Compile")
	  (magit-project-status "Magit" ?m)))
  (setq project-vc-extra-root-markers
	'("package.json" "tsconfig.json" "deno.json" "deno.jsonc" "Cargo.toml" "go.mod"
	  "pyproject.toml" "pom.xml" "build.sbt" "build.mill" "build.sc" "Makefile"
	  "CMakeLists.txt" ".project")))

(use-package treemacs
  :ensure t
  :defer t
  :bind ("C-c t" . treemacs)
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-git-mode 'deferred)
  (add-hook 'treemacs-mode-hook (lambda ()
				  (display-line-numbers-mode -1)
				  (visual-line-mode -1))))

(use-package kkp
  :ensure t
  :config
  (global-kkp-mode 1))

(use-package vertico
  :ensure t
  :config
  (setq vertico-cycle t)
  (setq vertico-resize nil)
  (vertico-mode 1))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode 1))

(use-package orderless
  :ensure t
  :config
  (setq completion-stules '(orderless basic)))

(use-package consult
  :ensure t
  :bind (
	 ("M-s M-g" . consult-grep)
	 ("M-s M-f" . consult-find)
	 ("M-s M-o" . consult-outline)
	 ("M-s M-l" . consult-line)
	 ("M-s M-b" . consult-buffer)
	 ("M-s M-r" . consult-ripgrep)))

(use-package embark
  :ensure t
  :bind (("C-." . embark-act)
	 :map minibuffer-local-map
	 ("C-c C-c" . embark-collect)
	 ("C-c C-e" . embark-export)))

(use-package embark-consult
  :ensure t)

(use-package emmet-mode
  :defer t
  :init
  (add-hook 'css-mode-hook 'emmet-mode)
  (add-hook 'sgml-mode-hook 'emmet-mode)
  :config
  (setq
	emmet-move-cursor-between-quotes t
	emmet-preview-default nil)
  (unbind-key "C-M-<left>" emmet-mode-keymap)
  (unbind-key "C-M-<right>" emmet-mode-keymap))

(savehist-mode 1)
(recentf-mode 1)

(provide 'init)
;;; init.el ends here
