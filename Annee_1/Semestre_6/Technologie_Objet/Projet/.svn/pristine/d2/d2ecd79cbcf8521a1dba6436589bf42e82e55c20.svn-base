package src;

import java.awt.*;
import java.io.*;
import javax.swing.ImageIcon;
import javax.swing.JPanel;

import src.carte.Case;

public abstract class Structure {

	private Image image;
	private Case[] listeCasesOccupees;
	private String nomStructure;
	
	public final int longueurCase = 10; // ???

	public Structure() {
		setNomStructure();
		String chemin = "src/Images/" + nomStructure + ".png";
		ImageIcon icon = new ImageIcon(chemin);
		setImage(icon);
	}

	public void afficher(Graphics g) {
		Case coin = this.getCoin();
		g.drawImage(this.image, coin.getX()*longueurCase, coin.getY()*longueurCase, null);
	}

	public void setImage(ImageIcon icon) {
		this.image = icon.getImage();
	}

	// getters
	
	public Image getImage() {
		return this.image;
	}

	public void setNomStructure() {
		this.nomStructure = this.getClass().getSimpleName();
	}

	public abstract Case[] getCases();

	public abstract Case getCoin();

	public abstract void setCoin(Case coin);
	
}
