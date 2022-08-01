#!/bin/sh 

SOLUTION=hw4.l  # only need to configure this if necessary
TESTFILE=test.l 
TMPFILE=check.l 
REFOUT=Output.correct
TMPOUT=Output.your

cat > $TMPFILE <<EOF
(load "$SOLUTION")
(load "$TESTFILE") 
(test) 
EOF

# cleanup 
echo "(1) remove existing output file" 
rm -f $TMPOUT

# run 
echo "(2) load your solution and test" 
clisp $TMPFILE > $TMPOUT

# diff 
echo "(3) check for differences" 
diff $TMPOUT $REFOUT

; test everything
(defun test ()
            (format t "~%~10TBEGIN TESTING~2%")
            (test-Cycle)
            (test-Split-list)
            (test-Range)
            (test-Search-count)   
            (test-Pivot)
            (test-Quicksort)
            (test-Match)
            (test-Matrix-add)
            (test-Matrix-multiply)
            (test-Matrix-transpose)
            (format t "~%~10TDONE TESTING~2%")
            t
)
 
; some shorthands, so that you can just type, e.g., (tr)
(defun tc  () (test-Cycle))
(defun tsl () (test-Split-list))
(defun tr  () (test-Range))
(defun tsc () (test-Search-count))
(defun tp  () (test-Pivot))
(defun tq  () (test-Quicksort))
(defun tm  () (test-Match))
(defun tma () (test-Matrix-add))
(defun tmm () (test-Matrix-multiply))
(defun tmt () (test-Matrix-transpose))

 
; use this to test everything and create Output.your
; then exit from clisp
; do a "diff Output.correct Output.your"
;   (use "diff -i Output.correct Output.your" if you're using
;    (setq *print-case* :downcase))
; files should be identical, except first few heading lines.
 
