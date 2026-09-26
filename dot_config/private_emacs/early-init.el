;; -*- lexical-binding: t; -*-

;;; Code:
(setq inhibit-startup-screen t)

(setopt use-short-answers t)

(global-hl-line-mode 1)
(line-number-mode 1)
(column-number-mode 1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(setq blink-cursor-mode nil)

(setq initial-frame-alist
      (append initial-frame-alist
	      '((width  . 120)
		(height . 50))))

(provide 'early-init)
;;; early-init.el ends here
