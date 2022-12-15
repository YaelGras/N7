package editeur.commande;

import editeur.Ligne;
import menu.Commande;
import menu.Menu;

public class CommandeOuvrirSousMenu implements Commande{
	
	Menu sousmenu;
	Ligne ligne;
	public CommandeOuvrirSousMenu(Menu ssmenu, Ligne l) {
		this.sousmenu = ssmenu;
		this.ligne = l;
	}
	

	public void executer() {
		System.out.println();
		this.ligne.afficher();
		System.out.println();

		this.sousmenu.afficher();
		this.sousmenu.selectionner();
		this.sousmenu.valider();
	}
	
	public void ajouter(String texte, Commande cmd) {
		this.sousmenu.ajouter(texte, cmd);
	}

	@Override
	public boolean estExecutable() {
		return true;
	}
}
