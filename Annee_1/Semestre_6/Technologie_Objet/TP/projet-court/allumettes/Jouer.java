package allumettes;

/** Lance une partie des 13 allumettes en fonction des arguments fournis
 * sur la ligne de commande.
 * @author	Xavier Crégut
 * @version	$Revision: 1.5 $
 */
public class Jouer {

	/** Lancer une partie. En argument sont donnés les deux joueurs sous
	 * la forme nom@stratégie.
	 * @param args la description des deux joueurs
	 */
	public static void main(String[] args) {
		try {
			verifierNombreArguments(args);
			Boolean confiant = false;
			Joueur[] joueurs = new Joueur[2];

			if (args[0].toLowerCase().equals("-confiant")) {
				confiant = true;
			}

			ajouterStrategy();

			for (byte i = 0; i < 2; i++) {
				String arg;
				String[] infojoueur;
				if (confiant) {
					arg = args[i + 1];
				} else {
					arg = args[i];
				}
				infojoueur = arg.split("@");

				if (infojoueur.length != 2) {
					throw new ConfigurationException("Erreur d'entrée : "
									+ "\n\t\t Option possible : -confiant"
									+ "\n\t\t Déclaration d'un joueur : nom@strategie");
				}

				joueurs[i] = new Joueur(infojoueur[0],
						getStrategy(infojoueur[1], infojoueur[0]));
			}

			Arbitre arbitre = new Arbitre(joueurs[0], joueurs[1]);
			arbitre.setConfiant(confiant);
			final int nballumette = 13;
			arbitre.arbitrer(new JeuAllumettes(nballumette));

		} catch (ConfigurationException e) {
			System.out.println();
			System.out.println("Erreur : " + e.getMessage());
			afficherUsage();
			System.exit(1);
		}
	}

	private static void verifierNombreArguments(String[] args) {
		final int nbJoueurs = 2;
		if (args.length < nbJoueurs) {
			throw new ConfigurationException("Trop peu d'arguments : "
					+ args.length);
		}
		if (args.length > nbJoueurs + 1) {
			throw new ConfigurationException("Trop d'arguments : "
					+ args.length);
		}
	}

	/** Afficher des indications sur la manière d'exécuter cette classe. */
	public static void afficherUsage() {
		System.out.println("\n" + "Usage :"
				+ "\n\t" + "java allumettes.Jouer joueur1 joueur2"
				+ "\n\t\t" + "joueur est de la forme nom@stratégie"
				+ "\n\t\t" + "strategie = naif | rapide | expert | humain | tricheur"
				+ "\n"
				+ "\n\t" + "Exemple :"
				+ "\n\t" + "	java allumettes.Jouer Xavier@humain "
					   + "Ordinateur@naif"
				+ "\n"
				);
	}

	/**
	 * On ajoute les strategie qui ne prenne pas de parametre dans leur constrtucteur
	 */
	private static void ajouterStrategy() {
		StrategieAbstraite.addStrategy(new RapideStrategie());
		StrategieAbstraite.addStrategy(new NaifStrategie());
		StrategieAbstraite.addStrategy(new ExpertStrategie());
		StrategieAbstraite.addStrategy(new TricheurStrategie());
	}

	private static Strategie getStrategy(String choix, String nom) {
		switch (choix.toLowerCase()) {
			case "humain" :
				StrategieAbstraite.addStrategy(new HumainStrategie(nom));

			default :
				return (Strategie) StrategieAbstraite.getStrategy(choix, nom);
		}
	}
}
