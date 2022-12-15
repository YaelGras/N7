package allumettes;

import java.util.Random;

public class NaifStrategie extends StrategieAbstraite implements Strategie {

	private Random rand;

	public NaifStrategie() {
		this.rand = new Random();
	}

	@Override
	public int getPrise(Jeu jeu) {
		return  this.rand.nextInt(jeu.PRISE_MAX) + 1;
	}

	@Override
	public String toString() {
		return "naif";
	}
}
