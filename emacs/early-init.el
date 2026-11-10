;;; early-init.el --- runs before packages and the first frame  -*- lexical-binding: t; -*-

;; Don't garbage-collect during startup; drop back to 16 MB once loaded.
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 16 1024 1024))))

;; Turn off the GUI chrome before the frame is drawn (faster than doing it later).
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(internal-border-width . 10) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

(setq inhibit-startup-screen t
      frame-inhibit-implied-resize t
      native-comp-async-report-warnings-errors 'silent)
