+step(0) <- ?grid_size(A,B);
			+max_left(0);
			+max_right(A);
			+max_up(0);
			+max_down(B);
			!work; !work.
+step(_) <- !work; !work.

+!work: dont_work <- -dont_work.
+!work <- -wait;
		  !decide_action;
		  !do_action.

@set_target[atomic]+!come(X,Y) <- -target(_,_); +target(X,Y).
		  
		  
+!decide_action: target(X,Y).
+!decide_action <- +wait.

+!do_action: wait <- do(skip).
+!do_action: target(_,_) <- !go_to_target.

+!go_to_target: pos(X,Y) & target(Xt,Yt) & X < Xt <- do(right).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & X > Xt <- do(left).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & Y < Yt <- do(down).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & Y > Yt <- do(up).
+!go_to_target: target(A,B) <- -target(A,B); do(skip).


