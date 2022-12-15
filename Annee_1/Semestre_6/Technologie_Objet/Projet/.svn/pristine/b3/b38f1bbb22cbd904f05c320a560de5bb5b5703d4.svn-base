package src.menus;

import javax.swing.*;

import src.affichagePartie.*;

public class Bouton_Pause extends Boutons {

	private JFrame fenetre;
	private Menu menu;
    private bandeStat stat;
	public Bouton_Pause(JFrame fenetre, bandeStat stat) {
		super();
		this.fenetre = fenetre;
        this.menu = new MenuPause(this.fenetre);
        //this.setText(this.getNom());
		//this.setFont(new Font("Arial", Font.BOLD, 30));
		//this.setForeground(Color.BLACK);
		
		this.setOpaque(false);
		this.setContentAreaFilled(false);
		
		this.addActionListener(this);
		
	}
	
	@Override
	public void executer() {
		this.setVisible(false);
		this.menu.afficher();
		stat.pause();
	}

	@Override
	public String getNom() {
		return "Reprendre";
	}	
}
