// Slow agent - 1 move, sees 3 pieces far
// only searches the map

+step(0) <- ?grid_size(A,B);
			!get_friends;
			+max_right(A);
			+max_down(B);
			!work.

+step(X) <- !work.

+!get_friends: friend(aFast) <- +fast_friend(aFast); +middle_friend(aMiddle).
+!get_friends: friend(bFast) <- +fast_friend(bFast); +middle_friend(bMiddle).

+!work <- !look_around;
		  !decide_target;
		  !go_to_target.

+!look_around: not glasses & spectacles(Xsp,Ysp) & target(X,Y) <- -target(X,Y); +target(Xsp,Ysp).
+!look_around <- for ( gold(Xg,Yg) )
				 {
				     +gold_pos(Xg,Yg); 
				     ?fast_friend(Fast); 
				     .send(Fast, tell, gold_pos(Xg,Yg));
				 }
				 
				 for ( wood(Xw,Yw) ) 
				 { 
				     +wood_pos(Xw,Yw); 
				     ?fast_friend(Fast); 
				     .send(Fast, tell, wood_pos(Xw,Yw));
				 }
				 
				 for ( obstacle(Xo,Yo) )
				 {
				     +obstacle_pos(Xo,Yo); 
					 ?fast_friend(Fast); 
					 .send(Fast, tell, obstacle_pos(Xo,Yo)); 
					 ?middle_friend(Middle); 
					 .send(Middle, tell, obstacle_pos(Xo,Yo));
				 }
				 
				 if ( shoes(Xsh,Ysh) ) 
				 {
				     +shoes_pos(Xsh,Ysh); 
					 ?fast_friend(Fast); 
					 .send(Fast, tell, shoes_pos(Xsh,Ysh));
				 }.

+!decide_target: target(_,_).
+!decide_target <- +target(math.floor(math.random * 35), math.floor(math.random * 35)).


+!go_to_target: pos(X,Y) & target(Xt,Yt) & X < Xt <- do(right).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & X > Xt <- do(left).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & Y < Yt <- do(down).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & Y > Yt <- do(up).
+!go_to_target: target(X,Y) & spectacles(X,Y) <- -target(A,B); +glasses; do(pick).
+!go_to_target: target(A,B) <- 			-target(A,B); do(skip).
