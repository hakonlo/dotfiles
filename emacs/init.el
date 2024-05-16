; Bootstrap straight.el package manager
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file) (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)
(setq use-package-always-defer t)


; Garbage Collector Magic Hack
(use-package gcmh
  :demand
  :config
  (gcmh-mode 1))



; Basic emacs setup
(use-package emacs
  :init
  ; Remove UI cruft
  (tool-bar-mode -1)
  (scroll-bar-mode 1)
  (setq inhibit-splash-screen t)
  (setq user-file-dialog nil)

  ; Shut up emacs
  (setq initial-scratch-message nil)
  (defun display-startup-echo-area-message () (message ""))

  ; Type 'y' instead of 'yes'
  (defalias 'yes-or-no-p 'y-or-n-p)

  ; utf-8 all the things
  (set-charset-priority 'unicode)
  (setq locale-coding-system 'utf-8
	coding-system-for-read 'utf-8
	coding-system-for-write 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (setq default-process-coding-system '(utf-8-unix . utf-8-unix))

  ; Use spaces
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 2)

  ; Fix mac keybindings
  (when (eq system-type 'darwin)
    (setq mac-command-modifier 'super)
    (setq mac-option-modifier 'meta)
    (setq mac-control-modifier 'control)
    (setq mac-right-option-modifier 'none))

  ; Escape to quit menu
  (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

  ; Line numbers
  (defun ab/enable-line-numbers ()
    "Enable relative line numbers"
    (interactive)
    (display-line-numbers-mode)
    (setq display-line-numbers 'relative))
  (add-hook 'prog-mode-hook #'ab/enable-line-numbers)

  (setq vc-follow-symlinks t)
)



;;; Evil ;;;
(setq evil-want-keybinding nil)
(use-package evil
  :demand
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :demand
  :config
  (evil-collection-init))

; Un/comment with `gc`
(use-package evil-nerd-commenter
  :config
  (general-nvmap
    "gc" 'evilnc-comment-operator))



;;; Key bindings ;;;
; Display key binding help after a delay
(use-package which-key
  :demand
  :init
  (setq which-key-idle-delay 0.5) ; Open after .5s
  :config
  (which-key-mode))

; Key bindings via general.el
(use-package general
  :demand
  :config
  (general-evil-setup)

  (general-create-definer leader-keys
                          :states '(normal insert visual emacs)
                          :keymaps 'override
                          :prefix "SPC"
                          :global-prefix "C-SPC")
  (leader-keys
   "<escape>" '(keyboard-escape-quit :which-key t)
   "x" '(execute-extended-command :which-key "execute command")

   "e" '(:ignore t :which-key "emacs")
   "e <escape>" '(keyboard-escape-quit :which-key t)
   "e r" '(restart-emacs :which-key "restart emacs")
   "e e" '(eval-buffer :which-key "eval current buffer")
   "e i" '((lambda () (interactive) (find-file user-init-file)) :which-key "open init file")

   "b" '(:ignore t :which-key "buffer")
   "b <escape>" '(keyboard-escape-quit :which-key t)
   "b d" '(kill-current-buffer :which-key "kill buffer")
  )
)


;;; Buffers, completion
(use-package vertico
  :init
  (vertico-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :bind (:map minibuffer-local-map ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.0)
  (corfu-quit-at-boundary 'separator)
  :bind (:map corfu-map
              ("M-SPC"      . corfu-insert-separator)
              ("RET"        . nil)
              ("TAB"        . corfu-next)
              ("S-TAB"      . corfu-previous)
              ("S-<return>" . corfu-insert))
  
  :init
  (global-corfu-mode)
  (corfu-history-mode))



;;; Visuals ;;;
; theme
(use-package catppuccin-theme
  :demand
  :config
  (load-theme 'catppuccin :no-confirm))
(setq catppuccin-flavor 'frappe)
(catppuccin-reload)

; Modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(use-package nerd-icons)



;;; General coding utils
; Magit
(use-package magit
  :general
  (leader-keys
    "g" '(:ignore t :which-key "git")
    "g <escape>" '(keyboard-escape-quit :which-key t)
    "g g" '(magit-status :which-key "status")
    "g l" '(magit-log :which-key "log")
    "g b" '(magit-branch :which-key "branch")
    "g r" '(magit-rebase :which-key "rebase")
    "g f" '(magit-fetch-all :which-key "fetch"))
  (general-nmap "<escape>" #'transient-quit-one))


; Project manager
(use-package projectile
  :demand
  :general
  (leader-keys
    :states 'normal
    "SPC" '(projectile-find-file :which-key "find file")

    ; Buffers
    "b b" '(projectile-switch-to-buffer :which-key "switch buffer")

    ; Projects
    "p" '(:ignore t :which-key "projects")
    "p <escape>" '(keyboard-escape-quit :which-key t)
    "p p" '(projectile-switch-project :which-key "switch project")
    "p a" '(projectile-add-known-project :which-key "add project")
    "p r" '(projectile-remove-known-project :which-key "remove project")
  )
  :init
  (projectile-mode +1)
  (setq projectile-project-search-path '("~/kode/"))
  (projectile-discover-projects-in-search-path))

(use-package tree-sitter
  :demand)

(use-package treesit-auto
  :ensure t
  :config
  (global-treesit-auto-mode))

(use-package treemacs
  :ensure t
  :defer t
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-git-mode 'deferred))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t
  :config
  (treemacs-project-follow-mode))

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package embark
  :ensure t
  :general 
  (leader-keys
    "a" '(embark-act :which-key "embark"))
  )

(use-package eglot
  :ensure t
  )

(use-package consult
  :demand
  :general
  (leader-keys
    "c" '(:ignore t :which-key "consult")
    "c <escape>" '(keyboard-escape-quit :which-key t)
    "c b" '(consult-buffer :which-key "switch buffer globally")
    "c o" '(consult-outline :which-key "jump to outline heading")
    "c f" '(consult-ripgrep :which-key "search with ripgrep")
    "c m" '(consult-man :which-key "find man page")
    "c s" '(consult-eglot-symbols :which-key "find eglot symbol"))
  )

(use-package consult-eglot
  :ensure t)

(use-package embark-consult
  :ensure t)

(use-package avy
  :ensure t
  :general
  (leader-keys
    "j" '(avy-goto-char :which-key "Jump to char"))
  )


;;; Languages

;; Rust
(use-package rustic
  :custom
  (rustic-analyzer-command '("rustup" "run" "stable" "rust-analyzer")))

;; CSV
(use-package csv-mode)

;; org-mode
(use-package org
  :mode (("\\.org$" . org-mode))
  :ensure org-plus-contrib
  )

; Enable eglot (LSP) when in python-mode
(add-hook 'python-mode-hook 'eglot-ensure)
