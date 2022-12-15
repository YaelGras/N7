package allumettes;

public class Arbitre {
	private Joueur joueur1;
	private Joueur joueur2;
	private Boolean confiant;


	public Arbitre(Joueur j1, Joueur j2) {
		this.joueur1 = j1;
		this.joueur2 = j2;
		this.confiant = false;
	}

	void setConfiant(boolean confiant) {
		this.confiant = confiant;
	}

	public void arbitrer(Jeu jeu) {
		boolean finPartie;
		Joueur joueur = this.joueur1;
		do {

			finPartie = tourJoueur(joueur, jeu);
			joueur = changeJoueur(joueur);

		} while (!finPartie);
	}

	private boolean tourJoueur(Joueur joueur, Jeu jeu) {

		Boolean finPartie;

		if (this.confiant) {
			finPartie = priseJoueur(joueur, jeu, jeu);
		} else {
			finPartie = priseJoueur(joueur, jeu, new Procuration(jeu));
		}

		if (jeu.getNombreAllumettes() == 0) {
			afficherResultat(joueur);
			finPartie = true;
		}
		return finPartie;
	}

	private boolean priseJoueur(Joueur joueur, Jeu jeu, Jeu procuration) {

		boolean suite = true;
		int prise = 0;
		try {
			do {
				try {
					System.out.print("Allumettes restantes : ");
					System.out.println(jeu.getNombreAllumettes());
					prise = joueur.getPrise(procuration);
					afficherprise(joueur, prise);
					jeu.retirer(prise);
					suite = true;
				} catch (CoupInvalideException e) {
					System.out.print("Impossible ! Nombre invalide : " + e.getCoup());
					System.out.println(" " + e.getProbleme());
					suite = false;
				}
			} while (!suite);

		} catch (OperationInterditeException e) {
			System.out.print("Abandon de la partie car " + joueur.getNom());
			System.out.println(" triche !");
			return true;
		}
		return false;
	}

	private void afficherprise(Joueur joueur, int prise) {
		System.out.print(joueur.getNom() + " prend " + prise + " allumette");
		if (prise <= 1) {
			System.out.println(".");
		} else {
			System.out.println("s.");
		}
	}

	private void afficherResultat(Joueur joueur) {

		System.out.println(joueur.getNom() + " perd !");

		if (joueur.getNom() == this.joueur1.getNom()) {
			System.out.println(this.joueur2.getNom() + " gagne !");
		} else {
			System.out.println(this.joueur1.getNom() + " gagne !");
		}
	}

	private Joueur changeJoueur(Joueur joueur) {
		return (this.joueur1.getNom() == joueur.getNom())
				? this.joueur2 : this.joueur1;
	}
}
