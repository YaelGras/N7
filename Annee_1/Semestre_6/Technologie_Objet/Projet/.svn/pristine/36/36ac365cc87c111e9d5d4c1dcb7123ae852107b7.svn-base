package src.menus;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;

public abstract class Boutons extends JButton implements ActionListener {
	/**
	 * Une commande comprends une méthode executer 
	 * pour qu'un menu puisse l'executer si
	 * elle est sélectionnée par l'utilisateur.
	 * 
	 * L'affichage des différentes commandes est 
	 * géré directement par le menu qui utilise la 
	 * commande
	 */
	
	public abstract void executer();
	
	/**
	 * Obtenir le nom de la commande
	 * @return nom
	 */
	public abstract String getNom();
	
	@Override
	public void actionPerformed(ActionEvent arg0) {
		this.executer();
	}
}
