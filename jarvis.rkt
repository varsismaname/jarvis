#lang racket

(require web-server/servlet
         web-server/servlet-env)

(define led-pins #hash(("red" . 22)
                       ("yellow" . 23)
                       ("green" . 24)))

(define pin-states (box (for/hash ([(color pin) led-pins])
                          (values pin #f))))

(define (gpio pin value)
  (with-output-to-file (string-append "/sys/class/gpio/gpio"
                                      (number->string pin) "/value")
    (lambda () (printf "~a\n" (if value "1" "0"))) #:exists 'update))

(define (toggle pin)
  (let* [(old (unbox pin-states))
         (new-value (not (hash-ref old pin)))]
    (set-box! pin-states (hash-set old pin new-value))
    ;; new in 5.3?
    ;; (box-cas! pin-states old (hash-set old pin new-value))
    (gpio pin new-value)))

(define (state color)
  (hash-ref (unbox pin-states) (hash-ref led-pins color)))

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

(define (setup)
  (for ([(color pin) led-pins])
    (with-output-to-file "/sys/class/gpio/export"
      (lambda () (printf (number->string pin))) #:exists 'update)
    (with-output-to-file (string-append "/sys/class/gpio/gpio"
                                        (number->string pin) "/direction")
      (lambda () (printf "out")) #:exists 'update))
  (serve/servlet start #:servlet-regexp #rx"" #:launch-browser? #f))

(provide start setup pin-states)
