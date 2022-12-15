package src.batiments;
import src.carte.*;


public abstract class Industrie extends Batiment {

	// private static String img = "../Images/img_industrie.jpg";


    private int maxOuvriers;

    private int nbEmployes;
    private int valorisationEmplois;


    public Industrie(Carte carte, Case coin, int rotation, Parcelle[] parcelles, int[] accesRoutes, int capaciteOuvriers,
    		int attractivite, int valorisationEmplois, int niveau, int tempsConstruction, int coutConstruction) {
    	
		super(coin, rotation, carte, parcelles, accesRoutes, attractivite, niveau, tempsConstruction, coutConstruction);
        
        this.nbEmployes = 0;
        this.maxOuvriers = capaciteOuvriers;
        
        this.valorisationEmplois = valorisationEmplois;
    }

    
    public Industrie(Case coin, Carte carte, Parcelle[] parcelles, int[] accesRoutes, int niveau,
    		int tempsConstruction, int coutConstruction) {

		super(coin, 1, carte, parcelles, accesRoutes, 2, niveau, tempsConstruction, coutConstruction);
		this.valorisationEmplois = 4;
        setIndustrieNiveau(niveau);
	}
	
	
	public void setIndustrieNiveau(int niveau) {
		switch (niveau) {
			case 1 : 
		        this.nbEmployes = 0;
		        this.maxOuvriers = 20;
		        
			case 2 :
				this.nbEmployes = 20;
		        this.maxOuvriers = 50;
		        
			case 3 : 
				this.nbEmployes = 50;
		        this.maxOuvriers = 100;
		        
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


    public int getMaxOuvriers() {
        return this.maxOuvriers;
    }

    public void setMaxOuvriers(int capaciteOuvriers) {
        this.maxOuvriers = capaciteOuvriers;
    }

	public int getNbEmployes() {
		return this.nbEmployes;
	}

	public void setNbEmployes(int nbEmployes) {
		this.nbEmployes = nbEmployes;
	}
    
    public int getValorisationEmplois() {
		return this.valorisationEmplois;
	}

	public void setValorisationEmplois(int valorisationEmplois) {
		this.valorisationEmplois = valorisationEmplois;
	}
}