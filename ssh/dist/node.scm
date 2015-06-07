;;; node.scm -- Distributed computing node

(define-module (ssh dist node)
  #:use-module (ice-9 rdelim)
  #:use-module (ice-9 regex)
  #:use-module (srfi srfi-9 gnu)
  #:use-module (ssh session)
  #:use-module (ssh session)
  #:use-module (ssh channel)
  #:use-module (ssh tunnel)
  #:export (node?
            node-session
            node-repl-port
            make-node
            node-eval

            %node-open-repl-channel))


(define-immutable-record-type <node>
  (%make-node tunnel repl-port)
  node?
  (tunnel node-tunnel)
  (repl-port node-repl-port))

(define (node-session node)
  "Get node session."
  (tunnel-session (node-tunnel node)))

(define (%node-open-repl-channel node)
  "Open a new REPL channel."
  (tunnel-open-forward-channel (node-tunnel node)))

(set-record-type-printer!
 <node>
 (lambda (node port)
   (let ((s (node-session node)))
     (format port "#<node ~a@~a:~a/~a ~a>"
             (session-get s 'user)
             (session-get s 'host)
             (session-get s 'port)
             (node-repl-port node)
             (number->string (object-address node) 16)))))


(define* (make-node session #:optional (repl-port 37146))
  "Make a new distributed computing node."
  (let ((tunnel (make-tunnel session
                             #:port 0          ;Won't be used
                             #:host (session-get session 'host)
                             #:host-port repl-port)))
    (%make-node tunnel repl-port)))

(define (skip-to-prompt repl-channel)
  "Read from REPL-CHANNEL until REPL is observed."
  (let loop ((line (read-line repl-channel)))
    (or (string=? "Enter `,help' for help." line)
        (loop (read-line repl-channel)))))

(define (get-result repl-channel)
  "Get result of evaluation form REPL-CHANNEL."
  (let* ((result (read-line repl-channel))
         (pattern "scheme@\\(guile-user\\)> \\$[0-9]+ = (.*)")
         (match  (string-match pattern result)))
    (or match
        (error "Could not read data from REPL channel" repl-channel result))
    (match:substring match 1)))

(define (node-eval node quoted-exp)
  "Evaluate QUOTED-EXP on the node and return the evaluated result."
  (let ((repl-channel (%node-open-repl-channel node)))
    (skip-to-prompt repl-channel)
    (write quoted-exp repl-channel)
    (newline repl-channel)
    (call-with-input-string (get-result repl-channel)
                            read)))

;;; node.scm ends here