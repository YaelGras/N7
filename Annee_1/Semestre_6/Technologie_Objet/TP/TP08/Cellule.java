
public class Cellule<E> {
	
	E valeur;
	Cellule<E> suivante;
	
	Cellule(E value) {
		this.valeur = value;
		this.suivante = null;
	}
	
	Cellule(E value, Cellule<E> next) {
		this.valeur = value;
		this.suivante = next;
	}
	
	
}
