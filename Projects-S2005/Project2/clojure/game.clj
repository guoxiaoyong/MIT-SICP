(load-file "prisoner.clj")

;; ++++++++++++++++++++++++++++++++++++++++++++++++++
;; Problem 1
;;
;; Definition of "extract-entry"
;; ++++++++++++++++++++++++++++++++++++++++++++++++++

;;
;; The *game-association-list* is defined as follows:
;;
(def *game-association-list*
  (list (list (list "c" "c") (list 3 3))
        (list (list "c" "d") (list 0 5))
        (list (list "d" "c") (list 5 0))
        (list (list "d" "d") (list 1 1))))

;;
;; We can extract a specific entry in this list by using the "list-ref" procedure.
;;
;; For example:
;;
(nth *game-association-list* 0)
;; ==> (("c" "c") (3 3))
(nth *game-association-list* 1)
;; ==> (("c" "d") (0 5))

;;
;; and so on. To extract the entry associated with a specific play, we need to extract
;; the "car" of the entry, and make sure that both elements of this "car" correspond
;; to both elements of the argument play.
;;
;; We define our "extract-entry" procedure as follows:
;;
(defn extract-entry [play *list*]
  ;;
  ;; Return "true" if the play matches the entry:
  ;;
  (defn compare-play [play entry]
    (let [test (first entry)]
      (and (.equals (first play) (first test))
           (.equals (fnext play) (fnext test)))))

  (let
      ;;
      ;; Get references to each entry in the *game-association-list*:
      ;;
      [first (nth *list* 0)
       second (nth *list* 1)
       third (nth *list* 2)
       fourth (nth *list* 3)]

    ;;
    ;; If we find a match, return that specific entry:
    ;;
    (cond
     (compare-play play first) first
     (compare-play play second) second
     (compare-play play third) third
     (compare-play play fourth) fourth
     :else
     '())))

;;
;; We can test our procedure as follows:
;;
(extract-entry (make-play "c" "c") *game-association-list*)
;; ==> (("c" "c") (3 3))
(extract-entry (make-play "c" "d") *game-association-list*)
;; ==> (("c" "d") (0 5))
(extract-entry (make-play "d" "c") *game-association-list*)
;; ==> (("d" "c") (5 0))
(extract-entry (make-play "d" "d") *game-association-list*)
;; ==> (("d" "d") (1 1))
(extract-entry (make-play "x" "x") *game-association-list*)
;; ==> ()

;;
;; Similarly, since "get-point-list" is defined as:
;;
(defn get-point-list [game]
  (fnext (extract-entry game *game-association-list*)))

(get-point-list (make-play "c" "c"))
;; ==> (3 3)
(get-point-list (make-play "c" "d"))
;; ==> (0 5)
(get-point-list (make-play "d" "c"))
;; ==> (5 0)
(get-point-list (make-play "d" "d"))
;; ==> (1 1)