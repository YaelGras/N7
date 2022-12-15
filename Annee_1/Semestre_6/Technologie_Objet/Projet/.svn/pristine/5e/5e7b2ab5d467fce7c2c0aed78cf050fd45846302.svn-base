package src.menus;


public class Bouton_Retour extends Boutons {

	private Menu menu_avant, menu_courant;
	
	public Bouton_Retour(Menu menu_avant, Menu menu_courant) {
		super();
		this.menu_avant = menu_avant;
		this.menu_courant = menu_courant;
		
		//this.setText(this.getNom());
		
		this.setOpaque(false);
		this.setContentAreaFilled(false);

		
		this.addActionListener(this);
		
		this.setVisible(true);
		
	}
	
	
	@Override
	public void executer() {
		this.menu_courant.effacer();
		this.menu_avant.afficher();		
	}

	@Override
	public String getNom() {
		return "Retour";
	}

}
