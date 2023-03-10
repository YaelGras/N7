package allumettes;

public class TricheurStrategie extends StrategieAbstraite implements Strategie {

	@Override
	public int getPrise(Jeu jeu) {
		System.out.println("[Je triche...]");
		do {
			try {
				jeu.retirer(jeu.PRISE_MAX);
			} catch (CoupInvalideException e) {
				System.err.println("tricheur : " + e.getMessage());
			}
		} while (jeu.getNombreAllumettes() > jeu.PRISE_MAX + 1);

		try {
			jeu.retirer(jeu.getNombreAllumettes() - 2);
		} catch (CoupInvalideException e) {
			System.err.println("tricheur : " + e.getMessage());
		}
		System.out.println("[Allumettes restantes : " + jeu.getNombreAllumettes() + "]");
		return 1;
	}

	public String toString() {
		return "tricheur";
	}

	@Override
	public String getNom() {
		return "";
	}
}
