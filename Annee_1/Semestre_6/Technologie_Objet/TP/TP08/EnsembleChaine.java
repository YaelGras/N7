
public class EnsembleChaine<E> implements Ensemble<E>{
	
	/**
	 * Cardinal de l'ensemble
	 */
	private int taille;
	private Cellule<E> premiereCellule;
	
	public EnsembleChaine() {
		this.premiereCellule = null;
		this.taille = 0;
	}
	
	@Override
	public int cardinal() {
		return this.taille;
	}

	@Override
	public boolean estVide() {
		return (taille == 0);
	}

	@Override
	public boolean contient(E x) {
		if (!this.estVide()) {
			Cellule<E> curseur = this.premiereCellule;
			boolean isIn = (curseur.valeur == x);
			while (curseur.suivante != null && !isIn) {
				curseur = curseur.suivante;
				isIn = (curseur.valeur == x);
			}
			return isIn;
		}
		return false;
	}

	@Override
	public void ajouter(E x) {
		if (!this.contient(x)) {
		Cellule<E> ajout = new Cellule<E>(x, this.premiereCellule);
		premiereCellule = ajout;
		this.taille++;
		}
	}

	@Override
	public void supprimer(E x) {
		if (taille != 0) {
			Cellule<E> curseur = this.premiereCellule;
			boolean stop = (curseur.valeur == x);
			if (stop) {
				Cellule<E> del = this.premiereCellule;
				this.premiereCellule = del.suivante; //On supprime la première cellule
				taille--;
			}
			
			while (curseur.suivante != null && !stop) {
				stop = (curseur.suivante.valeur == x);
				if (stop) {
					curseur.suivante = curseur.suivante.suivante;
					this.taille--;
				} else {
					curseur = curseur.suivante;
				}
			}
		}		
	}
}
