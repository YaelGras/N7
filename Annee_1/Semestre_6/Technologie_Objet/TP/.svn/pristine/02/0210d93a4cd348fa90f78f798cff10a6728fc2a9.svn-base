package allumettes;


public class RapideStrategie extends StrategieAbstraite implements Strategie {

	@Override
	public int getPrise(Jeu jeu) {
		int prise = jeu.PRISE_MAX;
		if (jeu.getNombreAllumettes() < prise) {
			prise = jeu.getNombreAllumettes();
		}
		return prise;
	}

	@Override
	public String toString() {
		return "rapide";
	}
}
