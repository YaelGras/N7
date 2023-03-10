package allumettes;

public class Procuration implements Jeu {

	private Jeu jeu;

	public Procuration(Jeu jeu) {
		this.jeu = jeu;
	}

	@Override
	public int getNombreAllumettes() {
		return this.jeu.getNombreAllumettes();
	}

	@Override
	public void retirer(int nbPrises) throws CoupInvalideException {
		throw new OperationInterditeException();
	}
}
