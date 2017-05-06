+step(0) <- ?grid_size(A,B);
			!get_friends;
			+max_left(0);
			+max_right(A);
			+max_up(0);
			+max_down(B);
			!work; !work.
+step(_) <- !work; !work.

+!work: dont_work <- -dont_work.
+!work <- !look_around;
		  -wait;
		  !decide_action;
		  !do_action.

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
					 ?slow_friend(Slow); 
					 .send(Slow, tell, obstacle_pos(Xo,Yo));
				 }.

+!get_friends: friend(aFast) <- +fast_friend(aFast); +slow_friend(aSlow).
+!get_friends: friend(bFast) <- +fast_friend(bFast); +slow_friend(bSlow).

@set_target[atomic]+!come(X,Y) <- -target(_,_); +target(X,Y).
		  
		  
+!decide_action: target(X,Y).
+!decide_action <- +wait.

+!do_action: wait <- do(skip).
+!do_action: target(_,_) <- !go_to_target.

+!go_to_target: pos(X,Y) & target(X,Y) <- +i_am_here; do(skip).
+!go_to_target: pos(X,Y) & target(Xt,Yt) <- 
	.findall(o(A,B), obstacle_pos(A,B), Obs);  
	?max_right(Width);
	?max_down(Height);
	aStar.aStar(X,Y, Xt,Yt, Obs, Width, Height, D);
	!lets_move(D);.

+!lets_move(0) <- -target(_,_); do(skip).
+!lets_move(1) <- do(up).
+!lets_move(2) <- do(right).
+!lets_move(3) <- do(down).
+!lets_move(4) <- do(left).


