+step(0) <- ?grid_size(A,B);
			!get_friends;
			+max_left(0);
			+max_right(A);
			+max_up(0);
			+max_down(B);
			!work; !work; !work.

+step(X): moves_per_round(6) <- !work; !work; !work; !work; !work; !work.
+step(X): moves_per_round(3) <- !work; !work; !work.

+!get_friends: friend(aSlow) <- +slow_friend(aSlow); +middle_friend(aMiddle).
+!get_friends: friend(bSlow) <- +slow_friend(bSlow); +middle_friend(bMiddle).


// every step = 3x work round (or 6x with shoes)
@do_it[atomic]+!work: dont_work(C) & C == 2 <- -dont_work(2); +dont_work(1).
@just_do_it[atomic]+!work: dont_work(C) & C == 1 <- -dont_work(1).
+!work <-	!look_around;
			-pick_up;
			-wait;
			-call_help;
		  	!decide_action;
			!do_action.
			
+!look_around <- for ( gold(Xg,Yg) )
				 {
				     +gold_pos(Xg,Yg);
				 }
				 
				 for ( wood(Xw,Yw) ) 
				 { 
				     +wood_pos(Xw,Yw);
				 }
				 
				 for ( obstacle(Xo,Yo) )
				 {
				     +obstacle_pos(Xo,Yo); 
					 ?slow_friend(Slow); 
					 .send(Slow, tell, obstacle_pos(Xo,Yo)); 
					 ?middle_friend(Middle); 
					 .send(Middle, tell, obstacle_pos(Xo,Yo));
				 }.

+!decide_action: i_am_here & pos(X,Y) & gold_pos(X,Y) & not gold(X,Y) <-
				 .abolish(i_am_here);
				 .abolish(target(X,Y));
				 .abolish(gold_pos(X,Y));
				 +wait.
+!decide_action: i_am_here & pos(X,Y) & wood_pos(X,Y) & not wood(X,Y) <-
				 .abolish(i_am_here);
				 .abolish(target(X,Y));
				 .abolish(wood_pos(X,Y));
				 +wait.
+!decide_action: i_am_here & pos(X,Y) & depot(X,Y) & moves_left(Mvs) <-
				 if (Mvs == 3) { -target(X,Y); +deposit; }
				 else			{ +wait; }.
+!decide_action: i_am_here & pos(X,Y) & ally(X,Y) & moves_left(Mvs) <-
				 if (Mvs == 3) { -target(X,Y); +pick_up; }
				 else 			{ +wait; }.
+!decide_action: target(X,Y).
+!decide_action: carrying_gold(Gn) & carrying_capacity(Gmax) & Gn == Gmax <-
				 ?depot(X,Y);
				 +target(X,Y).
+!decide_action: carrying_wood(Wn) & carrying_capacity(Wmax) & Wn == Wmax <-
				 ?depot(X,Y);
				 +target(X,Y).
+!decide_action: gold_pos(X,Y) & carrying_wood(Cw) & Cw == 0 <-
				 +target(X,Y);
				 +call_help.
+!decide_action: wood_pos(X,Y) & carrying_gold(Cg) & Cg == 0 <-
				 +target(X,Y); 
				 +call_help.
+!decide_action: carrying_gold(Cg) & Cg > 0 <-
				 ?depot(X,Y);
				 +target(X,Y).
+!decide_action: carrying_wood(Cw) & Cw > 0 <-
				 ?depot(X,Y);
				 +target(X,Y).
+!decide_action  <- +wait.

// an action MUST end with skip, drop, pick or go_to_target
+!do_action: wait <- do(skip).
+!do_action: call_help & target(X,Y) <- 
			?middle_friend(Middle);
			.send(Middle, achieve, come(X,Y));
			-call_help;
			?moves_left(MVS);
			if (MVS > 0) { !go_to_target; }.
+!do_action: deposit <-
			-i_am_here;
			-deposit;
			+dont_work(2);
			do(drop).
+!do_action: pick_up & pos(X,Y) & gold_pos(X,Y) <- 
			-i_am_here;
			.abolish(gold_pos(X,Y));
			+dont_work(2);
			-pick_up;
			do(pick).
+!do_action: pick_up & pos(X,Y) & wood_pos(X,Y) <-
			-i_am_here; 
			.abolish(wood_pos(X,Y));
			+dont_work(2);
			-pick_up; 
			do(pick).
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

// +step(X): shoes(A,B)&pos(A,B)<-do(pick)

