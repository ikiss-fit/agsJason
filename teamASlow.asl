+step(0) <- ?grid_size(A,B);
			+max_left(0);
			+max_right(A);
			+max_up(0);
			+max_down(B);
			+right;
			do(skip).

+step(X): pos(A,B) & come(A,B) & ally(A,B) <- 
	.println("YES");
	.abolish(come(_,_));
	do(pick).
+step(X): come(Xc,Yc) <- !go.
+step(X) <- do(skip).

+!go: pos(A,B) & come(Xc, Yc) & A < Xc <- do(right).
+!go: pos(A,B) & come(Xc, Yc) & A > Xc <- do(left).
+!go: pos(A,B) & come(Xc, Yc) & B < Yc <- do(down).
+!go: pos(A,B) & come(Xc, Yc) & B > Xc <- do(up).
+!go: true <- do(skip).
