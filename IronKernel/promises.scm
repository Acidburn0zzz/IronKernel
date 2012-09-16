(provide! (promise? memoize lazy force)

	(define (encapsulate promise? decapsulate)
		(make-encapsulation-type))
		
	(define memoize
		(lambda (value)
			(encapsulate (list (vector value ())))))
			
	(define lazy
		(vau (exp) env
			(encapsulate (list (vector exp env)))))
			
	(define force
		(lambda (x)
			(if (not? (promise? x))
				x
				(force-promise (decapsulate x)))))
				
	(define force-promise
		(lambda (x)
			(let* (((v) x) (object (vector-ref v 0)) (env (vector-ref v 1)))
				(if (not? (environment? env))
					object
					(handle-promise-result x (eval env object))))))
					
	(define handle-promise-result
		(lambda (x y)
			(let* (((v) x) (fst (vector-ref v 0)) (snd (vector-ref v 1)))
			(cond ((null? snd); check for earlier result
					fst)
				((not? (promise? y))
					(vector-set! v 0 y);
					(vector-set! v 1 ()); memoize
					y)
				(#t
					(vector-set! v 0 (decapsulate y)); iterate
					(force-promise x)))))))