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
(defn
  ^{:doc "Extract the game play record associated with the argument play. For instance, invoking with ('c' 'c') and *game-association-list* will return (('c' 'c') (3 3))."}
  extract-entry [play *list*]
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

;; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;; Problem 2
;;
;; Use "play-loop" to play games between the five strategies.
;; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;;
;; I'm not going to reproduce all the game play statistics here, but
;; the results basically mirror those in the reference MIT-SCHEME implementation.
;; Refer to the reference MIT-SCHEME implementation for further details.
;;

;; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;; Problem 3
;;
;; Explore more efficient ways to code EGALITARIAN.
;; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;;
;; For reference, the original definition of EGALITARIAN was given as:
;;
(defn EGALITARIAN [my-history other-history]
  ;; Define counting procedure
  (defn count-instances-of [test hist]
    (cond (empty-history? hist) 0
	  (.equals (most-recent-play hist) test) (+ (count-instances-of test (rest-of-plays hist)) 1)
	  :else
	  (count-instances-of test (rest-of-plays hist))))

  ;; Examine the history
  (let [ds (count-instances-of "d" other-history)
	cs (count-instances-of "c" other-history)]
    (if (> ds cs) "d" "c")))

;;
;; For any one particular game play, the code here makes:
;;
;;  (1) a "linear" walk down the "other-history" list;
;;  (2) a second "linear" walk down the "other-history" list;
;;
;; So for each game play, if the "other-history" is of size k,
;; the procedure executes in O(2*k) time.
;;
;; In other words, when the history is of length 1, the play
;; executes in time 2*1. When the history is of length 2, the
;; play executes in time 2*2. When the history is of length k,
;; the play executes in time 2*k.
;;
;; We are executing a total of n plays. That means the total
;; time to execute all n plays is:
;;
;; T(n) = 2 * ( 1 + 2 + ... + n )
;; T(n) = 2 * n * ( n + 1 ) / 2
;; T(n) = n * (n+1)
;;
;; In O-notation, this procedure will execute in O(n^2) time.
;;

;;
;; Alyssa's new definition of EGALITARIAN is given as:
;;
(defn EGALITARIAN [my-history other-history]
  ;; Define iterative loop
  (defn majority-loop [cs ds hist]
    (cond (empty-history? hist) (if (> ds cs) "d" "c")
	  (.equals (most-recent-play hist) "c") (majority-loop (+ 1 cs) ds (rest-of-plays hist))
	  :else
	  (majority-loop cs (+ 1 ds) (rest-of-plays hist))))

  ;; Invoke iterative loop
  (majority-loop 0 0 other-history))

;;
;; Using this procedure, for any one particular game play, we
;; still make a "linear" walk down the length of the "other-history"
;; list, but for each game play, we only make one linear walk down
;; this list, not two.
;;
;;
;; Hence, for each game play, if the "history" is of size k, the
;; procedure executes in O(k) time.
;;
;; In other words, we expect the procedure to execute roughly twice
;; as fast as the previous EGALITARIAN procedure.
;;
;; We are executing a total of n plays. That means the total
;; time to execute all n plays is:
;;
;; T(n) = 1 + 2 + .. + n
;; T(n) = n * (n+1) / 2
;;
;; In O-notation, this procedure will execute in O(n^2) time.
;;
;; In other words, in O-notation, this procedure will executes in
;; roughly the same order of magnitude time as the previous
;; procedure: it scales as n^2, where n is the number of game plays.
;; However, there is some (considerable) savings in this procedure,
;; owing to the fact that each game play executes in roughly 1/2
;; the time that it took using the first procedure.
;;

;;
;; As a test, let's implement a "timed-play-loop" procedure that
;; (a) runs more play sets; and (b) prints out timing statistics,
;; so we can see whether program execution actually performs the
;; way we would predict.
;;
(defn
  ^{:doc "Time how long it takes for two strategies to run against each other 'times' number of times."}
  timed-play-loop [strat0 strat1 times]

  (defn
    ^{:doc "Procedure for executing the game play an arbitrary number of times."}
    timed-play-loop-iter [count history0 history1 limit]
    (cond (= count limit) (print-out-results history0 history1 limit)
	  :else
	  (let [result0 (strat0 history0 history1)
		result1 (strat1 history1 history0)]
	    (timed-play-loop-iter (+ count 1)
				  (extend-history result0 history0)
				  (extend-history result1 history1)
				  limit))))

  ;;
  ;; Bracket execution loop for timing purposes
  ;;
  (let [start (System/currentTimeMillis)]
    (timed-play-loop-iter 0 the-empty-history the-empty-history times)
    (let [finish (System/currentTimeMillis)]
      (print "Timing: ")
      (println (- finish start)))))

;;
;; Let's build a matrix of the time it takes to execute 150 game plays
;; and see which procedures are the slowest.
;;
;;
;; The entries in the matrix correspond to the time required for the
;; 150 game plays to execute. The following matrix uses the "original"
;; definition of the EGALITARIAN procedure:
;;

;;
;;                 ----------------------------------------------------------------- 
;;                 |  NASTY  |  PATSY  |  SPASTIC  |  EGALITARIAN  |  EYE-FOR-EYE  |
;; --------------------------------------------------------------------------------- 
;; |     NASTY     |    16   |    13   |     12    |      180      |      13       | 
;; --------------------------------------------------------------------------------- 
;; |     PATSY     |    13   |    10   |      9    |      178      |       7       | 
;; --------------------------------------------------------------------------------- 
;; |    SPASTIC    |    12   |     9   |     12    |      180      |      12       | 
;; --------------------------------------------------------------------------------- 
;; |  EGALITARIAN  |   180   |   178   |    180    |      344      |     177       | 
;; --------------------------------------------------------------------------------- 
;; |  EYE-FOR-EYE  |    13   |     7   |     12    |      177      |       9       |
;; --------------------------------------------------------------------------------- 
;;

;;
;; Clearly EGALITARIAN takes much longer to execute than do the other strategies, requiring
;; roughly 180 ticks to execute the 150 plays. Notice also that when playing against itself,
;; EGALITARIAN requires roughly twice as much time (i.e., 344 ticks) to execute the 150 plays.
;;

;;
;; We anticipate that the new definition of the EGALITARIAN procedure will run roughly
;; twice as quickly. Using the new definition, we obtain the following performance matrix:
;;

;;
;;                 ----------------------------------------------------------------- 
;;                 |  NASTY  |  PATSY  |  SPASTIC  |  EGALITARIAN  |  EYE-FOR-EYE  |
;; --------------------------------------------------------------------------------- 
;; |     NASTY     |    13   |    10   |     9     |      103      |       14      |
;; --------------------------------------------------------------------------------- 
;; |     PATSY     |    10   |     7   |     8     |       91      |       10      | 
;; --------------------------------------------------------------------------------- 
;; |    SPASTIC    |     9   |     8   |    10     |       91      |        9      |
;; --------------------------------------------------------------------------------- 
;; |  EGALITARIAN  |   103   |    91   |    91     |      175      |       92      |
;; --------------------------------------------------------------------------------- 
;; |  EYE-FOR-EYE  |    14   |    10   |     9     |       92      |        8      |
;; ---------------------------------------------------------------------------------
;;

;;
;; As anticipated, the performance is still slow (i.e., O(n^2)), although the new
;; procedure performs roughly twice as efficiently as the original procedure (as
;; we anticipated).
;;

;; +++++++++++++++++++++++++++++++++++++++++++++++++++++++
;; Problem 4
;;
;; Write a new "eye-for-two-eyes" strategy.
;; +++++++++++++++++++++++++++++++++++++++++++++++++++++++

;;
;; For reference, the original EYE-FOR-EYE strategy is defined as:
;;