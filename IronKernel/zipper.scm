
; original -- http://okmij.org/ftp/Scheme/zipper-in-scheme.txt

(defn (map* f l)
  (if (null? l) l
    (cons (f (car l)) (map* f (cdr l)))))
	
(defn (depth-first handle tree)
	(if (null? tree) 
		tree
		(let ((result (handle tree))) 
			(if result 
				result
				(cond
					((not? (pair? tree)) tree) ; an atom
					(#t
						(cons (car tree) 			; node name
							(map* (lambda (kid) (depth-first handle kid)) (cdr tree))))
					)))))	
	
(define tree1 '(a (b) (c (d 1 2)) e))
(define tree2 '(z (u) (v (w 10 12)) y))

(depth-first (lambda (node) (begin (show node) (print "\n") #f)) tree1)

(provide! (zipper zipper? z-curr-node z-k)

	(define (encapsulate zipper? decapsulate)
		(make-encapsulation-type))
		
	(define zipper 
		(lambda x (encapsulate x)))
	
	(define z-curr-node 
		(lambda (x) (car (decapsulate x))))
		
	(define z-k 
		(lambda (x) (cadr (decapsulate x))))
)

(defn (zip-tree tree)
  (reset (depth-first (lambda (tree) (shift (lambda (f) (zipper tree f)))) tree)))

(defn (print-tree tree)
	(letrec* 
		((cursor (zip-tree tree))
		(loop 
			(lambda 
				(x) 
				(if 
					(zipper? x) 
					(begin 
						(show (z-curr-node x)) 
						(print "\n") 
						(loop ((z-k x) #f)))
					#f))))
		(loop cursor)))
	