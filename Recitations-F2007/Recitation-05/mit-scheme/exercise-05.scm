;;
;; Exercise 5
;;
;; Write a procedure "(intersection seg1 seg2)" that returns a point where two 
;; line segments intersect if they do, and returns #f if they do not intersect.
;; Be sure to honor the abstractions defined.
;;

;;
;; It will be useful to first define some helper methods.
;;
;; We would like to know both (a) the slope of the line; and (b) where the line
;; segment would intercept the y-axis if extended in both directions indefinitely 
;; (i.e., extend the line segment to a full line). 
;;
;; In other words, we would like to rewrite the line segment in terms of "y=mx+b" 
;; from standard high school algebra, and use this to solve the problem.
;;


;;
;; A procedure to find the slope of the line segment.
;;
;; Returns the numerical slope of the line when it exists.
;; If the line is vertical and the slope is "infinite", it
;; returns '(). 
;;
(define (slope line-segment)
  (let ((start (line-segment-start line-segment))
	(end (line-segment-end line-segment)))
    (let ((dx (- (point-x start) (point-x end)))
	  (dy (- (point-y start) (point-y end))))
      (if (= dx 0)
	  '()
	  ;; use 1.0 multiplier to make it into decimal
	  (* 1.0 (/ dy dx))))))

;;
;; Run some unit tests.
;;
;; Define four points on a square:
;;
(define p1 (make-point 1 1))
(define p2 (make-point 1 -1))
(define p3 (make-point -1 -1))
(define p4 (make-point -1 1))

;;
;; Define the six line segments joining them together:
;;
(define d1 (make-line-segment p1 p2))
(define d2 (make-line-segment p2 p3))
(define d3 (make-line-segment p3 p4))
(define d4 (make-line-segment p4 p1))
(define d5 (make-line-segment p1 p3))
(define d6 (make-line-segment p2 p4))

;;
;; Test the slopes of these line segments:
;;
(slope d1)
(slope d2)
(slope d3)
(slope d4)
(slope d5)
(slope d6)

;;
;; As additional test, test "reverse" going line segments.
;;

;;
;; get "b"
;;
(define (y-intercept line-segment)
  (let ((p (line-segment-start line-segment))
	(m (slope line-segment)))
    (cond ((not (null? m))
	   (let ((x (point-x p))
		 (y (point-y p)))
	     (- y (* m x)))))))

;; 
;; check if the lines are parallel
(define (parallel? line-segment-1 line-segment-2)
  (cond ((and (null? (slope line-segment-1)) (null? (slope line-segment-2))) #t)
	((and (null? (slope line-segment-1)) (not (null? (slope line-segment-2)))) #f)
	((and (null? (slope line-segment-2)) (not (null? (slope line-segment-1)))) #f)
	(else
	 (if (= (slope line-segment-1) (slope line-segment-2))
	     #t
	     #f))))

;;
;; define the intersect method
;; (this will determine where the lines determined by the line segments 
;; will intersect);
;;
(define (intersect line-segment-1 line-segment-2)
  (if (parallel? line-segment-1 line-segment-2)
      (display "Lines are parallel!")
      (let ((m1 (slope line-segment-1))
	    (m2 (slope line-segment-2))
	    (b1 (y-intercept line-segment-1))
	    (b2 (y-intercept line-segment-2)))
	(let ((x (/ (- b2 b1) (- m1 m2))))
	  (make-point x
		      (+ (* m1 x) b1))))))
	      
;;
;; Now it still remains to determine whether the 




(define (slope line-segment)
  (let ((start (line-segment-start line-segment))
	(end (line-segment-end line-segment)))
    (let ((dx (- (point-x start) (point-x end)))
	  (dy (- (point-y start) (point-y end)))))
    (if (= dx 0)
	'()
	(/ dy dx))))


(define (slope line)
  (let ((start (line-segment-start line))
	(end (line-segment-end line)))
    (let ((dx (- (point-x start) (point-x end)))
	  (dy (- (point-y start) (point-y end)))))
    (if (= dx 0)
	'()
	(/ dy dx))))

(define (intersection line1 line2)
  (define (between x a b)
    (and (>= x a)
	 (<= x b)))
  (let ((a (line-segment-start line1))
	(b (line-segment-end line1))
	(c (line-segment-start line2))
	(d (line-segment-end line2)))
  