+step(0) <- ?grid_size(A,B);
			+max_left(0);
			+max_right(A);
			+max_up(0);
			+max_down(B);
			!work; !work.
+step(_) <- !work; !work.

+!work: dont_work <- -dont_work.
+!work <- -wait;
		  !look_around;
		  !decide_action;
		  !do_action.

+!look_around.
+!look_around <- for ( gold(X,Y) ) { +gold_pos(X,Y); };
				 for ( wood(X,Y) ) { +wood_pos(X,Y); }.
			
+!decide_action: i_am_here & target(X,Y) <- 
				 +wait;
				 -target(X,Y);
				 -i_am_here;
				 .abolish(come(_,_)).
+!decide_action: target(X,Y).
+!decide_action: come(X,Y) <- +target(X,Y).
+!decide_action <- +wait.

+!do_action: wait <- do(skip).
+!do_action: target(_,_) <- !go_to_target.

+!go_to_target: pos(X,Y) & target(Xt,Yt) & X < Xt <- do(right).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & X > Xt <- do(left).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & Y < Yt <- do(down).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & Y > Yt <- do(up).
+!go_to_target: target(A,B) <-			 +i_am_here; do(skip).


