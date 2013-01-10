;;
;; Exercise 2.83
;;
;; [WORKING]
;;

;;
;; Both the tower diagram and the problem statement refer to a type hierarchy that
;; looks something like the following:
;;
;;  integer --> rational --> real --> complex
;;
;; We do not presently have an "integer" or a "real" number package. 
;; 
;; Let's agree to use our pre-existing "scheme-number" package as the "real" package.
;;
;; Let's furthermore design an "integer" package which will be very similar to 
;; the "scheme-number" package, except that the domain will be restricted to integers.
;; Notably, we will not support the division operation, since integers are not closed
;; under the division operation.
;; 
(define (install-integer-package)
  (define (tag x)
    (attach-tag 'integer x))
  (put 'add '(integer integer)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(integer integer)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(integer integer)
       (lambda (x y) (tag (* x y))))
  (put 'exp '(integer integer)
       (lambda (x y) (tag (expt x y))))
  (put 'equ? '(integer integer)
       (lambda (x y) (= x y)))
  (put '=zero? '(integer)
       (lambda (p) (= p 0)))
  ;;
  ;; Check to make sure its an integer, 
  ;; otherwise round to nearest integer:
  ;;
  (put 'make 'integer
       (lambda (x) (tag (if (integer? x) x (round x)))))

  'done)

(define (make-integer n)
  ((get 'make 'integer) n))
  
;;
;; In practice, other than in name, there is little-to-no difference between the 
;; "scheme-number" package and the "integer" package.
;;

;;
;; Install the integer package:
;;
(install-integer-package)

;;
;; We will also define a coercion procedure, to coerce the integers into 
;; scheme-numbers, should this be required (strictly speaking, this is 
;; overkill, since for both "scheme-number" and "integer" the tags are 
;; removed and the interpreter manipulates these symbols as per the rules
;; of standard arithmetic .. but for the sake of completeness and consistency,
;; let's define and install these methods):
;;
(define (integer->scheme-number n)
  (make-scheme-number n))

(put-coercion 'integer 'scheme-number integer->scheme-number)

;;
;; Let's run some unit tests:
;;
(define i1 (make-integer 2))
(define i2 (make-integer 3))
(define i3 (make-integer 0))

(add i1 i2)
;; ==> 5
(sub i1 i2)
;; ==> -1
(mul i1 i2)
;; ==> 6
(exp i1 i2)
;; ==> 8
(equ? i1 i2)
;; ==> #f
(equ? i1 i1)
;; ==> #t
(=zero? i1)
;; ==> #f
(=zero? i3)
;; ==> #t

;;
;; The "coercion" allows us to divide integers anyway (even though we didn't
;; define the procedure for this type):
;;
(div i1 i2)
;; ==> 2/3

;;
;; Let's see if we only get "integers" when constructing integers:
;;
(make-integer 2)
;; ==> 2
(make-integer 2.1)
;; ==> 2.
(make-integer 2.6)
;; ==> 3.

;;
;; Let's see if we can combine integers with scheme-numbers (of course we can, 
;; for the reasons cited above, but still run the unit tests):
;;
(define s1 (make-scheme-number 2))
(define s2 (make-scheme-number 3))

(add i1 s2)
;; ==> 5
(add s2 i1)
;; ==> 5

(sub i1 s2)
;; ==> -1
(sub s2 i1)
;; ==> 1

(mul i1 s2)
;; ==> 6
(mul s2 i1)
;; ==> 6

(exp i1 s2)
;; ==> 8
(exp s2 i1)
;; ==> 9

(equ? i1 s2)
;; ==> #f
(equ? s2 i1)
;; ==> #f

(equ? i1 s1)
;; ==> #t
(equ? s1 i1)
;; ==> #t

;;
;; As per "coercion", we can even perform division:
;;
(div i1 s2)
;; ==> 2/3
(div s2 i1)
;; ==> 3/2

;;
;; Now let's define our "raise" procedures:
;;
(define (raise-integer->rational n)
  (make-rational n 1))

(define (raise-rational->scheme-number r)
  (let ((n (numer r))
	(d (denom r)))
    (make-scheme-number (exact->inexact (/ n d)))))

(define (raise-scheme-number->complex n)
  (make-complex-from-real-imag n 0))

;;
;; Run through some unit tests:
;;
(raise-integer->rational (make-integer 2))
;; ==> (rational 2 . 1)
(raise-integer->rational (make-integer 2.1))
;; ==> (rational 2. . 1.)
(raise-integer->rational (make-integer 2.6))
;; ==> (rational 3. . 1.)

(raise-rational->scheme-number (make-rational 1 2))
;; ==> 0.5
(raise-rational->scheme-number (make-rational 3 1))
;; ==> 3.

(raise-scheme-number->complex 3)
;; ==> (complex rectangular 3 . 0)
(raise-scheme-number->complex 3.14)
;; ==> (complex rectangular 3.14 . 0)

;;
;; We now define the generic "raise" procedure:
;;
(define (raise x) (apply-generic 'raise x))

;;
;; And we update the operations table:
;;
(put 'raise '(scheme-number) raise-scheme-number->rational)
(put 'raise '(rational)
     (lambda (z) (attach-tag 'complex (raise-rational->complex z))))
    