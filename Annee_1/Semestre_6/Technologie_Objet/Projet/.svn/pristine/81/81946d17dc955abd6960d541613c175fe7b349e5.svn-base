package src.menus;

import src.affichagePartie.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

class Bouton_Reprendre extends Boutons {

	private JFrame fenetre;
	private Menu menu;
	
	public Bouton_Reprendre(JFrame fenetre, Menu menu) {
		super();
		this.fenetre = fenetre;
		this.menu = menu;

        //this.setText(this.getNom());
		//this.setFont(new Font("Arial", Font.BOLD, 30));
		//this.setForeground(Color.BLACK);
		
		this.setOpaque(false);
		this.setContentAreaFilled(false);
		
		this.addActionListener(this);
		
	}
	
	@Override
	public void executer() {
		this.menu.effacer();
		this.fenetre.getContentPane().add(new bandeStat(this.fenetre));
	}

	@Override
	public String getNom() {
		return "Reprendre";
	}	
}
