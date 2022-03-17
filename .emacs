;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;(package-initialize)

;; Package stuff setup
(require 'package)
;;(add-to-list 'package-archives
;;	'("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
	'("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(ac-config-default)

(display-time)

(global-set-key (kbd "C-x C-b") 'ibuffer) 

;; Turn on the active buffer active line highlight
(global-hl-line-mode 0)
(set-face-background hl-line-face "gray33")

(require 'spell-fu)
;;(global-spell-fu-mode)

;; Only do spell-fu on org-mode and text-mode
(add-hook 'org-mode-hook
	  (lambda ()
	    (setq spell-fu-faces-exclude '(org-meta-line org-link org-code))
	    (spell-fu-mode)))

(add-hook 'text-mode-hook
	  (lambda ()
	    (setq spell-fu-faces-exclude '(org-meta-line org-link org-code))
	    (spell-fu-mode)))



;; My custom key bings should go here
(global-set-key (kbd "s-c r") 'comment-region)
(global-set-key (kbd "s-u r") 'uncomment-region)
(global-set-key (kbd "C-c m") 'recompile)
(global-set-key (kbd "C-c s") 'ivy-switch-buffer)

(c-set-offset 'case-label '+)

(desktop-save-mode 1)

;; Remove the goofy icon toolbar
(tool-bar-mode -1)

;; Smart mode line
;; Check to see if it is installed
;; (when (require 'sml nil 'noerror)
;;(setq sml/no-confirm-load-theme t)
;;(sml/setup)
;;(setq sml/theme 'dark)

;; more sensible scrolling
(setq scroll-step 1) ;; keyboard scroll one line at a time

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tango-dark))
 '(custom-safe-themes
   '("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default))
 '(display-time-mode t)
 '(package-selected-packages
   '(auto-complete magit ivy helm hyperbole smart-mode-line cmake-font-lock cmake-ide w3))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "DAMA" :slant normal :weight normal :height 120 :width normal)))))

;; (setq shell-file-name "bash")
(setq explicit-shell-file-name "/bin/zsh")

(setq c-default-style "linux"
      c-basic-offset 2)

;; Go Mode
(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            (setq tab-width 4)
            (setq indent-tabs-mode 1)))
