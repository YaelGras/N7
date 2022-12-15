import afficheur.Afficheur;
import java.awt.Color;
public class AfficheurTexte implements Afficheur {
	
	/** Ecrire dans la sortie standard un point
	 * @param point point à écrire dans la sortie standard
	 */
	public void dessinerPoint(Point point) {
		System.out.println("Point { ");
		System.out.println("      x = " + point.getX());
		System.out.println("      y = " + point.getY());
		System.out.println("      couleur = " + point.getCouleur());
		System.out.println("}");
	}
	
	/** Ecrire dans la sortie standard un point
	 * @param x coordonnée x du point 
	 * @param y coordonnée y du point 
	 * @param c couleur du point 
	 */
	public void dessinerPoint(double x, double y, Color c) {
		System.out.println("Point { ");
		System.out.println("      x = " + x);
		System.out.println("      y = " + y);
		System.out.println("      couleur = " + c);
		System.out.println("}");
	}
	
	
	/** Ecrire dans la sortie standard un cercle
	 * @param x coordonnée x du centre du cercle 
	 * @param y coordonnée y du centre du cercle
	 * @param rayon rayon du cercle
	 * @param c couleur du cercle 
	 */	
	public void dessinerCercle(double x, double y, double rayon, Color c) {
		System.out.println("Cercle { ");
		System.out.println("      centre_x = " + x);
		System.out.println("      centre_y = " + y);
		System.out.println("      rayon = " + rayon);
		System.out.println("      couleur = " + c);
		System.out.println("}");
	}
	
	/** Ecrire dans la sortie standard une ligne
	 * @param x1 coordonnée x de l'extremité 1 de la ligne
	 * @param y1 coordonnée y de l'extremité 1 de la ligne
	 * @param x2 coordonnée x de l'extremité 2 de la ligne
	 * @param y2 coordonnée y de l'extremité 2 de la ligne
	 * @param c couleur de la ligne 
	 */
	public void dessinerLigne(double x1, double y1, double x2, double y2, Color c) {
		System.out.println("Ligne { ");
		System.out.println("      x1 = " + x1);
		System.out.println("      y1 = " + y1);
		System.out.println("      x2 = " + x2);
		System.out.println("      y2 = " + y2);
		System.out.println("      couleur = " + c);
		System.out.println("}");
	}

	/** Ecrire dans la sortie standard un texte
	 * @param x coordonnée x du texte
	 * @param y coordonnée y du texte
	 * @param texte valeur du texte
	 * @param c couleur du texte 
	 */
	public void dessinerTexte(double x, double y, String texte, Color c) {
		System.out.println("Texte { ");
		System.out.println("      x = " + x);
		System.out.println("      y = " + y);
		System.out.println("      valeur = \"" + texte + "\"");
		System.out.println("      couleur = " + c);
		System.out.println("}");		
	}
}