(defun td () (dribble "Output.your") (test) (dribble))
 
 
(defun test-Cycle ()
            (format t "~%~20TTEST-Cycle~2%")
            (tester cycle 1 nil )
            (tester cycle 2 '(a b c d e f) )
            (tester cycle 3 '(1 2 3 4 5) )
            (tester cycle 4 '(i j 1 2 k l) )
            (tester cycle 5 '(1 2 3 4) )
            (tester cycle 6 '(6 5 4 3 2 1) )
            (tester cycle 0 '(6 5 4 3 2 1) )
            (tester cycle 3 '(6 5 4 3 2 1) )
            t
)
 
(defun test-Split-list ()
            (format t "~%~20TTEST-Split-list~2%")
            (tester split-list 'a '())
            (tester split-list 'a '(b c d e f))
            (tester split-list 'd '(a b c d e f))
            (tester split-list '2 '(2 1 2 2 3 4 2 6 7 2))
            (tester split-list 'a '(c a d a b c d))
            (tester split-list '1 '(a b 1 c d 1 e f))
            (tester split-list '1 '(1 a b 1 c d 1 e f))
            (tester split-list '1 '(a b 1 c d 1 e f -1))
            (tester split-list '-1 '(a b -1 c d -1 e f -1))
            (tester split-list '1 '(1 1 1))
            t
)

(defun test-Range ()
            (format t "~%~20TTEST-Range~2%")
            (tester range '())
            (tester range '(5) )
            (tester range '(5 4 3 2 1) )
            (tester range '(0 6 8 2 3 -1) )
            (tester range '(8 8 8 8 8 8 8 8) )
            (tester range '(8 8 8 8 8 8 8 9) )
            (tester range '(6 6 5 -4 3 2 1 1) )
            (tester range '(0 -1 1 -2 2 -3 3) )
            t
)
 


(defun test-Search-count ()
            (format t "~%~20TTEST-Search-count~2%")
            (tester search-count 'a '())
            (tester search-count 'a '(b c d e f))
            (tester search-count 'a '(a b c e f))
            (tester search-count '2 '(2 1 2 2 3 4 2 6 7 2))
            (tester search-count 'a '(c a d a b c d))
            (tester search-count '1 '(a b 1 c d 1 e f))
            (tester search-count 'hi '(hello hey there))
            (tester search-count 'hi '(hi hello hey hi there))
            t
)

(defun test-Pivot()
            (format t "~%~20TTEST-Pivot~2%")
            (tester pivot 2 '())
            (tester pivot 5 '(6 4 3 1 7 9) )
            (tester pivot 3 '(3 2 5 1 4))
            (tester pivot 6 '(1 2 3 5 4 5) )
            (tester pivot 8 '(8 9 12 11 15) )
            (tester pivot 10 '(21 11 4 14 5 15 13 2 9) )
            (tester pivot 5 '(-6 4 -3 1 7 -9) )
            (tester pivot -3 '(3 2 -5 1 -4))
            (tester pivot 6 '(-1 2 3 5 4 -5) )
            (tester pivot -8 '(-8 -9 -12 -11 -15) )
            (tester pivot -10 '(-21 11 -4 14 5 -15 -13 2 9) )
            t
)

(defun test-Quicksort()
            (format t "~%~20TTEST-Quicksort~2%")
            (tester quicksort '())
            (tester quicksort '(6 4 3 1 7 9) )
            (tester quicksort '(8 1 -2 3 5 4) )
            (tester quicksort '(8 9 12 11 15) )
            (tester quicksort '(21 11 4 -14 5 15 13 2 9) )
            (tester quicksort '(21 -11 4 -14 -5 15 -13 2 9) )
            (tester quicksort '(21 11 4 0 14 5 15 13 2 9) )
            t
)

(defun test-Match ()
            (format t "~%~20TTEST-Match~2%")
            (tester match '(think about that) '(think that about) )
            (tester match '(think about that) '(think about that) )
            (tester match '(think about that) nil )
            (tester match nil '() )
            (tester match nil '(nil) )
            (tester match '(nil nil) '(nil) )
            (tester match '(nil nil) '(nil nil) )
            (tester match '(a a) '(a) )
            (tester match '(a ?) '(a a) )
            (tester match '(a nil ?) '(a nil nil) )
            (tester match '(? ? ? ?) '(what time is it) )
            (tester match '(? ? ? ? ?) '(what time is it now ah) )
            (tester match '(? ? ? ? ?) '(what time is it) )
            (tester match '(? color apple) '(color color apple nil) )
            (tester match '(this table is round ?) '(this table is round or) )
            (tester match '(this !) '(this table is round) )
            (tester match '(this ! is round) '(this table is round) )
            (tester match '(this table !) '(this this table is round) )
            (tester match '(! table is round) '(this table is round or) )
            (tester match '(! table is round) '(this table) )
            (tester match '(this ! round) '(this table is round) )
            (tester match '(is that fine ?) '(that fine too) )
            (tester match '(!) '(no matter what) )
            (tester match '(! !) '(no matter what) )
            (tester match '(! ! !) '(no matter what) )
            (tester match '(! ! ! !) '(no matter what) )
            (tester match '(! big ! ?) '(a yellow big wooden bag) )
            (tester match '(! big ! ?) '(a yellow big bag) )
            (tester match '(! ! ? ! !) '(how are you today ah) )
            (tester match '(! ! ! ! !) '(how are you today) )
            (tester match '(! ? ? funny !) '(is it really funny or what) )
            (tester match '(! ? ? funny !) '(is it really funny) )
            (tester match '(? ? ! ? a) '(a a a a) )
            (tester match '(? ? ! ? a !) '(a a a a a nil) )
            (tester match '(! b ? b a b a ! ? !) '(b b a b a b a b a b a) )
            (tester match '(! b ? a b a b ! ? !) '(b b a b a b a b a b) )
            t
)

(defun test-Matrix-add()
            (format t "~%~20TTEST-Matrix-add~2%")
            (tester matrix-add '() '())
            (tester matrix-add '((0)) '((0)))
            (tester matrix-add '((9)) '((15)))
            (tester matrix-add '((1 2) (2 1)) '((3 1) (1 3)) )
            (tester matrix-add '((1 2 3) (5 6 7)) '((8 9 10) (11 12 13)) )
            (tester matrix-add '((1 -2 3) (-5 6 7)) '((-8 9 -10) (-11 12 -13)) )
            (tester matrix-add '((1) (-5) (6) (7)) '((-8) (9) (-10) (-11)) )
            (tester matrix-add '((1 -2 3)) '((-8 9 -10)) )
            t
)

(defun test-Matrix-multiply()
            (format t "~%~20TTEST-Matrix-multiply~2%")
            (tester matrix-multiply '() '())
            (tester matrix-multiply '((1 2) (2 1)) '((3 1) (1 3)) )
            (tester matrix-multiply '((1 2) (2 1)) '((5 6 7) (8 9 10)) )
            (tester matrix-multiply '((1 -2) (2 -1)) '((5 -6 7) (-8 9 -10)) )
            (tester matrix-multiply '((1 0) (-1 1)) '((0 1 1) (0 1 0)) )
            (tester matrix-multiply '((0 0) (0 0)) '((0 0 0) (0 0 0)) )
            (tester matrix-multiply '((1 2) (2 1)) '((5 6 7 8) (9 10 11 12)) )
            (tester matrix-multiply '((1 0 1 9)) '((9) (8) (7) (6)) )
            t
)

(defun test-Matrix-transpose()
            (format t "~%~20TTEST-Matrix-transpose~2%")
            (tester matrix-transpose '(()))
            (tester matrix-transpose '(() ()))
            (tester matrix-transpose '((1 2) (3 4)))
            (tester matrix-transpose '((1 2) (3 4) (5 6)))
            (tester matrix-transpose '((a b) (c d) (e f) (g h)))
            (tester matrix-transpose '((a b c d) (e f g h)))
            (tester matrix-transpose '((a b c d e) (f g h i j)))
            (tester matrix-transpose '((a b c d e)))
            (tester matrix-transpose '((a) (b) (c) (d) (e)))
            t
)


; low-level testing routine
(defmacro tester (&rest x)
            (format t "testing:  ~A~%" x)
            ; split into 2 so print value even if eval fails.
            (format t "value:    ")
            (format t "~A~2%" (eval x))
            t
)
; test everything
(defun test ()
            (format t "~%~10TBEGIN TESTING~2%")
            (test-Cycle)
            (test-Split-list)
            (test-Range)
            (test-Search-count)   
            (test-Pivot)
            (test-Quicksort)
            (test-Match)
            (test-Matrix-add)
            (test-Matrix-multiply)
            (test-Matrix-transpose)
            (format t "~%~10TDONE TESTING~2%")
            t
)
 
; some shorthands, so that you can just type, e.g., (tr)
(defun tc  () (test-Cycle))
(defun tsl () (test-Split-list))
(defun tr  () (test-Range))
(defun tsc () (test-Search-count))
(defun tp  () (test-Pivot))
(defun tq  () (test-Quicksort))
(defun tm  () (test-Match))
(defun tma () (test-Matrix-add))
(defun tmm () (test-Matrix-multiply))
(defun tmt () (test-Matrix-transpose))

 
; use this to test everything and create Output.your
; then exit from clisp
; do a "diff Output.correct Output.your"
;   (use "diff -i Output.correct Output.your" if you're using
;    (setq *print-case* :downcase))
; files should be identical, except first few heading lines.
 
(defun td () (dribble "Output.your") (test) (dribble))
 
 
(defun test-Cycle ()
            (format t "~%~20TTEST-Cycle~2%")
            (tester cycle 1 nil )
            (tester cycle 2 '(a b c d e f) )
            (tester cycle 3 '(1 2 3 4 5) )
            (tester cycle 4 '(i j 1 2 k l) )
            (tester cycle 5 '(1 2 3 4) )
            (tester cycle 6 '(6 5 4 3 2 1) )
            (tester cycle 0 '(6 5 4 3 2 1) )
            (tester cycle 3 '(6 5 4 3 2 1) )
            t
)
 
(defun test-Split-list ()
            (format t "~%~20TTEST-Split-list~2%")
            (tester split-list 'a '())
            (tester split-list 'a '(b c d e f))
            (tester split-list 'd '(a b c d e f))
            (tester split-list '2 '(2 1 2 2 3 4 2 6 7 2))
            (tester split-list 'a '(c a d a b c d))
            (tester split-list '1 '(a b 1 c d 1 e f))
            (tester split-list '1 '(1 a b 1 c d 1 e f))
            (tester split-list '1 '(a b 1 c d 1 e f -1))
            (tester split-list '-1 '(a b -1 c d -1 e f -1))
            (tester split-list '1 '(1 1 1))
            t
)

(defun test-Range ()
            (format t "~%~20TTEST-Range~2%")
            (tester range '())
            (tester range '(5) )
            (tester range '(5 4 3 2 1) )
            (tester range '(0 6 8 2 3 -1) )
            (tester range '(8 8 8 8 8 8 8 8) )
            (tester range '(8 8 8 8 8 8 8 9) )
            (tester range '(6 6 5 -4 3 2 1 1) )
            (tester range '(0 -1 1 -2 2 -3 3) )
            t
)
 


(defun test-Search-count ()
            (format t "~%~20TTEST-Search-count~2%")
            (tester search-count 'a '())
            (tester search-count 'a '(b c d e f))
            (tester search-count 'a '(a b c e f))
            (tester search-count '2 '(2 1 2 2 3 4 2 6 7 2))
            (tester search-count 'a '(c a d a b c d))
            (tester search-count '1 '(a b 1 c d 1 e f))
            (tester search-count 'hi '(hello hey there))
            (tester search-count 'hi '(hi hello hey hi there))
            t
)

(defun test-Pivot()
            (format t "~%~20TTEST-Pivot~2%")
            (tester pivot 2 '())
            (tester pivot 5 '(6 4 3 1 7 9) )
            (tester pivot 3 '(3 2 5 1 4))
            (tester pivot 6 '(1 2 3 5 4 5) )
            (tester pivot 8 '(8 9 12 11 15) )
            (tester pivot 10 '(21 11 4 14 5 15 13 2 9) )
            (tester pivot 5 '(-6 4 -3 1 7 -9) )
            (tester pivot -3 '(3 2 -5 1 -4))
            (tester pivot 6 '(-1 2 3 5 4 -5) )
            (tester pivot -8 '(-8 -9 -12 -11 -15) )
            (tester pivot -10 '(-21 11 -4 14 5 -15 -13 2 9) )
            t
)

(defun test-Quicksort()
            (format t "~%~20TTEST-Quicksort~2%")
            (tester quicksort '())
            (tester quicksort '(6 4 3 1 7 9) )
            (tester quicksort '(8 1 -2 3 5 4) )
            (tester quicksort '(8 9 12 11 15) )
            (tester quicksort '(21 11 4 -14 5 15 13 2 9) )
            (tester quicksort '(21 -11 4 -14 -5 15 -13 2 9) )
            (tester quicksort '(21 11 4 0 14 5 15 13 2 9) )
            t
)

(defun test-Match ()
            (format t "~%~20TTEST-Match~2%")
            (tester match '(think about that) '(think that about) )
            (tester match '(think about that) '(think about that) )
            (tester match '(think about that) nil )
            (tester match nil '() )
            (tester match nil '(nil) )
            (tester match '(nil nil) '(nil) )
            (tester match '(nil nil) '(nil nil) )
            (tester match '(a a) '(a) )
            (tester match '(a ?) '(a a) )
            (tester match '(a nil ?) '(a nil nil) )
            (tester match '(? ? ? ?) '(what time is it) )
            (tester match '(? ? ? ? ?) '(what time is it now ah) )
            (tester match '(? ? ? ? ?) '(what time is it) )
            (tester match '(? color apple) '(color color apple nil) )
            (tester match '(this table is round ?) '(this table is round or) )
            (tester match '(this !) '(this table is round) )
            (tester match '(this ! is round) '(this table is round) )
            (tester match '(this table !) '(this this table is round) )
            (tester match '(! table is round) '(this table is round or) )
            (tester match '(! table is round) '(this table) )
            (tester match '(this ! round) '(this table is round) )
            (tester match '(is that fine ?) '(that fine too) )
            (tester match '(!) '(no matter what) )
            (tester match '(! !) '(no matter what) )
            (tester match '(! ! !) '(no matter what) )
            (tester match '(! ! ! !) '(no matter what) )
            (tester match '(! big ! ?) '(a yellow big wooden bag) )
            (tester match '(! big ! ?) '(a yellow big bag) )
            (tester match '(! ! ? ! !) '(how are you today ah) )
            (tester match '(! ! ! ! !) '(how are you today) )
            (tester match '(! ? ? funny !) '(is it really funny or what) )
            (tester match '(! ? ? funny !) '(is it really funny) )
            (tester match '(? ? ! ? a) '(a a a a) )
            (tester match '(? ? ! ? a !) '(a a a a a nil) )
            (tester match '(! b ? b a b a ! ? !) '(b b a b a b a b a b a) )
            (tester match '(! b ? a b a b ! ? !) '(b b a b a b a b a b) )
            t
)

(defun test-Matrix-add()
            (format t "~%~20TTEST-Matrix-add~2%")
            (tester matrix-add '() '())
            (tester matrix-add '((0)) '((0)))
            (tester matrix-add '((9)) '((15)))
            (tester matrix-add '((1 2) (2 1)) '((3 1) (1 3)) )
            (tester matrix-add '((1 2 3) (5 6 7)) '((8 9 10) (11 12 13)) )
            (tester matrix-add '((1 -2 3) (-5 6 7)) '((-8 9 -10) (-11 12 -13)) )
            (tester matrix-add '((1) (-5) (6) (7)) '((-8) (9) (-10) (-11)) )
            (tester matrix-add '((1 -2 3)) '((-8 9 -10)) )
            t
)

(defun test-Matrix-multiply()
            (format t "~%~20TTEST-Matrix-multiply~2%")
            (tester matrix-multiply '() '())
            (tester matrix-multiply '((1 2) (2 1)) '((3 1) (1 3)) )
            (tester matrix-multiply '((1 2) (2 1)) '((5 6 7) (8 9 10)) )
            (tester matrix-multiply '((1 -2) (2 -1)) '((5 -6 7) (-8 9 -10)) )
            (tester matrix-multiply '((1 0) (-1 1)) '((0 1 1) (0 1 0)) )
            (tester matrix-multiply '((0 0) (0 0)) '((0 0 0) (0 0 0)) )
            (tester matrix-multiply '((1 2) (2 1)) '((5 6 7 8) (9 10 11 12)) )
            (tester matrix-multiply '((1 0 1 9)) '((9) (8) (7) (6)) )
            t
)

(defun test-Matrix-transpose()
            (format t "~%~20TTEST-Matrix-transpose~2%")
            (tester matrix-transpose '(()))
            (tester matrix-transpose '(() ()))
            (tester matrix-transpose '((1 2) (3 4)))
            (tester matrix-transpose '((1 2) (3 4) (5 6)))
            (tester matrix-transpose '((a b) (c d) (e f) (g h)))
            (tester matrix-transpose '((a b c d) (e f g h)))
            (tester matrix-transpose '((a b c d e) (f g h i j)))
            (tester matrix-transpose '((a b c d e)))
            (tester matrix-transpose '((a) (b) (c) (d) (e)))
            t
)


; low-level testing routine
(defmacro tester (&rest x)
            (format t "testing:  ~A~%" x)
            ; split into 2 so print value even if eval fails.
            (format t "value:    ")
            (format t "~A~2%" (eval x))
            t
)
