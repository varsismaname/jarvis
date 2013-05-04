#lang racket

(require web-server/servlet
         web-server/servlet-env)

(define led-pins #hash(("red" . 23) ("green" . 18)))

;; TODO: use a box here?
(define pin-states (let ((h (make-hash)))
                     (for/list ([(color pin) led-pins])
                       (hash-set! h pin #f))
                     h))

(define (gpio pin value)
  (hash-set! pin-states pin value)
  (with-output-to-file (string-append "/sys/class/gpio/gpio"
                                      (number->string pin) "/value")
    (lambda () (printf "~a\n" (if value "1" "0"))) #:exists 'update))

(define (toggle pin)
  (gpio pin (not (hash-ref pin-states pin))))

(define (state color)
  (hash-ref pin-states (hash-ref led-pins color)))

(define (toggle-link color)
  `(p ((style ,(string-append "color: " color)))
      (a ((href ,(string-append "/toggle-" color))) ,color) ": "
      ,(if (state color)
           "On" "Off")))

(define (start request)
  (let* [(match (regexp-match #rx"/toggle-([a-z]+)"
                              (url->string (request-uri request))))
         (color (and match (cadr match)))]
    (if (and color (hash-has-key? led-pins color))
        (begin (toggle (hash-ref led-pins color))
               (redirect-to "/"))
        (response/xexpr
         `(html
           (head (style ((type "text/css")) "body { font-size: 300% }"))
           (body
            (h1 "Jarvis")
            ,@(map toggle-link (hash-keys led-pins))))))))

(provide start pin-states)

;; (serve/servlet start #:servlet-regexp #rx"" #:launch-browser? #f)
