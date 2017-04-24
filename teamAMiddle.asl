+step(0) <- ?grid_size(A,B);
			+max_left(0);
			+max_right(A);
			+max_up(0);
			+max_down(B);
			+right;
			// !work; !work.
			do(skip); do(skip).

+!work: dont_work <- -dont_work.
+!work <- !look_around;
			-walk_around;
			-go_to_depot;
			-pick_up;
			-wait;
		  	!decide_action;
			!do_action.

+!look_around <- for ( gold(X,Y) ) { +gold_pos(X,Y); };
				 for ( wood(X,Y) ) { +wood_pos(X,Y); }.
			
+step(_) <- !look_around; !step2.
+!step2: pos(A,B) & come(A,B) & ally(A,B) & moves_left(C) <- 
	.println("YES");
	.abolish(come(_,_));
	if (C == 2) { do(skip);do(skip); }
	if (C == 1) { do(skip); }.

+!step2: come(Xc,Yc) & moves_left(2) <- !go; !step2.
+!step2: come(Xc,Yc) <- !go.
+!step2 <- do(skip);do(skip).

	// if i am the closest one/the most qualified
+!need_help(Agent): pos(X,Y) <-
			// $$$ VYBER AGENTU $$$
		.send(Agent, tell, midPos(X,Y)).

+!go: pos(A,B) & come(Xc, Yc) & A < Xc <- do(right).
+!go: pos(A,B) & come(Xc, Yc) & A > Xc <- do(left).
+!go: pos(A,B) & come(Xc, Yc) & B < Yc <- do(down).
+!go: pos(A,B) & come(Xc, Yc) & B > Yc <- do(up).
+!go: true <- do(skip);do(skip).

+!go_deposit: pos(X,Y) & depot(X,Y) & moves_left(MVS) <-
				if (MVS == 3) { +dont_work(2); do(drop); }
				else { do(skip); }.
+!go_deposit: pos(X,Y) & depot(Xd,Yd) & X < Xd <- do(right).
+!go_deposit: pos(X,Y) & depot(Xd,Yd) & X > Xd <- do(left).
+!go_deposit: pos(X,Y) & depot(Xd,Yd) & Y < Yd <- do(down).
+!go_deposit: pos(X,Y) & depot(Xd,Yd) & Y > Xd <- do(up).


