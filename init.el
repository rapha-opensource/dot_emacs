
(add-to-list 'load-path "/opt/local/share/emacs/site-lisp/color-theme-6.6.0")
 (require 'color-theme)
 (eval-after-load "color-theme"
 	'(progn
 		(color-theme-initialize)
 		(color-theme-hober)))

;;; install the undo-tree extension
(add-to-list 'load-path' "~/repo/undo-tree")
(require 'undo-tree)
(global-undo-tree-mode)

;;; Add vimpulse extension to have the Vim-like editing features I like
(add-to-list 'load-path "~/repo/vimpulse")
(require 'vimpulse)

;;;Add easy-mmode which is required by at least smart-tab...
(add-to-list 'load-path' "~/.emacs.d")

;;;Add smart-tab (from git repo)
(add-to-list 'load-path' "~/repo/smart-tab")
(require 'smart-tab)
(global-smart-tab-mode 1)

(autoload 'no-word "no-word" "word to txt")
(add-to-list 'auto-mode-alist '("\\.doc\\'" . no-word))
;; antiword will be run on every doc file you open

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))
(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/"))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(c-default-style (quote ((c++-mode . "stroustrup") (java-mode . "java") (awk-mode . "awk") (other . "gnu"))))
 '(inhibit-startup-screen t)
 '(initial-scratch-message "
")
 '(ns-command-modifier (quote alt))
 '(save-place t nil (saveplace))
 '(show-paren-mode t)
 '(smart-tab-disabled-major-modes (quote (org-mode term-mode shell-mode)))
 '(menu-bar-mode nil)
 '(tool-bar-mode nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:height 140)))))

;;; to make sure emacs treats .h files as C++ headers
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; Python Hook
;(smart-tabs-advice python-indent-line-1 python-indent)
(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)
            (setq python-indent 8)
            (setq tab-width 8)))  

(fset 'yes-or-no-p 'y-or-n-p)
(delete-selection-mode t)
(show-paren-mode t)
;;sauve les fichiers ouverts dans une session locale (repertoire courant)
(desktop-save-mode 1)

;;; A quick & ugly PATH solution to Emacs on Mac OSX
(if (string-equal "darwin" (symbol-name system-type))
	(setenv "PATH" (concat "/opt/local/bin:/opt/local/sbin:" (getenv "PATH"))))

;; "funky stuff" ;; proceed with caution

(setq my-key-pairs
	  '((?! ?1) (?@ ?2) (?# ?3) (?$ ?4) (?% ?5)
		(?^ ?6) (?& ?7) (?* ?8) (?( ?9) (?) ?0)
		(?- ?_) (?\" ?') (?{ ?[) (?} ?])         ; (?| ?\\)
		))

(defun my-key-swap (key-pairs)
  (if (eq key-pairs nil)
	  (message "Keyboard zapped!! Shift-F10 to restore!")
	(progn
	  (keyboard-translate (caar key-pairs)  (cadar key-pairs))
	  (keyboard-translate (cadar key-pairs) (caar key-pairs))
	  (my-key-swap (cdr key-pairs))
	  )
	))

(defun my-key-restore (key-pairs)
  (if (eq key-pairs nil)
	  (message "Keyboard restored!! F10 to Zap!")
	(progn
	  (keyboard-translate (caar key-pairs)  (caar key-pairs))
	  (keyboard-translate (cadar key-pairs) (cadar key-pairs))
	  (my-key-restore (cdr key-pairs))
	  )
	))

;; "funky stuff" ;; proceed with caution

(defun my-editing-function (first last len)
  (interactive)
  (if (and (boundp 'major-mode)
		   (member major-mode (list 'c-mode 'c++-mode 'gud-mode 'fundamental-mode 'ruby-mode))
		   (= len 0)
		   (> (point) 4)
		   (= first (- (point) 1)))
	  (cond
	   ((and (string-equal (buffer-substring (point) (- (point) 2)) "__")
			 (not (string-equal (buffer-substring (point) (- (point) 3)) "___")))
		(progn (delete-backward-char 2) (insert-char ?- 1) (insert-char ?> 1)))

	   ((string-equal (buffer-substring (point) (- (point) 3)) "->_")
		(progn (delete-backward-char 3) (insert-char ?_ 3)))

	   ((and (string-equal (buffer-substring (point) (- (point) 2)) "..")
			 (not (string-equal (buffer-substring (point) (- (point) 3)) "...")))
		(progn (delete-backward-char 2) (insert-char ?[ 1) (insert-char ?] 1) (backward-char 1)))

	   ((and (> (point-max) (point))
			 (string-equal (buffer-substring (+ (point) 1) (- (point) 2)) "[.]"))
		(progn (forward-char 1) (delete-backward-char 3) (insert-char ?. 1) (insert-char ?. 1) ))
	   )
	nil))

;;~~~~~ Rapha's keybindings ~~~~~~~~~~~~
(global-set-key (kbd "M-A-v") 'viper-mode)
(global-set-key (kbd "M-A-b") 'viper-go-away)

(global-set-key (kbd "C-c a") 'list-matching-lines)

;automatically indent.
;(define-key global-map (kbd "RET") 'newline-and-indent)

(defun rg-open-preferences ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "M-A-p") 'rg-open-preferences)


(defun rg-swank-connect (txt)
  (remove-hook 'comint-output-filter-functions 'rg-swank-connect)
  (when (not (slime-connected-p))
    (slime-connect "127.0.0.1" 4005 )))

(add-hook 'slime-repl-mode-hook 'clojure-mode-font-lock-setup)

(defun rg-start-swank ()
"Launch a swank server from the directory of current buffer."
  (interactive)
  (add-hook 'comint-output-filter-functions 'rg-swank-connect)
  (async-shell-command "/Users/rapha/bin/lein swank"))

(global-set-key (kbd "M-A-s") 'rg-start-swank)

(defun rg-restart-swank ()
  (interactive)
  (when (slime-connected-p)
    (slime-disconnect))
  (save-current-buffer
    (with-current-buffer "*Async Shell Command*"
      (comint-interrupt-subjob)))
  (run-at-time "3 sec" nil 'rg-start-swank))

(global-set-key (kbd "M-A-S") 'rg-restart-swank)
(global-set-key (kbd "M-A-a") 'ac-start)

(global-set-key (kbd "A-v") 'clipboard-yank)

(global-set-key (kbd "M-A-f") 'other-frame)

;presque un full-screen
(defun maximize-frame () 
  (interactive)
  (set-frame-position (selected-frame) 0 0)
  (set-frame-size (selected-frame) 1000 1000))

(global-set-key (kbd "A-F") 'maximize-frame)

;ca c'est pour avoir un smarter tab-complete
(setq ido-enable-flex-matching t)
  (setq ido-everywhere t)
  (ido-mode 1)

(global-set-key (kbd "A-M-c") 'comment-or-uncomment-region)

(global-set-key [A-f10]         '(lambda () (interactive) (my-key-swap    my-key-pairs)))
(global-set-key [A-S-f10]       '(lambda () (interactive) (my-key-restore my-key-pairs)))
