package src.menus;

import java.awt.*;
import java.awt.event.*;
import java.io.*;
import javax.imageio.*;
import javax.swing.*;

@SuppressWarnings("serial")
public class MenuParametre extends Menu {
	
	private JFrame fenetre;	
	private Menu menu;
	private Boutons retour, raccourcis;
	private Commande_Volume volume;
	
	public MenuParametre(JFrame fenetre, Menu menu) {
		super();
		this.fenetre = fenetre;
		this.menu = menu;	
		
		this.setBounds(0, 0, this.fenetre.getWidth(), this.fenetre.getHeight());
		this.setLayout(null);
		
		retour = new Bouton_Retour(this.menu, this);
		raccourcis = new Bouton_Racourcis(this.fenetre);
		volume = new Commande_Volume();
		
		this.add(retour);
		this.add(this.raccourcis);
		this.add(this.volume);
		
		
		this.fenetre.getContentPane().add(this);
		this.fenetre.addComponentListener(this);
		this.setVisible(false);

	}
	
	@Override
	public void componentResized(ComponentEvent e) {
		
		this.setBounds(0, 0, this.fenetre.getWidth(), this.fenetre.getHeight()); 
		
		int largeur = 460*this.getWidth()/960;
		int hauteur = 87*this.getHeight()/540;
		int align_gauche = 279*this.getWidth()/960;
		
		this.raccourcis.setBounds(align_gauche, 377*this.getHeight()/540, largeur, hauteur);
		this.volume.setBounds(575*this.getWidth()/960, 107*this.getHeight()/540, 2*largeur/3, 2*hauteur/3);
		this.retour.setBounds(750*this.getWidth()/960, 16*this.getHeight()/540, 
				198*this.getWidth()/960, 38*this.getHeight()/540);    
	}
	
	public void paintComponent(Graphics g)
    {
        //Chargement de l"image de fond
        try {
        	super.paintComponent(g);
            Image imgparam = ImageIO.read(new File("src/Images/Fond_Menu_Parametre.png"));
            g.drawImage(imgparam, 0, 0, this.fenetre.getWidth(), this.fenetre.getHeight(), this.fenetre);
        } catch (IOException e) {
            System.out.println("Erreur image de fond paramètre : " + e.getMessage());
        }
    }
}
