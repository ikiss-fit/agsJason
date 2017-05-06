+step(0) <- ?grid_size(A,B);
			!get_friends;
			+max_right(A);
			+max_down(B);
			+systematic_movement;
			+target(0,0);
			+last_target(0,0);
			+view(3);
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
+!decide_target: systematic_movement & last_target(Lx,Ly) & Lx == 0 <-
	-last_target(Lx,Ly); 
	?max_right(Mx); 
	+target(Mx-1, Ly); 
	+last_target(Mx-1,Ly).
+!decide_target: systematic_movement & last_target(Lx,Ly) & max_down(My) & view(W) & Ly + 2*W - 1 < My <-
	-last_target(Lx,Ly);
	+target(0, Ly + 2*W - 1);
	+last_target(0, Ly + 2*W - 1).
+!decide_target: systematic_movement <-
	?max_right(Mx); 
	?max_down(My); 
	-last_target(_,_); 
	+target(0, My-1); 
	+last_target(0, My-1); 
	-systematic_movement.
+!decide_target <- 
	?max_right(Width); 
	?max_down(Height); 
	+target(math.floor(math.random * Width), math.floor(math.random * Height)).

+!go_to_target: obstacle_pos(X,Y) & target(X,Y) <- -target(X,Y); do(skip).
+!go_to_target: target(X,Y) & spectacles(X,Y) <- -target(A,B); +glasses; -view(3); +view(6); do(pick).
+!go_to_target: target(X,Y) & pos(X,Y) <- -target(X,Y); do(skip).
+!go_to_target: pos(X,Y) & target(Xt,Yt) <- 
	.findall(o(A,B), obstacle_pos(A,B), Obs);  
	?max_right(Width);
	?max_down(Height);
	aStar.aStar(X,Y, Xt,Yt, Obs, Width, Height, D);
	!lets_move(D);.
+!go_to_target <- -i_am_here; -target(_,_); do(skip).

+!lets_move(0) <- -target(_,_); do(skip).
+!lets_move(1) <- do(up).
+!lets_move(2) <- do(right).
+!lets_move(3) <- do(down).
+!lets_move(4) <- do(left).

