/** Programme de test de la classe Segment.
  * @author  Yael Gras
  * @version 1
  */
public class Exercice5{

	public static void main(String[] args) {
		// Créer trois points et trois segment à partir de ces points
		Point p1 = new Point(3,2);
                Point p2 = new Point(6 , 9.0);
                Point p3 = new Point(11 , 4);

                Segment s12 = new Segment(p1, p2);
                Segment s13 = new Segment(p1, p3);
                Segment s23 = new Segment(p2, p3);

                Point barycentre = new Point((p1.getX() + p2.getX() + p3.getX())/3, (p1.getY() + p2.getY() + p3.getY())/3);
                

                


	}
}

