import afficheur.Ecran;

/** Construire le schéma proposé dans le sujet de TP avec des points,
  * et des segments.
  *
  * @author	Gras Yael
  * @version 1
  */
public class ExempleSchema2 {

	/** Construire le schéma et le manipuler.
	  * Le schéma est affiché.
	  * Ensuite, il est translaté et affiché de nouveau.
	  * @param args les arguments de la ligne de commande
	  */
	public static void main(String[] args)
	{
		// Créer les trois segments
		PointNomme A = new PointNomme(3, 2, "A");
		PointNomme S = new PointNomme(6, 9, "S");
		Point p = new Point(11, 4);
		Segment s12 = new Segment(A, S);
		Segment s23 = new Segment(S, p);
		Segment s31 = new Segment(p, A);

		// Créer le barycentre
		double sx = A.getX() + S.getX() + p.getX();
		double sy = A.getY() + S.getY() + p.getY();
		PointNomme C = new PointNomme(sx / 3, sy / 3, "C");

		// Afficher le schéma
		System.out.println("Le schéma est composé de : ");
		s12.afficher();		System.out.println();
		s23.afficher();		System.out.println();
		s31.afficher();		System.out.println();
		C.afficher();	System.out.println();
		// Créer l'écran d'affichage
		Ecran ecran = new Ecran("ExempleSchema1", 600, 400, 20);
		ecran.dessinerAxes();

		// Dessiner le schéma sur l'écran graphique
		s12.dessiner(ecran);
		s23.dessiner(ecran);
		s31.dessiner(ecran);
		C.dessiner(ecran);

		// Translater le schéma
		System.out.println("Translater le schéma de (4, -3) : ");
		s12.translater(4, -3);
		s23.translater(4, -3);
		s31.translater(4, -3);
		C.translater(4, -3);

		// Afficher le schéma
		System.out.println("Le schéma est composé de : ");
		s12.afficher();		System.out.println();
		s23.afficher();		System.out.println();
		s31.afficher();		System.out.println();
		C.afficher();	System.out.println();

		// Dessiner le schéma sur l'écran graphique
		s12.dessiner(ecran);
		s23.dessiner(ecran);
		s31.dessiner(ecran);
		C.dessiner(ecran);

		// Forcer l'affichage du schéma (au cas où...)
		ecran.rafraichir();
	}

}

