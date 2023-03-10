import java.awt.Color;
/**
  * Cercle modélise un cercle géométrique dans un plan équipé
  * d'un repère cartesien. Un cercle peut être  translaté et
  * affiché. On peut savoir si un point est a l'intérieur du
  * cercle, limite incluse. On peut obtenir son aire et son
  * diamètre.
  *
  * @author	Yael Gras
  * @version 2
  */

public class Cercle implements Mesurable2D {

	/**Centre du cercle.
	 */
	private Point center;

	/**Rayon du cercle.
	 */
	private double radius;

	/**Couleur du cercle.
	 */
	private Color color;

	/**Nombre PI.
	 */
	public static final double PI = Math.PI;

	/** Construire un cercle à partir de son centre et de son rayon.
	 * @param center point central
	 * @param radius rayon
	 */
	// @require (center != null && radius > 0);
	// @ensures this.center != null && this.radius > 0;
	public Cercle(Point center, double radius) {
		assert (center != null && radius > 0);
		this.center = new Point(center.getX(), center.getY());
		this.center.setCouleur(center.getCouleur());
		this.radius = radius;
		this.color = Color.blue;
	}

	/** Construire un cercle à partir de deux point diametralement opposés.
	 * @param point1 premier point
	 * @param point2 deuxième point
	 */
	// @require point1 != null && point2 != null;
	// @require	(point1.getX() != point2.getX() || point1.getY() != point2.getY());
	// @ensures this.center != null && this.radius > 0;
	public Cercle(Point point1, Point point2) {
		this(point1, point2, Color.BLUE);
	}

/** Construire un cercle à partir de deux point diametralement opposés et de sa couleur.
	 * @param point1 premier point
	 * @param point2 deuxième point
	 * @param color couleur
	 */
	// @require point1 != null && point2 != null;
	// @require	(point1.getX() != point2.getX() || point1.getY() != point2.getY());
	// @ensures this.center != null && this.radius > 0;
	public Cercle(Point point1, Point point2, Color color) {
		assert (point1 != null && point2 != null);
		assert (point1.getX() != point2.getX() || point1.getY() != point2.getY());
		double cx = (point1.getX() + point2.getX()) / 2;
		double cy = (point1.getY() + point2.getY()) / 2;
		this.center = new Point(cx, cy);
		this.radius = center.distance(point1);
		this.color = color;
	}

//Methode de classe
	/** Créer un cercle à partir de son centre et d'un point de sa circonférence.
	 * @param center centre du cercle
	 * @param circonference circonférence du cercle
	 * @return CercleCréé
	 */
	// @require center != null && circonference != null;
	// @require (center.getX() != circonference.getX() ||
	//		center.getY() != circonference.getY());
	public static Cercle creerCercle(Point center, Point circonference) {
		assert (center != null && circonference != null);
		assert (center.getX() != circonference.getX()
				|| center.getY() != circonference.getY());
		return new Cercle(center, center.distance(circonference));
	}

//Getter
	/** Obtenir le centre du cercle.
	 * @return centre du cercle
	 */
	public Point getCentre() {
		return new Point(this.center.getX(), this.center.getY());
	}

	/** Obtenir le rayon du cercle.
	 * @return rayon du cercle
	 */
	public double getRayon() {
		return this.radius;
	}

	/** Obtenir le diamètre du cercle.
	 * @return diamètre du cercle
	 */
	public double getDiametre() {
		return 2 * this.radius;
	}

	/** Obtenir la couleur du cercle.
	 * @return couleur du cercle
	 */
	public Color getCouleur() {
		return this.color;
	}

//Setter
	/** Modifer le rayon du cercle.
	 * @param nradius rayon du cercle
	 */
	// @require (radius > 0);
	public void setRayon(double nradius) {
		assert (nradius > 0);
		this.radius = nradius;
	}

	/** Modifier le diamètre du cercle.
	 * @param diameter diamètre du cercle
	 */
	// @require (diameter > 0);
	public void setDiametre(double diameter) {
		assert (diameter > 0);
		this.radius = diameter / 2;
	}

	/** Modifier la couleur du cercle.
	 * @param ncolor couleur du cercle
	 */
	// @require (ncolor != null);
	public void setCouleur(Color ncolor) {
		assert (ncolor != null);
		this.color = ncolor;
	}

//Methode
	/** Calculer et obtenir le périmètre du cercle.
	 * @return périmètre du cercle
	 */
	public double perimetre() {
		return 2 * PI * this.radius;
	}

	/** Calculer et obtenir l'aire du cercle.
	 * @return aire du cercle
	 */
	public double aire() {
		return PI * this.radius * this.radius;
	}

	/** Translater le cercle.
	 * @param dx translation selon l'axe des abscisse
	 * @param dy translation delon l'axe des ordonnée
	 */
	public void translater(double dx, double dy) {
		this.center.translater(dx, dy);
	}

	/** Savoir si un point se trouve dans le cercle (sens large).
	 * @param point point à tester
	 * @return isIn
	 */
	// @require (point != null);
	public boolean contient(Point point) {
		assert (point != null);
		return (this.center.distance(point) <= this.radius);
	}

	/** Afficher le cercle dans le terminal par défaut.
	 */
	public void afficher() {
		System.out.print("C" + this.radius + "@" + this.center.toString());
	}

	/** Récupérer le point sous forme de caîne de caractères.
	 * @return string
	 */
	public String toString() {
		return ("C" + this.radius + "@" + this.center.toString());
	}
}
