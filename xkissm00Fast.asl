+step(0) <- ?grid_size(A,B);
			+max_left(0);
			+max_right(A);
			+max_up(0);
			+max_down(B);
			!work; !work; !work.

+step(X): moves_per_round(6) <- !work; !work; !work; !work; !work; !work.
+step(X): moves_per_round(3) <- !work; !work; !work.

// every step = 3x work round (or 6x with shoes)
@do_it[atomic]+!work: dont_work(C) & C == 2 <- -dont_work(2); +dont_work(1).
@just_do_it[atomic]+!work: dont_work(C) & C == 1 <- -dont_work(1).
+!work <- !look_around;
			-pick_up;
			-wait;
			-call_help;
		  	!decide_action;
			!do_action.

// work 1. - look around
+!look_around.			
+!look_around <- .println("looking around");
				 for ( gold(X,Y) ) { +gold_pos(X, Y); };
				 for ( wood(X,Y) ) { +wood_pos(X, Y); }.

// work 2. - decide next action in this work round
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

// work 3. - execute the action
// an action MUST end with skip, drop, pick or go_to_target
+!do_action: wait <- do(skip).
+!do_action: call_help & target(X,Y) <- 
			.send(aMiddle, tell, come(X,Y));
			-call_help;
			?moves_left(MVS);
			if (MVS > 0) { !go_to_target; }. // is this always true?
+!do_action: deposit <-
			-i_am_here;
			-deposit;
			+dont_work(2);
			do(drop).
+!do_action: pick_up & pos(X,Y) & gold_pos(X,Y) & not gold(X,Y) <-
			-i_am_here;
			.abolish(gold_pos(X,Y));
			-pick_up;
			.abolish(target(X,Y));
			do(skip).
+!do_action: pick_up & pos(X,Y) & wood_pos(X,Y) & not wood(X,Y) <-
			-i_am_here;
			.abolish(wood_pos(X,Y));
			-pick_up;
			.abolish(target(X,Y));
			do(skip).			
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


+!go_to_target: pos(X,Y) & target(Xt,Yt) & X < Xt <- do(right).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & X > Xt <- do(left).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & Y < Yt <- do(down).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & Y > Yt <- do(up).
+!go_to_target: pos(X,Y) & target(X,Y) <- +i_am_here; do(skip).

// +step(X): shoes(A,B)&pos(A,B)<-do(pick)

