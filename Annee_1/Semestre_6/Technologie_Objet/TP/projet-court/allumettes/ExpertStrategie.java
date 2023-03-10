package allumettes;

public class ExpertStrategie extends StrategieAbstraite implements Strategie {

	@Override
	public int getPrise(Jeu jeu) {
		if (jeu.getNombreAllumettes() > 1) {
			int prise = (jeu.getNombreAllumettes() - 1) % (jeu.PRISE_MAX + 1);
			return (prise > 0 && prise <= jeu.PRISE_MAX) ? prise : jeu.PRISE_MAX;
		} else {
			return 1;
		}
	}

	@Override
	public String toString() {
		return "expert";
	}
}
