import java.awt.Color;

abstract public class Schema {
	private Color couleur;
	
	Schema(Color c){
		this.couleur = c;
	}
	
	


	abstract void afficher();
	
	abstract void translater(double x, double y);
	
	abstract void dessiner(afficheur.Afficheur afficheur);
	
	void setCouleur(Color c) {
		this.couleur = c;
	}
	
	Color getCouleur() {
		return this.couleur;
	}
}
