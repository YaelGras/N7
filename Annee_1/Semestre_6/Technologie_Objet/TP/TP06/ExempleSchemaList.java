import java.util.ArrayList;
import java.util.List;

import afficheur.Ecran;

public class ExempleSchemaList {

	public static void main(String[] args) {
			
		Point p1 = new PointNomme(3, 2, "A");
		Point p2 = new PointNomme(6, 9, "S");
		Point p3 = new Point(11, 4);
		double sx = p1.getX() + p2.getX() + p3.getX();
		double sy = p1.getY() + p2.getY() + p3.getY();
		Point barycentre = new PointNomme(sx / 3, sy / 3, "C");
		
		//Création de la liste
		List<Schema> Liste = new ArrayList<Schema>();
		Liste.add(new Segment(p1, p2));
		Liste.add(new Segment(p2, p3));
		Liste.add(new Segment(p3, p1));
		Liste.add(barycentre);
		
		Ecran ecran = new Ecran("ExempleSchema2", 600, 400, 20);
		ecran.dessinerAxes();
		
		for (Schema schema : Liste) {
			schema.dessiner(ecran);
		}
		
		for (Schema schema : Liste) {
			schema.translater(4, -3);
		}
		
		for (Schema schema : Liste) {
			schema.dessiner(ecran);
		}
	}

}
