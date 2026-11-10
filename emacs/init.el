;;; init.el --- small and fast config  -*- lexical-binding: t; -*-

;;; Packages (first launch downloads them, about a minute)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(require 'use-package)
(setq use-package-always-ensure t)

;; Keep the Customize junk out of this file.
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)

;; Emacs 31 warns about older packages (like gruber-darker) that lack a
;; lexical-binding line. Harmless, so don't pop it up at startup.
(setq warning-suppress-types '((files)))

;;; Look
(add-to-list 'default-frame-alist '(font . "Consolas-15"))
(use-package gruber-darker-theme
  :config (load-theme 'gruber-darker t))

(global-display-line-numbers-mode 1)
(column-number-mode 1)
(show-paren-mode 1)
(delete-selection-mode 1)
(setq ring-bell-function 'ignore)

;;; Sane defaults
(setq-default indent-tabs-mode nil
              tab-width 4
              truncate-lines t
              show-trailing-whitespace t)
(setq make-backup-files nil
      create-lockfiles nil
      use-short-answers t           ; y/n instead of yes/no
      confirm-kill-emacs 'y-or-n-p)
(prefer-coding-system 'utf-8)
(global-auto-revert-mode 1)         ; reload files changed on disk
(windmove-default-keybindings)      ; Shift+arrows moves between windows

;; C-z suspends/minimizes Emacs: too easy to hit by accident.
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))

;;; Fuzzy finding: ido for files and buffers, smex for M-x (tsoding's setup)
(ido-mode 1)
(ido-everywhere 1)
(setq ido-enable-flex-matching t)
(use-package ido-completing-read+
  :config (ido-ubiquitous-mode 1))
(use-package smex
  :bind (("M-x" . smex)))

(setq default-directory "~/"
      command-line-default-directory "~/")

;;; In-buffer completion from words already in your files (no LSP needed)
(use-package company
  :hook (after-init . global-company-mode)
  :custom
  (company-idle-delay 0.5)
  (company-minimum-prefix-length 2))

;;; Shows the possible next keys when you pause mid-chord
(use-package which-key
  :config (which-key-mode 1))

;;; Editing extras
(setq duplicate-line-final-position 1)            ; Emacs 30+: cursor goes to the copy
(global-set-key (kbd "C-,") #'duplicate-line)
(global-set-key (kbd "C-x C-b") #'ibuffer)
(global-set-key (kbd "C-x C-g") #'find-file-at-point)
(global-set-key (kbd "C-c i m") #'imenu)

(use-package move-text
  :bind (("M-p" . move-text-up)
         ("M-n" . move-text-down)))

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)
         ("C-\""        . mc/skip-to-next-like-this)
         ("C-:"         . mc/skip-to-previous-like-this)))

;;; C: 4-space BSD style, // comments
(setq-default c-basic-offset 4
              c-default-style '((java-mode . "java")
                                (awk-mode  . "awk")
                                (other     . "bsd")))
(add-hook 'c-mode-hook (lambda () (c-toggle-comment-style -1)))

;;; Compile loop: F5 asks for a command, F6 reruns it, M-g n jumps to the next error
(global-set-key (kbd "<f5>") #'compile)
(global-set-key (kbd "<f6>") #'recompile)
(setq compilation-scroll-output t
      compilation-ask-about-save nil
      compilation-always-kill t)
(add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)

;;; Dired (C-x d): file manager
(setq dired-listing-switches "-alh"
      dired-dwim-target t
      dired-kill-when-opening-new-dired-buffer t)

;;; Git
(use-package magit
  :bind (("C-c m s" . magit-status)
         ("C-c m l" . magit-log)))

;;; Start a server so `emacsclient` windows open instantly
(require 'server)
(unless (server-running-p) (server-start))
