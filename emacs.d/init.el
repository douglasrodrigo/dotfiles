(setq user-full-name "Douglas Rodrigo Ferreira")
(setq user-mail-address "douglasrodrigo@gmail.com")

(prefer-coding-system 'utf-8)

(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(load-theme 'wombat t)

(require 'ido)
(ido-mode t)

(setq inhibit-splash-screen t)

(delete-selection-mode 1)
(setq kill-whole-line t)
(setq-default indent-tabs-mode nil)

;; enable winner-mode
(winner-mode 1)

(show-paren-mode 1)

;; buffername path
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;;scale mode
(define-globalized-minor-mode 
    global-text-scale-mode
    text-scale-mode
    (lambda () (text-scale-mode 1)))
  
  (defun global-text-scale-adjust (inc) (interactive)
    (text-scale-set 1)
    (kill-local-variable 'text-scale-mode-amount)
    (setq-default text-scale-mode-amount (+ text-scale-mode-amount inc))
    (global-text-scale-mode 1)
  )
  
  (global-set-key (kbd "M-0")
                  '(lambda () (interactive)
                     (global-text-scale-adjust (- text-scale-mode-amount))
                     (global-text-scale-mode -1)))
  (global-set-key (kbd "M-+")
                  '(lambda () (interactive) (global-text-scale-adjust 1)))
  (global-set-key (kbd "M--")
                  '(lambda () (interactive) (global-text-scale-adjust -1)))

;;(global-text-scale-adjust 1)

(setq emerge-diff-options "--strip-trailing-cr")

(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
;;(add-to-list 'auto-mode-alist '("\\.css$" . rainbow-mode))
(add-hook 'js2-mode-hook 'ac-js2-mode)

(autoload 'sass-mode "sass-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.scss$" . sass-mode))
(add-hook 'sass-mode-hook 'rainbow-mode)

(autoload 'web-mode "web-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode)) 
(add-to-list 'auto-mode-alist '("\\.tag\\'" . web-mode)) 
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.vm\\'" . web-mode))

(setq web-mode-engines-alist '(("velocity" . "\\.html\\'")))

(add-hook 'web-mode-hook 'auto-complete-mode)

(autoload 'emmet-mode "emmet-mode" nil t)
(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'web-mode-hook 'emmet-mode)
(setq emmet-indentation 2)

(autoload 'scala-mode "scala-mode" nil t)

(autoload 'ensime "ensime" nil t)
;;(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

(autoload 'javap-mode "javap-mode" nil t)

;;identation
(setq tab-width 2)

(custom-set-variables  
 '(js2-basic-offset 4)  
 '(js2-bounce-indent-p t)  
)

;;prevent backup files
(setq make-backup-files nil) 

;; send my backups here
(add-to-list 'backup-directory-alist (cons ".*" (concat user-emacs-directory "backups/")))


;;navigate through camel cases
(global-subword-mode 1)

(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

  (mapc
   (lambda (package)
     (or (package-installed-p package)
         (if (y-or-n-p (format "Package %s is missing. Install it? " package))
             (package-install package))))
   '()))


(defun copy-file-name ()
  "copy the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name))
  (kill-new (file-truename buffer-file-name)))


(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))

(global-set-key (kbd "C-c d") 'duplicate-current-line-or-region)


(setq url-proxy-services
   '(("no_proxy" . "^\\(localhost\\|10.*\\)")
     ("http" . "localhost:8123")
     ("https" . "localhost:8123")))
