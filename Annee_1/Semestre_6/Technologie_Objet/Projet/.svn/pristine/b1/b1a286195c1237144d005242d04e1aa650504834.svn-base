package src.batiments;

import src.carte.Carte;
import src.carte.Case;

public abstract class Habitation extends Batiment {

	// private static String img = "../Images/img_habitation.jpg";

	private int nbHabitants;
	private int capacite;

	
	public Habitation(Carte carte, Case coin, int attractivite, int niveau,int nbHabitants,
			int capacite, int rotation, Parcelle[] parcelles, int[] accesRoutes, int tempsConstruction, int coutConstruction) {
		
		super(coin, rotation, carte, parcelles, accesRoutes, attractivite, niveau,
				tempsConstruction, coutConstruction);
		this.nbHabitants = nbHabitants;
		this.capacite = capacite;
	}
	
	
	public Habitation(Carte carte, Parcelle[] parcelles, int[] accesRoutes, int niveau,
			int tempsConstruction, int coutConstruction) {
		
		super(carte.getCase(0, 0), 1, carte, parcelles, accesRoutes, 5, niveau,
				tempsConstruction, coutConstruction);
		this.nbHabitants = 1;
		setHabitationNiveau(niveau);
		}


	public void setHabitationNiveau(int niveau) {
		switch (niveau) {
			case 1 : 
				this.capacite = 20;
			case 2 :
				this.capacite = 100;
			case 3 : 
				this.capacite = 200;
			default :
				throw new NiveauInvalideException("niveau " + niveau + " inconnu", niveau);
		}
		
	}
	

	@Override
	public void ameliorer() {
		switch (this.getNiveau()) {
			case 1:
			case 2:
			case 3:
			default :
				throw new NiveauInvalideException("niveau " + this.getNiveau() + " inconnu", this.getNiveau());
		}
	}

	public int getNbHabitants() {
		return this.nbHabitants;
	}

	public void setNbHabitants(int nbHabitants) {
		this.nbHabitants = nbHabitants;
	}

	public int getCapacite() {
		return this.capacite;
	}

	public void setCapacite(int capacite) {
		this.capacite = capacite;
	}

}
