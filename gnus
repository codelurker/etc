; -*- Lisp -*-

; Setting the imap-ssl-program like this isn't strictly necessary, but
; I do it anyway since I'm paranoid. (I think it will default to
; `-ssl2' instead of `-tls1' if you don't do this.)
;(setq imap-ssl-program "openssl s_client -tls1 -connect %s:%p")

; Since I use gnus primarily for mail and not for reading News, I
; make my IMAP setting the default method for gnus.
(setq gnus-select-method '(nnimap "bats"
                                  (nnimap-address "batsukexch.bats.com")
                                  (nnimap-stream network)))

(add-to-list 'gnus-secondary-select-methods '(nnimap "gmail"
                                                     (nnimap-address "imap.gmail.com")
                                                     (nnimap-server-port 993)
                                                     (nnimap-stream ssl)))

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
(setq gnus-thread-hide-subtree t)
(setq gnus-thread-ignore-subject t)

;; Change email address for work folder.  This is one of the most
;; interesting features of Gnus.  I plan on adding custom .sigs soon
;; for different mailing lists.
(setq gnus-posting-styles
      '((".*"
         (name "Matt Burrows")
         (address "mburrows@batstrading.com"))))

;; Setup mail filter rules
(setq nnimap-split-inbox "nnimap+gmail:INBOX")
(setq nnimap-split-predicate "UNDELETED")
(setq nnimap-split-rule
      '(
        ("INBOX.linkedin" "^From:.*group-digests@linkedin.com")
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

;; Set IMAP folder for sent messages
(setq gnus-message-archive-group
      '("nnimap+bats:Sent Items"))