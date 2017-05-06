// Internal action code for project AgsProjekt.mas2j

package aStar;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;
import java.awt.Point;
import java.util.ArrayList;
import java.util.List;

public class aStar extends DefaultInternalAction
{
    
    class Square
    {
        public Point coordinates;
        public Square parent;

        public Square(Point coordinates, Square parent)
        {
            this.coordinates = coordinates;
            this.parent = parent;
        }

        public int f(Point end)
        {
            return this.g() + manhattanDistance(this.coordinates, end);
        }
        
        public int g()
        {
            if (parent != null)
            {
                return parent.g() + 1;
            }
            
            return 0;
        }
    }

    public ArrayList<Square> getWalkable(Square square, List<Point> obstacles, int width, int height)
    {
        ArrayList<Square> walkable = new ArrayList<Square>();
        Square squareUp = new Square(new Point(square.coordinates.x, square.coordinates.y + 1), square);
        Square squareDown = new Square(new Point(square.coordinates.x, square.coordinates.y - 1), square);
        Square squareRight = new Square(new Point(square.coordinates.x + 1, square.coordinates.y), square);
        Square squareLeft = new Square(new Point(square.coordinates.x - 1, square.coordinates.y), square);

        if (squareUp.coordinates.y < height && !obstacles.contains(squareUp.coordinates))
        {
            walkable.add(squareUp);
        }

        if (squareDown.coordinates.y >= 0 && !obstacles.contains(squareDown.coordinates))
        {
            walkable.add(squareDown);
        }

        if (squareRight.coordinates.x < width && !obstacles.contains(squareRight.coordinates))
        {
            walkable.add(squareRight);
        }

        if (squareLeft.coordinates.x >= 0 && !obstacles.contains(squareLeft.coordinates))
        {
            walkable.add(squareLeft);
        }

        return walkable;
    }

    public Square getLowestScore(List<Square> squares, Point end)
    {
        Square min = null;
        
        if (!squares.isEmpty())
        {
            min = squares.get(0);

            for (Square s : squares)
            {
                if (s.f(end) <= min.f(end))
                {
                    min = s;
                }
            }
        }
        
        return min;
    }
    
    public Square getByCoordinates(List<Square> squares, Point coords)
    {
        Square output = null;
        
        for (Square s : squares)
        {
            if (s.coordinates.equals(coords))
            {
                output = s;
            }
        }
        
        return output;
    }

    public int manhattanDistance(Point p1, Point p2)
    {
        return Math.abs(p1.x - p2.x) + Math.abs(p1.y - p2.y);
    }

    public List<Square> aStarAlg(Point start, Point end, List<Point> obstacles, int width, int height)
    {
        Square startSquare = new Square(start, null);
        ArrayList<Square> open = getWalkable(startSquare, obstacles, width, height);
        ArrayList<Square> closed = new ArrayList<Square>();
        closed.add(startSquare);
        
        while (!open.isEmpty())
        {            
            Square lowest = getLowestScore(open, end);
            if(lowest.coordinates.equals(end))
            {
                closed.add(lowest);
                break;
            }
            
            open.remove(lowest);
            closed.add(lowest);
            
            List<Square> walkable = getWalkable(lowest, obstacles, width, height);
            
            for (Square w : walkable)
            {
                if (getByCoordinates(closed, w.coordinates) == null)
                {
                    if (getByCoordinates(open, w.coordinates) == null)
                    {
                        open.add(w);
                    }
                    else
                    {
                        Square wOld = getByCoordinates(open, w.coordinates);
                        if (w.f(end) < wOld.f(end))
                        {
                            wOld.parent = w.parent;
                        }
                    }
                }
            }
        }

        return getPath(closed);
    }
    
    public List<Square> getPath(List<Square> squares)
    {
        ArrayList<Square> path = new ArrayList<Square>();
        
        Square s = squares.get(squares.size() - 1);
        
        while(s.parent != null)
        {
            path.add(0, s);
            s = s.parent;
        }        
        
        return path;
    }	
    
    public List<Point> getObstacles(List<Term> obstacleTerms)
    {
        ArrayList<Point> obstacles = new ArrayList<Point>();
        for (Term obstacle : obstacleTerms)
        {
            String obstacleTermString = obstacle.toString();
            String[] obstacleTermValues = obstacleTermString.substring(obstacleTermString.indexOf("(") + 1, obstacleTermString.indexOf(")")).split(",");
            obstacles.add(new Point(Integer.parseInt(obstacleTermValues[0]), Integer.parseInt(obstacleTermValues[1])));
        }
        
        return obstacles;
    }

        
    // arguments:
    // 0 - start.X
    // 1 - start.Y
    // 2 - end.X
    // 3 - end.Y
    // 4 - list of obstacles
    // 5 - width
    // 6 - height
    // 7 - output unification:
    //     0 - unknown
    //     1 - up
    //     2 - right
    //     3 - down
    //     4 - left
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception
    {
		int move = 0;
		int startX = (int) ((NumberTerm)args[0]).solve();
		int startY = (int) ((NumberTerm)args[1]).solve();
		int endX = (int) ((NumberTerm)args[2]).solve();
		int endY = (int) ((NumberTerm)args[3]).solve();
		List<Term> obstacles = (ListTerm)args[4];
		int width = (int) ((NumberTerm)args[5]).solve();
		int height = (int) ((NumberTerm)args[6]).solve();
		
		Point startPoint = new Point(startX, startY);
                Point endPoint = new Point(endX, endY);
		
		List<Square> path = aStarAlg(startPoint, endPoint, getObstacles(obstacles), width, height);
		Square last = path.get(path.size() -1);
                
                if(last.coordinates.equals(endPoint))
                {
                    Square nextStep = path.get(0);

                    // up or down
                    if(nextStep.coordinates.x == startPoint.x)
                    {
                            // down
                            if(nextStep.coordinates.y == startPoint.y + 1)
                            {
                                    move = 3;
                            }
                            // up
                            else
                            {
                                    move = 1;
                            }
                    }
                    // right or left
                    else
                    {
                            // right
                            if(nextStep.coordinates.x == startPoint.x + 1)
                            {
                                    move = 2;
                            }
                            // left
                            else
                            {
                                    move = 4;
                            }
                    }
                }
		
		
		return un.unifies(args[7], new NumberTermImpl(move)); 
    }
}

