+step(0) <- ?grid_size(A,B);
			+max_left(0);
			+max_right(A);
			+max_up(0);
			+max_down(B);
			+right;
			+up;
			!work; !work; !work.

+!work: dont_work(C) & C == 2 <- -dont_work(2); +dont_work(1).
+!work: dont_work(C) & C == 1 <- -dont_work(1).
+!work <- !look_around;
			-walk_around;
			-go_to_depot;
			-pick_up;
			-wait;
			-call_help;
		  	!decide_action;
			!do_action.
			
+!look_around <- for ( gold(X,Y) ) { +gold_pos(X, Y); };
				 for ( wood(X,Y) ) { +wood_pos(X, Y); }.

+!decide_action: gold(A,B) & pos(A,B) & ally(A,B) & moves_left(MVS) <-
				if (MVS == 3) { +pick_up; }
				else { +wait; }.
+!decide_action: gold(A,B) & pos(A,B) & help_comming <- +wait.
+!decide_action: gold(A,B) & pos(A,B)<- +call_help.
+!decide_action: carrying_gold(Gn) & Gn > 0 <-
				?carrying_capacity(Gmax);
					// full hands = go to depot
				if (Gmax == Gn) { +go_to_depot; }
				else
				{ 	// something in hands and no gold in sight = depot
					.count(gold_pos(_,_), Free_gold);
					if (Gn > 0 & Free_gold == 0) { .println("jdu domu"); +go_to_depot; }
					else { +walk_around; }
				}.
+!decide_action: carrying_wood(Wn) & Wn > 0 <-
				?carrying_capacity(Gmax);
				if (Gmax == Gn) { +go_to_depot; }
				else
				{
					.count(wood_pos(_,_), Free_wood);
					if (Wn > 0 & Free_wood == 0) {  +go_to_depot; }
					else { +walk_around; }
				}.
				
+!decide_action: true <- +walk_around.

+!do_action: wait <- do(skip).
+!do_action: go_to_depot <- !go_deposit.
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
+!do_action: walk_around <- !go.
+!do_action: moves_left(MVS) <- if (MVS > 0) { do(skip); }.
// +step(X): shoes(A,B)&pos(A,B)<-do(pick).

+step(X): moves_per_round(6) <- !work; !work; !work; !work; !work; !work.
+step(X): moves_per_round(3) <- !work; !work; !work.

+!go: right & pos(A,_) & max_right(C) & A < C-1 <- do(right).
+!go: right & up & pos(_,B) & B > 0	<- -right; +left; do(up).
+!go: right & up <- -right; +left; -up; +down; do(down).
+!go: left & pos(A,_) & A > 0 					<- do(left).
+!go: left & up & pos(_,B) & B > 0 <- -left; +right; do(up).
+!go: left & up 					<- -up; +down; do(down).
+!go: down & pos(_,B) & max_down(C) & B < C-1 <- do(down).
+!go: down <- -down; +up; do(up).

+!go_deposit: pos(X,Y) & depot(X,Y) & moves_left(MVS) <-
				if (MVS == 3) { +dont_work(2); do(drop); }
				else { do(skip); }.
+!go_deposit: pos(X,Y) & depot(Xd,Yd) & X < Xd <- do(right).
+!go_deposit: pos(X,Y) & depot(Xd,Yd) & X > Xd <- do(left).
+!go_deposit: pos(X,Y) & depot(Xd,Yd) & Y < Yd <- do(down).
+!go_deposit: pos(X,Y) & depot(Xd,Yd) & Y > Xd <- do(up).
				

