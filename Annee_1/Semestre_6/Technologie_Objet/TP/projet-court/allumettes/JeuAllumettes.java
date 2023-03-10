package allumettes;

public class JeuAllumettes implements Jeu {

	private int nombreAllumettes;

	public JeuAllumettes(int nombreinitial) {
		this.nombreAllumettes = nombreinitial;
	}

	@Override
	public int getNombreAllumettes() {
		return this.nombreAllumettes;
	}

	@Override
	public void retirer(int nbPrises) throws CoupInvalideException {
		if (nbPrises < 1) {
			throw new CoupInvalideException(nbPrises, "(< 1)");
		}
		if (this.nombreAllumettes < nbPrises) {
			throw new CoupInvalideException(nbPrises, "(> "
						+ this.nombreAllumettes + ")");
		}
		if (nbPrises > PRISE_MAX) {
			throw new CoupInvalideException(nbPrises, "(> "
						+ PRISE_MAX + ")");
		}
		this.nombreAllumettes = this.nombreAllumettes - nbPrises;
	}
}
