
public class EnsembleOrdonneChaine extends EnsembleChaine implements EnsembleOrdonne{

	/**
	 * Cardinal de l'ensemble
	 */
	private int taille;
	private Cellule<Integer> premiereCellule;
	
	public EnsembleOrdonneChaine() {
		this.premiereCellule = null;
		this.taille = 0;
	}
	

	
	public boolean contient(Integer x) {
		if (!this.estVide()) {
			Cellule<Integer> curseur = this.premiereCellule;
			boolean isIn = (curseur.valeur == x);
			while (curseur.suivante != null && curseur.valeur < x) {
				curseur = curseur.suivante;
				isIn = (curseur.valeur == x);
			}
			return isIn;
		}
		return false;
	}

	
	public void ajouter(Integer x) {
		if (!this.estVide()) {
			Cellule<Integer> curseur = this.premiereCellule;
			while(curseur.suivante != null && curseur.valeur < x) {
				if (curseur.suivante.valeur > x) {
					Cellule<Integer> memoire = curseur.suivante;
					curseur.suivante = new Cellule<Integer>(x, memoire);
					this.taille++;
				} 
			}
		} else {
			Cellule<Integer> ajout = new Cellule<Integer>(x, this.premiereCellule);
			premiereCellule = ajout;
			this.taille++;
		}
	}

	
	public void supprimer(Integer x) {
		if (taille != 0) {
			Cellule<Integer> curseur = this.premiereCellule;
			boolean find = (curseur.valeur == x);
			if (find) {
				Cellule<Integer> del = this.premiereCellule;
				this.premiereCellule = del.suivante; //On supprime la première cellule
				taille--;
			}
			
			boolean stop = (curseur.valeur > x);
			while (curseur.suivante != null && !find && !stop) {
				find = (curseur.suivante.valeur == x);
				if (find) {
					curseur.suivante = curseur.suivante.suivante;
					this.taille--;
				} else {
					curseur = curseur.suivante;
					stop = (curseur.valeur > x);
				}
			}
		}		
	}

	@Override
	public int minus() {
		return this.premiereCellule.valeur;
	}
	
	
}

