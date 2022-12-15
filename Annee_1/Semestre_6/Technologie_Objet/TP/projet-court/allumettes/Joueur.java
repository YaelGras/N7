package allumettes;

public class Joueur {

	/** Nom du joueur.
	 */
	private String nom;

	/** Strategie du joueur.
	 */
	private Strategie strategie;

	/** Construire un joueur.
	 * @param name
	 * @param strategy
	 */
	public Joueur(String name, Strategie strategy) {
		this.nom = name;
		this.strategie = strategy;
	}

	/**Obtenir le nom du joueur.
	 * @return nom
	 */
	public String getNom() {
		return this.nom;
	}

	/**Obtenir la prise du joueur pour un jeu.
	 * @param jeu
	 * @return prise
	 */
	public int getPrise(Jeu jeu) {
		return strategie.getPrise(jeu);
	}

	/** Obtenir l'objet Strategie du joueur.
	 * @return strategie
	 */
	Strategie getStrategie() {
		return this.strategie;
	}
}
