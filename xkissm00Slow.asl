// Slow agent - 1 move, sees 3 pieces far
// only searches the map

+step(0) <- ?grid_size(A,B);
			+max_right(A);
			+max_down(B);
			!work.

+step(X) <- !work.

+!work <- !look_around;
		  !decide_target;
		  !go_to_target.

+!look_around: not glasses & spectacles(Xsp,Ysp) & target(X,Y) <- -target(X,Y); +target(Xsp,Ysp).
+!look_around <- for ( gold(Xg,Yg) ) { +gold_pos(Xg,Yg); .broadcast(tell, gold_pos(Xg,Yg)); }
				 for ( wood(Xw,Yw) ) { +wood_pos(Xw,Yw); .broadcast(tell, wood_pos(Xw,Yw)); }
				 for ( obstacle(Xo,Yo) ) { +obstacle_pos(Xo,Yo); .broadcast(tell, obstacle_pos(Xo,Yo)); }
				 if ( shoes(Xsh,Ysh) ) { +shoes_pos(Xsh,Ysh); .send(aFast, tell, shoes_pos(Xsh,Ysh)); }.

+!decide_target: target(_,_).
+!decide_target <- +target(math.floor(math.random * 35), math.floor(math.random * 35)).


+!go_to_target: pos(X,Y) & target(Xt,Yt) & X < Xt <- do(right).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & X > Xt <- do(left).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & Y < Yt <- do(down).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & Y > Yt <- do(up).
+!go_to_target: target(X,Y) & spectacles(X,Y) <- -target(A,B); +glasses; do(pick).
+!go_to_target: target(A,B) <- 			-target(A,B); do(skip).
