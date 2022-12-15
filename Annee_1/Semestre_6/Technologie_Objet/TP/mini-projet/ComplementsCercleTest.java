import org.junit.*;
import static org.junit.Assert.*;
import java.awt.Color;

/**
  * L'objectif de cette classe est de compléter les tests
  * déjà fournis pour vérifier des cas extrèmes.
  *
  * @author	Yael Gras
  * @version	$Revision$
  */

public class ComplementsCercleTest {
	
	public static final double EPSILON = 1e-15;
	
	/** Test de la création du cercle sur un tout petit rayon.
	 */
	@Test 
	public void testerPetitRayon() {
		Point centre = new Point(1, -100);
		Cercle circle = new Cercle(centre, EPSILON);
		
		assertEquals(circle.getCentre().getX(), 1, EPSILON);
		assertEquals(circle.getCentre().getY(), -100, EPSILON);
		assertEquals(circle.getRayon(), EPSILON, EPSILON);
		assertEquals(circle.getCouleur(), Color.blue);
	}

	/** Test du setRayon sur un tout petit rayon.
	 */
	@Test 
	public void testerSetPetitRayon() {
		Point centre = new Point(1, -100);
		Cercle circle = new Cercle(centre, 100);
		
		circle.setRayon(EPSILON);
		
		assertEquals(circle.getCentre().getX(), 1, EPSILON);
		assertEquals(circle.getCentre().getY(), -100, EPSILON);
		assertEquals(circle.getRayon(), EPSILON, EPSILON);
		assertEquals(circle.getCouleur(), Color.blue);
	}
	
	/** Test du setDiametre sur un tout petit diamètre.
	 */
	@Test 
	public void testerSetPetitDiametre() {
		Point centre = new Point(1, -100);
		Cercle circle = new Cercle(centre, 100);
		
		circle.setDiametre(EPSILON);
		
		assertEquals(circle.getCentre().getX(), 1, EPSILON);
		assertEquals(circle.getCentre().getY(), -100, EPSILON);
		assertEquals(circle.getDiametre(), EPSILON, EPSILON);
		assertEquals(circle.getCouleur(), Color.blue);
	}
}