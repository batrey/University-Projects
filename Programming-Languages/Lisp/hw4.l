;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Your solution goes in this file ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;             PART 1              ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; 1

(defun cycle (n xlist)
        (when (null xlist)
            (return-from cycle nil))  
            (dotimes (x n)
                (setq var (nth 0 xlist))
                (setq xlist (delete var xlist))
                (push var (cdr (last xlist)))
            )
    xlist)

;;(print(cycle 2 '(i j 1 2 k l) ))

;;; 2

(defun split-list (a xlist &optional built)
        (when (null xlist)
            (return-from split-list built))
        
        ;;check that last element in xlist is not a split character
        ;;if it is, remove it and continue
        (setq lemt (car (last xlist)))
        (if (eq lemt a)
                (setq xlist (butlast xlist)))
                
        ;;set rest = everything after first split
        (setq rest (cdr (member a xlist)))
        
        ;;if rest is null, set first to be the entire xlist
        ;;if not, set first to be everything before rest (-split)
        (if (null rest)
              (setq first xlist)
            (setq first (butlast xlist (+(list-length rest) 1)))) ;first = (a b)

        ;;if first is null, start recursion again with rest
        (when (null first)
            (return-from split-list (split-list a rest built)))

        ;;if built is null, add first to it
        (if (null built)
              (setq built (list first))
              (nconc built (list first)))
        
        ;;restart recursion again with rest      
        (split-list a rest built)
    built)
    
;;(print(split-list '2 '(2 1 2 2 3 4 2 6 7 2)))
;;(print(split-list 1 '(a b 1 c d 1 e f) ))

;;; 3

(defun range (xlist)
        (when (null xlist)
            (return-from range nil)) 
        (let ((low 1000) (high -1000) (mean 0))
            (dolist (cur xlist)
                (if (< high cur)
                    (setq high cur))
                (if (> low cur)
                    (setq low cur))
                (setq mean (+ mean cur))
            )
            (setq mean (/ mean (list-length xlist)))
            (setq xlist (list low mean high)))
    xlist)
    
;;(print(range '(6 6 5 -4 3 2 1 1)))

;;; 4

(defun search-count (a xlist)
        (let ((count 0))
            (dolist (cur xlist)
                (if (eq a cur)
                    (setq count (+ count 1)))
            )
    count))
    
;;(print(search-count 'h '(2 d t h 3 h 6)))




;;; 5
(defun pivot  (f xs)
    (when (null xs)
            (return-from pivot nil)) 
    (let ((l '(1)) (r '(1)))
        (loop for x in xs
            if (<  x f) 
               do (nconc l (list x))
            else 
               do (nconc r (list x))
        )
        (setq l (remove (car l) l :count 1))
        (setq r (remove (car r) r :count 1))
        (setq l (list l))
        (nconc l (list r))
    l))
          
;;(print(pivot 3 '(3 2 5 1 4)))



;;; 6

(defun quicksort (list)
  (when list
    (destructuring-bind (p . xs) list
      (let ((lesser (remove-if-not (lambda (x) (< x p)) xs))
            (greater (remove-if-not (lambda (x) (>= x p)) xs)))
       (append(quicksort lesser) (list p) (quicksort greater))))))


;;(print(quicksort '(6 4 3 1 7 9)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;             PART 2              ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
    
;;;returns only T or nil
(defun match (pattern assertion)
  (setf out t)      ;to be returned
  (setf len 0)      ;assumes no !, used to compare assetions length with patterns length
  (setf templist pattern) ;unchanging copy of pattern
  
  ;;;pattern should never be longer than assertion
  (if (> (length pattern) (length assertion))
    ;;;THEN
    (setf out nil)
    ;;;ELSE
    (progn
    (loop for elm in templist
    do
    ;;;handles ?
    (if (equal elm '?)
      ;;;THEN
      (progn
        (if (= (length assertion) 0)
          (setf out nil)
          (progn
            (setf assertion (cdr assertion))
            (setf pattern (cdr pattern))
          )
        )
      )
      ;;;ELSE
      (progn
        ;;;handles !
        (if (equal elm '!)
          ;;;THEN
          (progn
            ;;makes sure assetion is not bigger then pattern
            (if (equal (length pattern) 1)
              (progn
                (setf len 1)
                (loop for elm2 in assertion
                  do
                  (setf assertion (cdr assertion))
                )
                (setf pattern (cdr pattern))
              )
              (progn
                ;;;pattern and assetion can be different lengths
                (setf len 1)
                ;;;compare next elements
                (unless (or (equal (cadr pattern) '?) (equal (cadr pattern) '!) 
                    (equal (cadr pattern) (cadr assertion)))
                  ;;; if any above are true, break loop
                  (setf assertion (cdr assertion))
                )
                (setf assertion (cdr assertion))
                (setf pattern (cdr pattern))
              )
            )
          )
          ;;;ELSE
          (progn
            ;;;normal comparisons
            (if (equal (car assertion) elm)
              ;;;THEN
              (progn
                (setf assertion (cdr assertion))
                (setf pattern (cdr pattern))
              )
              ;;;ELSE
              (setf out nil)
            )
          )
        )
      )
    )
  )
  (if (equal len 1)
    ;;;THEN
    (progn 
      (if (/= (length assertion) 0)
        (setf out nil)
      )
    )
  )
  ;;;if no exclamation mark
  (if (equal len 0)
    (progn
      ;;;not equal
      (if (/= (length assertion) 0)
        (setf out nil)
      )
    )
  )))
  out
)    
    
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;             PART 3              ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
;; HAD TO COMMENT ALL OF THIS OUT BECAUSE IT WAS
;; CAUSING INFINITE RECURSION FOR TESTING

;;(defun matrix-add (m1 m2)
;;  (mapcar (lambda (r1 r2) (mapcar #'+ r1 r2)) m1 m2))
			       
;;(defun matrix-multiply (a b)
;;  (flet ((col (mat i) (mapcar #'(lambda (row) (elt row i)) mat))
;;         (row (mat i) (elt mat i)))
;;    (loop for row from 0 below (length a)
;;          collect (loop for col from 0 below (length (row b 0))
;;                        collect (apply #'+ (mapcar #'* (row a row) (col b col)))))))			       
;;    
;;    (defun Matrix-transpose (matrix)
;;(let ((result
;;(make-array (reverse (array-dimensions matrix))
;;:element-type (array-element-type matrix))))
;;(dotimes (i (array-dimension result 0) result)
;;(dotimes (j (array-dimension result 1))
;;(setf (aref result i j) (aref matrix j i))))))