;; [CB 10/22/2016]
;; the below file is a sample .emacs file, written for emacs_powerpack.
;; if something is useful to you, keep it.  otherwise, delete it.
;; you may use M-x list-packages to browse and install packages
;; (in emacs-speak, M-x means Alt+x)

(windmove-default-keybindings)

;;(smart-mode-line-enable)

(setq exec-path (append exec-path '("C:\\MinGW\\bin")))

(setq gdb-many-windows t
      gdb-use-separate-io-buffer t)


(setq c-default-style "linux"
      c-basic-offset 2)

(desktop-save-mode 1)

;;; *************** PART 1 (BASIC CONFIG) ******************
;;; the config choices in this section to not require any additional emacs packages
;;----- include standard emacs package repos.
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(push '("melpa" . "http://melpa.milkbox.net/packages/")
      package-archives)
(package-initialize)

;;----- broken shutdown of emacs (as on computer crash or force quitting) will leave behind the
;; server directory in .emacs.d.  This function will clean the remnants up so that the emacs "server"
;; functionality starts working again without errors.
(defun clean-serverdir ()
  (interactive)
  (delete-directory "~/.emacs.d/server" t))

;; assuming that there is not incorrect metadata left behind (see doc for clean-serverdir function), this starts
;; up the emacs server.
(require 'server)
(unless (server-running-p)
  (server-start))

;; set the window margins to be smaller (more efficient use of space)
(set-window-margins nil 0 0)

;; I don't really want to see the startup screen every time...
(setq inhibit-startup-message t)

(defun hide-fringes ()
  (set-fringe-mode 0))

(defun show-fringes ()
  (set-fringe-mode 1))

;; fringe styling?
(set-face-attribute 'fringe nil :background "#FFFFFF" :foreground "#000000")

;; don't show the toolbar!  It is generally useless in my opinion.
(tool-bar-mode -1)

;; more sensible scrolling
(setq scroll-step 1) ;; keyboard scroll one line at a time

(setq-default indent-tabs-mode nil)

;; use utf-8! details:
;; http://www.masteringemacs.org/articles/2012/08/09/working-coding-systems-unicode-emacs/
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'prefer-utf-8)
(set-terminal-coding-system 'prefer-utf-8)
(set-keyboard-coding-system 'utf-8)

;; ido mode is nice.  why not use it?
;; (note sometimes ido tries to be too smart when you are searching for a file using C-x C-f. type C-f again in the minibuffer to exit out of ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; some basic modifications to the menus (feel free to add your own of course!)
;; from emacs "Menu Bar" docs
;; Make a menu keymap (with a prompt string)
;; and make it the menu bar item’s definition.
(define-key-after global-map [menu-bar windows]
  (cons "Windows" (make-sparse-keymap "Windows")))

;;(global-unset-key [menu-bar words])
;;(global-unset-key [menu-bar windows])

;; Define specific subcommands in this menu.
(define-key global-map
  [menu-bar windows onlyone]
  '("Hide others" . delete-other-windows))
(define-key global-map
  [menu-bar windows vsplit]
  '("Vertical split" . split-window-right))
(define-key global-map
  [menu-bar windows hsplit]
  '("Horizontal split" . split-window-below))
(define-key global-map
  [menu-bar windows switchwindows]
  '("Other window" . ace-window))

(define-key-after global-map
  [menu-bar edit insert-char]
  '("Insert Character" . insert-char)
  'props
  )

(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; ************** PART 2 (Shell Config) ******************
;; shell support on windows is a little messier than it is on Linux/Mac
;; the below code gives you the ability to switch between windows cmd and msys

(require 'shell)

;;we want two shell presets which we can switch between -- windows and msys2 (depending on how things were compiled)
(setf shell-settings-windows (list
                              :path (getenv "PATH")
                              :esfilename explicit-shell-file-name
                              :sfilename shell-file-name
                              :shellenv (getenv "SHELL")
                              :funcstorun (list (lambda () (remove-hook 'comint-output-filter-functions 'comint-strip-ctrl-m))) ))

(setf berry-mingw-fname  "C:/msys64/usr/bin/bash.exe")

(setf shell-settings-mingw (list
                            :path
                            (concat ":/usr/bin:/mingw64/bin:/bin:" "")
                            ;;                                     (replace-regexp-in-string "\\\\" "/"
                            ;;                                                               (replace-regexp-in-string "\\([A-Za-z]\\):" "/\\1"
                            ;;                                                                                         (getenv "PATH"))
                            ;;                                                               t t)
                            ;;                                     )
                            :esfilename berry-mingw-fname
                            :sfilename  berry-mingw-fname
                            :shellenv  berry-mingw-fname
                            ;;                           :funcstorun (list (lambda () (add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)))
                            ))

(defun switch-shell-configuration (which)
  "which=0 corresponds to mingw, which=1 corresponds to windoze" 
  (interactive "P")
  (let ((settingsvar (cl-case which
                       (0 shell-settings-mingw)
                       (1 shell-settings-windows)
                       (t (throw 'berryerror "unknown value ")))))
    (setenv "PATH" (plist-get settingsvar :path))
    (setf explicit-shell-file-name (plist-get settingsvar :esfilename))
    (setf shell-file-name (plist-get settingsvar :sfilename))
    (setenv "SHELL" (plist-get settingsvar :shellenv))
    (eval (elt (plist-get settingsvar :funcstorun) 0))
    )) 

(defun activate-windows-shell ()
  (interactive)
  (switch-shell-configuration 1))

(defun activate-msys-shell ()
  (interactive)
  (switch-shell-configuration 0))

;; by default we make "M-x shell" point to msys
;; (if we find msys installed at its default location on the system)
(if (file-exists-p berry-mingw-fname)
    (activate-msys-shell)
  (activate-windows-shell))


;; ***************** PART 3 (Variable Width fonts) *******************
;; this section is disabled by default
;; if you would like to experiment with using variable width fonts, enable it using the below flag
;; enables variable width fonts and various helpful settings relating to using them in conjunction
;; with fixed-width fonts.

(setf *usevariablewidth* nil)
(when *usevariablewidth* 
  ;; the below sets the default emacs font to variable width.  if you want to permanantly switch to fixed with fonts, delete the below.  If you want a certain mode to be associated with fixed-width fonts, you can add a "hook" for that mode (there are some examples below).  If you want to temporarily switch to fixed-width, use the command M-x my-buffer-face-mode-fixed
  (custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   )
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(default ((t (:family "Arial" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))

  (defun my-adjoin-to-list-or-symbol (element list-or-symbol)
    (let ((list (if (not (listp list-or-symbol))
                    (list list-or-symbol)
                  list-or-symbol)))
      (require 'cl-lib)
      (cl-adjoin element list)))

  ;; Use variable width font faces in current buffer
  (defun my-buffer-face-mode-variable ()
    "Set font to a variable width (proportional) fonts in current buffer"
    (interactive)
    (setq buffer-face-mode-face '(:family "Arial" :foundry "outline" :slant normal :weight normal :height 120 :width normal))
    (buffer-face-mode))

  ;; Use monospaced font faces in current buffer
  (defun my-buffer-face-mode-fixed ()
    "Sets a fixed width (monospace) font in current buffer"
    (interactive)
    (setq buffer-face-mode-face '(:family "Consolas" :height 110))
    (buffer-face-mode))

  ;; the following modes show up in fixed-width fonts by default!
  (add-hook 'java-mode-hook 'my-buffer-face-mode-fixed)
  (add-hook 'calendar-mode-hook 'my-buffer-face-mode-fixed)
  (add-hook 'c-mode-hook 'my-buffer-face-mode-fixed)
  (add-hook 'slime-popup-buffer-mode-hook 'my-buffer-face-mode-fixed)

  ;; modifications supporting variable width fonts in org mode
  (add-hook 'org-mode-hook 
            (lambda ()
              ;;first, set code, tables, blocks, etc... to use monospace
              (visual-line-mode 1)
              (mapc
               (lambda (face)
                 (set-face-attribute
                  face nil
                  :inherit
                  (my-adjoin-to-list-or-symbol
                   'fixed-pitch
                   (face-attribute face :inherit))))
               (list 'org-code 'org-table 'org-block 'org-block-background 'org-formula))
              ;;(define-key my-org-buffer-local-mode-map (kbd "<f10>") 'some-custom-defun-specific-to-this-buffer)
              ;;(evil-define-key 'normal evil-visual-line-movement-mode-map "j" 'evil-next-visual-line)
              )))

;; *************** PART 4 (External Tools Support) *******************
;; below is sample configuration for various external tools.
;; you will need to modify it to meet your own needs.

;; if you have ace window installed (you should!) we bind a keyboard shortcut.
(when (require 'ace-window nil 'noerror)
  (global-set-key (kbd "C-x o") 'ace-window))

;; babel configuration adding dot (graph language)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((dot . t)
   (emacs-lisp . t))) ; this line activates dot

;; (setq python-shell-interpreter "C:\\Anaconda\\python.exe"
;;      python-shell-interpreter-args "-i C:\\Anaconda\\Scripts\\ipython-script.py console --matplotlib")

(setq python-shell-interpreter "C:\\Python27\\python.exe" )

(setq org-confirm-babel-evaluate nil)

;; (setenv "GS_LIB" "C:/Program Files/gs/gs9.09/lib;")
;; (setq ps-lpr-command "C:/Program Files/gs/gs9.09/bin/gswin64c.exe")
;; (setq ps-lpr-switches '("-q" "-dNOPAUSE" "-dBATCH" "-sDEVICE=mswinpr2"))
;; (setq ps-printer-name t)

;; (setq ps-paper-type 'a4
;;       ps-font-size 7.0
;;       ps-print-header nil
;;       ps-landscape-mode t
;;       ps-number-of-columns 3
;;       ps-line-number nil 
;;       )

                                        ;(require 'org)
                                        ;(require 'ox)
                                        ;
                                        ;(setq org-latex-pdf-process
                                        ;'("pdflatex -interaction nonstopmode -output-directory %o %f" "pdflatex -interaction nonstopmode -output-directory %o %f" "pdflatex -interaction nonstopmode -output-directory %o %f"))
                                        ;
;;  '("latexmk -pdflatex='pdflatex -interaction nonstopmode' -pdf -bibtex -f %f"))

(setq org-export-with-sub-superscripts nil)

;; CB this doesn't appear to actually be enabled on windows.
;; (require 'filenotify)

                                        ;(setq org-clock-persist 'history)
                                        ;(org-clock-persistence-insinuate)

;; if evil is installed, the below code takes effect
(when (require 'evil nil 'noerror)
  (evil-mode 1)
  ;; allowing evil movement commands to work better in org mode
  (evil-define-motion my-0-key-alteration ()
                      (if (eql major-mode 'org-mode)
                          (evil-beginning-of-visual-line)
                        (evil-beginning-of-line)
                        ))
  (evil-define-key 'normal org-mode-map  "k" 'evil-previous-visual-line)
  (evil-define-key 'normal org-mode-map "j" 'evil-next-visual-line)
  (evil-define-key 'normal org-mode-map "gj" 'evil-next-line)
  (evil-define-key 'normal org-mode-map "gk" 'evil-previous-line)
  (evil-define-key 'normal org-mode-map "g0" 'evil-beginning-of-line)
  (evil-redirect-digit-argument evil-motion-state-map "0" 'my-0-key-alteration) 
  (evil-define-key 'normal org-mode-map "g$" 'evil-end-of-line)
  (evil-define-key 'normal org-mode-map "$" 'evil-end-of-visual-line))

;; if evil-numbers is installed, the below code takes effect
(when (require 'evil-numbers nil 'noerror)
  (global-set-key (kbd "C-c +") 'evil-numbers/inc-at-pt)
  (global-set-key (kbd "C-c -") 'evil-numbers/dec-at-pt)
  (define-key evil-normal-state-map (kbd "C-c +") 'evil-numbers/inc-at-pt)
  (define-key evil-normal-state-map (kbd "C-c -") 'evil-numbers/dec-at-pt))

(add-hook 'lisp-mode-hook
          (lambda ()
            (set (make-local-variable 'lisp-indent-function)
                 'common-lisp-indent-function)))

;; want to use common lisp?  you will want to modify the below line
(setq inferior-lisp-program "C:/Users/username/directory/ccl-1.10-windowsx86/ccl/wx86cl64.exe")

;; ********************* PART 5 (Programming related functions) ***************************

;;(setq last-kbd-macro
;;   [?i ?h ?i escape ?o ?t ?h ?e ?r ?e escape])

;;(require 'eldoc)
;;(setq debug-on-error t)

(defmacro print-transparent (exp)
  `(let ((tvar987 ,exp)) (message (format "at: %s, '%s'\n" ,(line-number-at-pos) tvar987)) tvar987))

(defmacro print-transparent-2 (note exp)
  `(let ((tvar987 ,exp)) (message (format "%s.  at: %s, '%s'\n" ,(line-number-at-pos) tvar987)) tvar987))


;; *********************** PART 6 (Miscellaneous Commented Examples) ************************
;; these are left here because short examples can be helpful memory aids sometimes.
;; UNUSED
;; (define-minor-mode evil-visual-line-movement-mode 
;;    "Minor mode which provides visual-line movement, primarily intended 
;;     for org mode documents. "
;;    :init-value nil)

;; UNUSED
;; (define-minor-mode  monospace-mode
;;    "Minor mode which provides visual-line movement, primarily intended 
;;     for org mode documents. "
;;    :init-value nil)

;; UNUSED
;; (defun xah-set-font-to-monospace ()
;;  "Change font in current window to a monospaced font."
;;  (interactive)
;;  (set-frame-font "DejaVu Sans Mono" t)
;;  (text-scale-set 0.5)
;;  )

;; UNUSED
;;set up preferred frame sizing.
;; (when window-system          ; start speedbar if we're using a window system
;;    (set-frame-size (selected-frame) 1100 690 t)
;;    (set-frame-position (selected-frame) 215 0)
;;    (speedbar t)
;;    ;(select-frame-by-name "Speedbar 1.0")
;;    ;(set-frame-size (selected-frame) 170 710 t)
;;    ;(set-frame-position (selected-frame) 0 0)
;;    ;(other-frame 1)
;;    )

;; (defun insert-daily-skeleton ()
;;   (interactive)
;;   (let ((currdatestr (format-time-string "%Y-%m-%d")))
;;     (insert (format "
;; *** TIME
;; #+BEGIN: clocktable :maxlevel 5 :scope subtree
;; #+CAPTION: Clock summary at [2016-09-30 Fri 14:53]
;; #+END:

;; **** TASKS
;; ***** task1
;;     CLOCK: [%s 09:30]--[%s 11:00] =>  1:30

;; ***** task2
;;     CLOCK: [%s 11:00]--[%s 15:00] =>  4:00

;; *** NOTES
;; " currdatestr currdatestr currdatestr currdatestr))))

;; (defun insertstuff ()
;;   (interactive)
;;   (cl-loop for i from 13 to 1012 do
;;            (princ (format "(%d,777777,%d),
;; " i i) (current-buffer))
;; ))

;; example of asynchronous process usage
;; from https://curiousprogrammer.wordpress.com/2009/03/27/emacs-comint/
;; (progn
;;   (apply 'make-comint "cmd" "cmd" nil '())
;;   (delete-other-windows)
;;   (switch-to-buffer-other-window "*cmd*")
;;   (other-window -1))

;; (comint-send-string (get-buffer-process "*cmd*") "dir\n")

;; (defun dired-open-file ()
;;   "In dired, open the file named on this line."
;;   (interactive)
;;   (let* ((file (dired-get-filename nil t)))
;;     (message "Opening %s..." file)
;;     (call-process "explorer" nil 0 nil file)
;;     (message "Opening %s done" file)))

;; (defun maximize-frame()
;;   (interactive)
;;   (w32-send-sys-command #xf030)
;; )

;; (defun remove-watermarks ()
;;   (interactive)
;;   (goto-char (point-min))
;;   (while (search-forward "\/Artifact <<\/Subtype \/Watermark")
;;     (kill-whole-line 6)
;;   ))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(custom-safe-themes
   (quote
    ("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default)))
 '(display-time-mode t)
 '(package-selected-packages
   (quote
    (folding smart-mode-line symon go-mode magit twittering-mode csharp-mode jedi scala-mode request grapnel dash origami elpy powershell)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Consolas" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))


(setq display-time-day-and-date t
      display-time-24hr-format t)
(display-time)


(setq org-feed-alist
      '(
        ("Slashdot"
         "http://rss.slashdot.org/Slashdot/slashdot"
         "~/txt/org/feeds.org" "Slashdot Entries")
        )
      )






;;; buffer-move.el --- 

;; Copyright (C) 2004-2014  Lucas Bonnet <lucas@rincevent.net.fr>

;; Author: Lucas Bonnet <lucas@rincevent.net>
;; Keywords: lisp,convenience
;; Version: 0.5
;; URL : https://github.com/lukhas/buffer-move

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
;; 02111-1307, USA.

;;; Commentary:

;; This file is for lazy people wanting to swap buffers without
;; typing C-x b on each window. This is useful when you have :

;; +--------------+-------------+
;; |              |             |
;; |    #emacs    |    #gnus    |
;; |              |             |
;; +--------------+-------------+
;; |                            |
;; |           .emacs           |
;; |                            |
;; +----------------------------+

;; and you want to have :

;; +--------------+-------------+
;; |              |             |
;; |    #gnus     |   .emacs    |
;; |              |             |
;; +--------------+-------------+
;; |                            |
;; |           #emacs           |
;; |                            |
;; +----------------------------+

;; With buffer-move, just go in #gnus, do buf-move-left, go to #emacs
;; (which now should be on top right) and do buf-move-down.

;; To use it, simply put a (require 'buffer-move) in your ~/.emacs and
;; define some keybindings. For example, i use :

;; (global-set-key (kbd "<C-S-up>")     'buf-move-up)
;; (global-set-key (kbd "<C-S-down>")   'buf-move-down)
;; (global-set-key (kbd "<C-S-left>")   'buf-move-left)
;; (global-set-key (kbd "<C-S-right>")  'buf-move-right)


;;; Code:


(require 'windmove)

;;;###autoload
(defun buf-move-up ()
  "Swap the current buffer and the buffer above the split.
If there is no split, ie now window above the current one, an
error is signaled."
  ;;  "Switches between the current buffer, and the buffer above the
  ;;  split, if possible."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'up))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (null other-win)
        (error "No window above this one")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

;;;###autoload
(defun buf-move-down ()
  "Swap the current buffer and the buffer under the split.
If there is no split, ie now window under the current one, an
error is signaled."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'down))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (or (null other-win) 
            (string-match "^ \\*Minibuf" (buffer-name (window-buffer other-win))))
        (error "No window under this one")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

;;;###autoload
(defun buf-move-left ()
  "Swap the current buffer and the buffer on the left of the split.
If there is no split, ie now window on the left of the current
one, an error is signaled."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'left))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (null other-win)
        (error "No left split")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

;;;###autoload
(defun buf-move-right ()
  "Swap the current buffer and the buffer on the right of the split.
If there is no split, ie now window on the right of the current
one, an error is signaled."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'right))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (null other-win)
        (error "No right split")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))


(provide 'buffer-move)
;;; buffer-move.el ends hereS

(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

                                        ; (require 'journal)

(require 'epa-file)
(epa-file-enable)

;;; Tramp Config
(setq tramp-default-method "ssh")
