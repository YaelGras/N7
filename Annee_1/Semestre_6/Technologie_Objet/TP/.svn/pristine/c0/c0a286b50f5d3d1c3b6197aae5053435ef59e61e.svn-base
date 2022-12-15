import org.junit.*;
import static org.junit.Assert.*;
import java.awt.Color;

/**
  * L'objectif de cette classe est de vérifier que la classe Cercle a 
  * suivie les contraintes E12, E13, E14 du sujet.
  *
  * @author	Yael Gras
  * @version	$Revision$
  */

public class CercleTest {
	
	public static final double EPSILON = 1e-6;

	// Les points du sujet
	private Point A, B, C;

	
	@Before public void setUp() {
		// Construire les points
		A = new Point(1, 2);
		B = new Point(2, 1);
		C = new Point(4, 1);
	}
	
	/** Test du constructeur a partir de 2 points. 
	 *  Les points sont diamétralement opposés.
	 */
	@Test 
	public void testerE12() {		
		Cercle circle = new Cercle(A, B);
		
		assertEquals(circle.getCentre().getX(), 1.5, EPSILON);
		assertEquals(circle.getCentre().getY(), 1.5, EPSILON);
		assertEquals(circle.getRayon(), Math.sqrt(0.5), EPSILON);
		assertEquals(circle.getCouleur(), Color.blue);
	}

	/** Test du constructeur a partir de 2 points et de sa couleur. 
	 * Les points sont diamétralement opposés.
	 */
	@Test 
	public void testerE13() {
		Cercle circle = new Cercle(A, C, Color.green);
		
		assertEquals(circle.getCentre().getX(), 2.5, EPSILON);
		assertEquals(circle.getCentre().getY(), 1.5, EPSILON);
		assertEquals(circle.getRayon(), Math.sqrt(2.5), EPSILON);
		assertEquals(circle.getCouleur(), Color.green);
	}

	/** Test de la méthode de classe pour créer un cercle. 
	 */
	@Test 
	public void testerE14() {
		Cercle circle = Cercle.creerCercle(B, C);
		
		assertEquals(circle.getCentre().getX(), 2, EPSILON);
		assertEquals(circle.getCentre().getY(), 1, EPSILON);
		assertEquals(circle.getRayon(), 2, EPSILON);
		assertEquals(circle.getCouleur(), Color.blue);
	}
}