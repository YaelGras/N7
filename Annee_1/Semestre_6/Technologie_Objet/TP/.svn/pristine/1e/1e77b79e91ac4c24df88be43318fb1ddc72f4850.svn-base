package allumettes;

import static org.junit.Assert.assertEquals;
import org.junit.Test;
import org.junit.Before;

public class TestRapideStrategie {

	private Strategie strategie;
	private Jeu jeu;
	
	@Before
	public void setup() {
		this.strategie = new RapideStrategie();
	}
	
	@Test
	public void testGetStrategy() {
		assertEquals("La strategie doit être rapide en toString",
				"rapide", this.strategie.toString());
	}

	@Test
	public void testGetPrise_supPriseMax() {
		jeu = new JeuAllumettes(13);
		assertEquals("La strategie ne renvoie pas le bon nombre à prendre", 
				3, this.strategie.getPrise(jeu));

		jeu = new JeuAllumettes(Jeu.PRISE_MAX+1);
		assertEquals("La strategie ne renvoie pas le bon nombre à prendre",
				3, this.strategie.getPrise(jeu));
	}
	
	@Test
	public void testGetPrise_infPriseMax() {
		jeu = new JeuAllumettes(2);
		assertEquals("La strategie ne renvoie pas le bon nombre à prendre",
				2, this.strategie.getPrise(jeu));

		jeu = new JeuAllumettes(1);
		assertEquals("La strategie ne renvoie pas le bon nombre à prendre",
				1, this.strategie.getPrise(jeu));
	}
}
