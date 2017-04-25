+step(0) <- ?grid_size(A,B);
			+max_left(0);
			+max_right(A);
			+max_up(0);
			+max_down(B);
			!work; !work; !work.

+step(X): moves_per_round(6) <- !work; !work; !work; !work; !work; !work.
+step(X): moves_per_round(3) <- !work; !work; !work.
			
+!work: dont_work(C) & C == 2 <- -dont_work(2); +dont_work(1).
+!work: dont_work(C) & C == 1 <- -dont_work(1).
+!work <- !look_around;
			-go_to_depot;
			-pick_up;
			-wait;
			-call_help;
		  	!decide_action;
			!do_action.

+!look_around.			
+!look_around <- for ( gold(X,Y) ) { +gold_pos(X, Y); };
				 for ( wood(X,Y) ) { +wood_pos(X, Y); }.

+!decide_action: i_am_here & pos(X,Y) & depot(X,Y) & moves_left(Mvs) <-
				 if (Mvs == 3) { -target(X,Y); +deposit; }
				 else			{ +wait; }.
+!decide_action: i_am_here & pos(X,Y) & ally(X,Y) & moves_left(Mvs) <-
				.println("tak co bude");
				 if (Mvs == 3) { -target(X,Y); +pick_up; }
				 else 			{ +wait; }.
+!decide_action: target(X,Y).
+!decide_action: carrying_gold(Gn) & carrying_capacity(Gmax) & Gn == Gmax <-
				 ?depot(X,Y);
				 +target(X,Y).
+!decide_action: gold_pos(X,Y) <- +target(X,Y); +call_help.
+!decide_action: true <- +wait.
// old
+!decide_action: gold(A,B) & pos(A,B) & ally(A,B) & moves_left(MVS) <-
				if (MVS == 3) { +pick_up; }
				else { +wait; }.
+!decide_action: gold(A,B) & pos(A,B) & help_comming <- +wait.
+!decide_action: gold(A,B) & pos(A,B)<- +call_help.

				
+!decide_action: true <- +walk_around.


+!do_action: wait <- do(skip).
+!do_action: call_help & target(X,Y) <- 
			.send(aMiddle, tell, come(X,Y));
			-call_help;
			?moves_left(MVS);
			if (MVS > 0) { !go_to_target; }.
+!do_action: deposit <- -i_am_here; -deposit; +dont_work(2); do(drop).
+!do_action: pick_up & pos(X,Y) & gold_pos(X,Y) <- 
			-i_am_here;
			.abolish(gold_pos(X,Y));
			+dont_work(2);
			-pick_up; do(pick).
+!do_action: pick_up & pos(X,Y) & wood_pos(X,Y) <-
			-i_am_here; 
			.abolish(wood_pos(X,Y));
			+dont_work(2);
			-pick_up; do(pick).
+!do_action: target(_,_) <- !go_to_target.
+!do_action: gold(A,B) & pos(A,B) & pick_up <-
				.abolish(gold_pos(A,B));
				+dont_work(2);
				-help_comming;
				do(pick).
+!do_action: call_help & pos(X,Y) & .my_name(Name) <- 
				.send(aMiddle, achieve, need_help(Name));
				.wait( { +midPos(Xmid,Ymid) } );
				.send(aSlow, tell, need_halp(Name));
				// .wait( { +slowPos(Xslow,Yslow) } );
				// 1] calculate distance
				// 2] choose buddy
				// budy is aMiddle now
				.send(aMiddle, tell, come(X,Y));
				+help_comming;
				?moves_left(MVS);
				if (MVS > 0) { do(skip); }.
// +step(X): shoes(A,B)&pos(A,B)<-do(pick).

+!go_to_target: pos(X,Y) & target(Xt,Yt) & X < Xt <- do(right).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & X > Xt <- do(left).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & Y < Yt <- do(down).
+!go_to_target: pos(X,Y) & target(Xt,Yt) & Y > Yt <- do(up).
+!go_to_target: target(A,B) <-			 +i_am_here; do(skip).

