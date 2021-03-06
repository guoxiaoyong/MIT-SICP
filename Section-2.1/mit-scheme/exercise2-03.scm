;;
;; Exercise 2.3
;;
;; Implement a representation for rectangles in a plane. (Hint: You may want to make use 
;; of exercise 2.2). In terms of your constructors and selectors, create procedures that
;; compute the perimeter and the area of a given example. Now implement a different
;; representation for rectangles. Can you design your system with suitable abstraction
;; barriers, so that the same perimeter and area procedures will work using either representation?
;;

;;
;; Two methods for representing rectangles in a plane are as follows:
;;
;; (1) Specify the upper-left-most point, and the lower-right-most point;
;; (2) Specify the upper-left-most point, and the width and height of the rectangle;
;;
;; Each representation will naturally have a different constructor.
;;
;; For both representation, let's specify the following selectors: "upper-left" and "lower-right"
;; which return the respective points of the rectangle, as well as "width" and "height", for obtaining
;; the width and height of the rectangle.
;;
;; We should be able to define the "perimeter" and "area" of the rectangle in a "representation-independent"
;; way by working only in terms of the width and height selectors.
;;

;;
;; First let's import the procedures we designed in Exercise 2.2:
;;
;; Support for Points:
;;
(define (make-point x y)
  (cons x y))
(define (x-point p) (car p))
(define (y-point p) (cdr p))

;; 
;; Support for Line Segments:
;;
(define (make-segment start-point end-point)
  (cons start-point end-point))
(define (start-segment s)
  (car s))
(define (end-segment s)
  (cdr s))

;;
;; Support for Euclidean distances:
;;
(define (distance-points p1 p2)
  (sqrt (+ (square (- (x-point p1) (x-point p2))) 
	   (square (- (y-point p1) (y-point p2))))))
(define (length-segment s)
  (distance-points (start-segment s) (end-segment s)))

;;
;; Support for printing Points:
;;
(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

;;
;; Lets start by implementing Model (1).
;;
;; We will construct the rectangle by specifying:
;;
;; (a) upper-left-x
;; (b) upper-left-y
;; (c) lower-right-x
;; (d) lower-right-y
;;
;; We create a data structure to hold these two points (upper-left, and lower-right)
;;
;; We want our constructor to signal an error if the user supplies rectangle dimensions
;; which are invalid:
;;
(define (make-rectangle upper-left-x upper-left-y lower-right-x lower-right-y)
  (cond ((and (> lower-right-x upper-left-x) (> upper-left-y lower-right-y))
	 (cons (make-point upper-left-x upper-left-y)
	       (make-point lower-right-x lower-right-y)))
	(else
	 (display "Error: rectangle dimensions are invalid!"))))

;;
;; Selectors:
;;
(define (upper-left rect)
  (car rect))

(define (lower-right rect)
  (cdr rect))

(define (width rect)
  (let ((p1 (upper-left rect))
	(p2 (lower-right rect)))
    (let ((p3 (make-point
	       (x-point p2)
	       (y-point p1))))
      (length-segment (make-segment p1 p3)))))

(define (height rect)
  (let ((p1 (upper-left rect))
	(p2 (lower-right rect)))
    (let ((p3 (make-point
	       (x-point p1)
	       (y-point p2))))
      (length-segment (make-segment p1 p3)))))

;;
;; Now define the "perimeter" and "area" procedures:
;;
(define (perimeter rect)
  (+ (* 2 (width rect)) (* 2 (height rect))))
(define (area rect)
  (* (width rect) (height rect)))

;;
;; Note that we can change the representational model for the rectangles, so long as 
;; we do not alter how the "width" and "height" procedures behave.
;;

;;
;; Let's run some use cases. 
;;
;; The following cases should all fail, owing to bad dimensions.
;;
(define r1 (make-rectangle 0 0 0 0))
;; ==> Invalid
(define r1 (make-rectangle 0 1 0 0))
;; ==> Invalid
(define r1 (make-rectangle 0 0 1 0))
;; ==> Invalid
(define r1 (make-rectangle 0 0 -1 0))
;; ==> Invalid
(define r1 (make-rectangle 0 0 0 -1))
;; ==> Invalid
(define r1 (make-rectangle 0 0 -1 -1))
;; ==> Invalid
(define r1 (make-rectangle 0 0 1 1))
;; ==> Invalid

;;
;; Now let's start working with "real" rectangles, and run them through our selectors:
;;
(define r1 (make-rectangle 0 1 1 0))
;; ==> r1
(print-point (upper-left r1))
;; ==> (0,1)
(print-point (lower-right r1))
;; ==> (1,0)
(width r1)
;; ==> 1
(height r1)
;; ==> 1
(perimeter r1)
;; ==> 4
(area r1)
;; ==> 1

(define r2 (make-rectangle 0 1 2 0))
;; ==> r2
(print-point (upper-left r2))
;; ==> (0,1)
(print-point (lower-right r2))
;; ==> (2,0)
(width r2)
;; ==> 2
(height r2)
;; ==> 1
(perimeter r2)
;; ==> 6
(area r2)
;; ==> 2

;; Now let's implement representational Model (2).
;;
;; As before, we still require 4 parameters to specify the rectangle, but this time
;; we will use:
;;
;; (a) upper-left-x
;; (b) upper-left-y
;; (c) width 
;; (d) height 
;;
;; Again, do some error checking to make sure the rectangle is valid.
;;
(define (make-rectangle upper-left-x upper-left-y width height)
  (cond ((and (> width 0) (> height 0))
	 (let ((p1 (make-point upper-left-x upper-left-y)))
	   (let ((p2 (make-point
		      (+ (x-point p1) width)
		      (- (y-point p1) height))))
	     (cons p1 p2))))
	(else
	 (display "Error: rectangle dimensions are invalid!"))))

;;
;; Note that if we construct the rectangle in this manner, we do not need
;; to alter any of the remaining selectors, nor do we need to change the 
;; "perimeter" or "area" procedures.
;;

;;
;; Again, let's check to make sure it rejects bad rectangles:
;;
(define r1 (make-rectangle 0 0 0 0))
;; ==> Invalid
(define r1 (make-rectangle 0 0 -1 0))
;; ==> Invalid
(define r1 (make-rectangle 0 0 0 -1))
;; ==> Invalid
(define r1 (make-rectangle 0 0 -1 -1))
;; ==> Invalid
(define r1 (make-rectangle 0 0 1 0))
;; ==> Invalid
(define r1 (make-rectangle 0 0 0 1))
;; ==> Invalid

;;
;; Let's re-run our test cases from before (without changing of any of the other selectors), 
;; and see if we still get the same answers. The "semantics" of the constructor have changed, 
;; and we must pass in different arguments to generate the "same" rectangle, but otherwise 
;; the selectors need not be updated.
;;
(define r1 (make-rectangle 0 1 1 1))
;; ==> r1
(upper-left r1)
;; ==> (0,1)
(lower-right r1)
;; ==> (1,0)
(width r1)
;; ==> 1
(height r1) 
;; ==> 1
(perimeter r1)
;; ==> 4
(area r1)
;; ==> 1

(define r2 (make-rectangle 0 1 2 1))
;; ==> r2
(upper-left r2)
;; ==> (0,1)
(lower-right r2)
;; ==> (2,0)
(width r2)
;; ==> 2
(height r2)
;; ==> 1 
(perimeter r2)
;; ==> 6
(area r2)
;; ==> 2