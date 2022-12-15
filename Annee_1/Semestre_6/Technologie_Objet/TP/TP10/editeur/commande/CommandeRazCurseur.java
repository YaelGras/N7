package editeur.commande;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import editeur.Ligne;

public class CommandeRazCurseur 
	extends CommandeLigne implements KeyListener
{

	/** Initialiser la ligne sur laquelle travaille
	 * cette commande.
	 * @param l la ligne
	 */
	//@ requires l != null;	// la ligne doit être définie
	public CommandeRazCurseur(Ligne l) {
		super(l);
	}
	
	public void executer() {
		ligne.raz();
	}
	
	public boolean estExecutable() {
		return ligne.getLongueur() > 0;
	}

	@Override
	public void keyPressed(KeyEvent arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void keyReleased(KeyEvent arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void keyTyped(KeyEvent e) {
		if(e.getKeyCode() == KeyEvent.VK_0 && this.estExecutable()) {
			this.executer();
		}
	}

}
