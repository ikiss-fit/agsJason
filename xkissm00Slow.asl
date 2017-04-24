// Slow agent - 1 move, sees 3 pieces far
// only searches the map

+step(0) <- ?grid_size(A,B);
			+max_right(A);
			+max_down(B);
			+target(7,34);
			!work.

+step(X) <- !work.

+!work <- !look_around;
		  !decide_target;
		  !go_to_target.

+!look_around <- for ( gold(Xg,Yg) ) { +gold_pos(Xg,Yg); .broadcast(tell, gold_pos(Xg,Yg)); }
				 for ( wood(Xw,Yw) ) { +wood_pos(Xw,Yw); .broadcast(tell, wood_pos(Xw,Yw)); }
				 for ( obstacle(Xo,Yo) ) { +obstacle_pos(Xo,Yo); .broadcast(tell, obstacle_pos(Xo,Yo)); }
				 if ( spectacles(Xsp,Ysp) ) { +spectacles_pos(Xsp,Ysp); }
				 if ( shoes(Xsh,Ysh) ) { +spectacles_pos(Xsh,Ysh); .send(aFast, tell, shooes_pos(Xsh,Ysh)); }.

+!decide_target: target(_,_).
+!decide_target <- +target(math.floor(math.random * 34), math.floor(math.random * 34)).


+!go_to_target: pos(X,Y) & target(Xt,Yt) & X < Xt <- do(right).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & X > Xt <- do(left).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & Y < Yt <- do(down).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & Y > Yt <- do(up).
+!go_to_target: target(A,B) <- -target(A,B); .println("jsem tu"); do(skip).
