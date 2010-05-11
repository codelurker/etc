; -*- Lisp -*-

;; Use notification, rememember to add (modeline-notify t) to the
;; group parameter (G p from *Group* buffer)
(require 'gnus-notify) 

;; Use NNIR for searching
;;(load-file "~/elisp/imap.el")
(require 'nnir)

;; This marks mail I send as read.
(setq gnus-gcc-mark-as-read t)

;; Wrap at 80 cols.
(add-hook 'message-mode-hook
	'(lambda()
		(turn-on-auto-fill)
		(setq fill-column 80)))

; Since I use gnus primarily for mail and not for reading News, I
; make my IMAP setting the default method for gnus.
(setq gnus-select-method '(nnimap "bats"
                                  (nnimap-address "batsukexch.bats.com")
                                  (nnimap-stream network)
                                  (nnimap-authinfo-file "~/.authinfo")
                                  (nnir-search-engine imap)))

(add-to-list 'gnus-secondary-select-methods '(nnimap "gmail"
                                                     (nnimap-address "imap.gmail.com")
                                                     (nnimap-server-port 993)
                                                     (nnimap-stream ssl)
                                                     (nnimap-authinfo-file "~/.authinfo")
                                                     (nnir-search-engine imap)))


;; Put everything back to the default send method
(defun gmail-send-default ()
  (setq message-send-mail-function 'smtpmail-send-it
        smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
        smtpmail-auth-credentials (expand-file-name "~/.authinfo")
        smtpmail-default-smtp-server "smtp.gmail.com"
        smtpmail-smtp-server "smtp.gmail.com"
        smtpmail-smtp-service 587
        smtpmail-local-domain nil
        user-mail-address "maburrow@googlemail.com"
        gnus-message-archive-group '("nnimap+gmail:Sent Messages")
        message-signature-file "~/.signature"))

;; Change the mail settings to send in different ways depending on group
(add-hook 'gnus-select-group-hook
          (function (lambda ()
                      (cond ((string-match "^INBOX.*" gnus-newsgroup-name)
                             ;; Send through BATS SMTP
                             (setq smtpmail-smtp-service 25
                                   send-mail-function 'smtpmail-send-it
                                   message-send-mail-function 'smtpmail-send-it
                                   smtpmail-default-smtp-server "ukmail.batstrading.com"
                                   smtpmail-smtp-server "ukmail.batstrading.com"
                                   smtpmail-auth-credentials (expand-file-name "~/.authinfo")
                                   user-mail-address "mburrows@batstrading.com"
                                   gnus-message-archive-group '("nnimap+bats:Sent Items")
                                   message-signature-file "~/.bats-signature"))
                            (t
                             ;; Default to Gmail SMTP
                             (gmail-send-default))))))

(add-hook 'gnus-exit-group-hook 'gmail-send-default)

;; Fetch only part of the article if we can.  I saw this in someone
;; else's .gnus
(setq gnus-read-active-file 'some)

;; Tree view for groups.  I like the organisational feel this has.
(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)

;; Threads!  I hate reading un-threaded email -- especially mailing
;; lists.  This helps a ton!
(setq gnus-summary-thread-gathering-function 
      'gnus-gather-threads-by-subject)

;; Also, I prefer to see only the top level message.  If a message has
;; several replies or is part of a thread, only show the first
;; message.  'gnus-thread-ignore-subject' will ignore the subject and
;; look at 'In-Reply-To:' and 'References:' headers.
;;(setq gnus-thread-hide-subtree t)
(setq gnus-thread-ignore-subject t)

;; Setup mail filter rules
(setq nnimap-split-inbox "INBOX")
(setq nnimap-split-predicate "UNDELETED")
(setq nnimap-split-rule
      '(
        ("INBOX.linkedin" "^From:.*@linkedin.com")
        ("INBOX.org-mode" "^Subject:.*Orgmode")
       )) 

;; Setup adaptive scoring
(setq gnus-use-adaptive-scoring t)
(setq gnus-default-adaptive-score-alist
     '((gnus-unread-mark)
       (gnus-ticked-mark (from 5) (subject 5))       
       (gnus-read-mark (from 1) (subject 1))
       (gnus-killed-mark (from -1) (subject -5))
       (gnus-catchup-mark (from -1) (subject -1))))
(add-hook 'message-sent-hook 'gnus-score-followup-article)

;; Sort threads by score
(setq gnus-thread-sort-functions `(gnus-thread-sort-by-score))

;; Schedule update
(gnus-demon-add-handler 'gnus-demon-scan-news 5 t) ;; every 5 minutes
(gnus-demon-init)

;; BBDB
(add-to-list 'load-path "~/elisp/bbdb/lisp")
(require 'bbdb)
(bbdb-initialize)
(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
(setq 
    bbdb-offer-save 1                        ;; 1 means save-without-asking
    bbdb-pop-up-target-lines 1               ;; very small
    bbdb-canonicalize-redundant-nets-p t     ;; x@foo.bar.cx => x@bar.cx
    bbdb-complete-name-allow-cycling t       ;; cycle through matches (this only works partially)
    bbbd-message-caching-enabled t           ;; be fast
    bbdb-north-american-phone-numbers-p nil  ;; allow entry of non-American format tel numbers
    bbdb-auto-revert-p t                     ;; reload .bbdb file if it has changed on disk

    ;; auto-create addresses from BATS people
    bbdb/news-auto-create-p 'bbdb-ignore-most-messages-hook
    bbdb-ignore-most-messages-alist (quote (("From" . "@.*batstrading.com")))
)

