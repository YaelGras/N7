package allumettes;

import java.util.NoSuchElementException;
import java.util.Scanner;

public class HumainStrategie extends StrategieAbstraite implements Strategie {

	private String nom;
	private static Scanner scanner = new Scanner(System.in);

	public HumainStrategie(String nom) {
		this.nom = nom;
	}

	@Override
	public int getPrise(Jeu jeu) {
		boolean reponseValide = false;
		int prise = 0;
		do {
			String choix = "";
			try {
				System.out.print(this.nom + ", combien d'allumettes ? ");
				choix = this.scanner.nextLine();
				prise = Integer.parseInt(choix);
				reponseValide = true;
			} catch (NumberFormatException | NoSuchElementException e) {
				if (choix.contentEquals("triche")) {
					triche(jeu);
				} else {
					System.out.println("Vous devez donner un entier.");
				}
			}
		} while (!reponseValide);
		return prise;
	}

	private void triche(Jeu jeu) {
		try {
			jeu.retirer(1);
		} catch (CoupInvalideException e) {
			System.err.println("Erreur humain tricheur : " + e.getMessage());
		}

		System.out.print("[Une allumette en moins, plus que ");
		System.out.println(jeu.getNombreAllumettes() + ". Chut !]");
	}

	@Override
	public String toString() {
		return "humain";
	}

	@Override
	public String getNom() {
		return this.nom;
	}
}
