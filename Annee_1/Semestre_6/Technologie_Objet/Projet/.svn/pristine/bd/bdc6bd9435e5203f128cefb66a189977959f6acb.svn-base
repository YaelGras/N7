package src.affichagePartie;

import javax.swing.*;

import java.awt.*;


public class statHabitants extends JPanel {
    private JLabel bonheurIcon, bonhommeIcon;
    private JLabel titre, bonheurValue, nbhabitant;

    public statHabitants() {
        super();
        this.setLayout(null);

        this.bonheurIcon = new JLabel();        
        this.bonhommeIcon = new JLabel();
        this.bonhommeIcon.setIcon(new ImageIcon("src/Images/Icones_Stats/bonhomme.png"));
        this.titre = new JLabel("Habitants");
        this.bonheurValue = new JLabel("100%");
        this.nbhabitant = new JLabel("100k");

        updateBonheur(100);
        updatePopulation(100);
        updatePosition();

        this.add(this.bonheurIcon);
        this.add(this.bonhommeIcon);
        this.add(this.titre);
        this.add(this.bonheurValue);
        this.add(this.nbhabitant);

        this.setVisible(true);
    }

    public void updateBonheur(int value) {
        this.bonheurValue.setText(value + " %");
        if(value > 80) {
            this.bonhommeIcon.setIcon(new ImageIcon("src/Images/Icones_Stats/heureux.png"));
        } else if(value > 60) {
            this.bonhommeIcon.setIcon(new ImageIcon("src/Images/Icones_Stats/content.png"));
        } else if(value > 40) {
            this.bonhommeIcon.setIcon(new ImageIcon("src/Images/Icones_Stats/pascontent.png"));
        } else {
            this.bonhommeIcon.setIcon(new ImageIcon("src/Images/Icones_Stats/triste.png"));
        }
        
    }

    public void updatePopulation(int nb_habitant) {
        this.nbhabitant.setText("" + nb_habitant);
    }

    void updatePosition() {

        this.titre.setBounds(0, 0, this.getWidth(),  1*this.getHeight()/5);

        this.bonhommeIcon.setBounds(0,  1*this.getHeight()/5, this.getWidth()/2, 2*this.getHeight()/5);

        this.nbhabitant.setBounds(0,  3*this.getHeight()/5, this.getWidth()/2, 2*this.getHeight()/5);

        this.bonheurIcon.setBounds(this.getWidth()/2,  1*this.getHeight()/5, this.getWidth()/2, 2*this.getHeight()/5);

        this.bonheurValue.setBounds(this.getWidth()/2,  3*this.getHeight()/5, this.getWidth()/2, 2*this.getHeight()/5);

        //on remets à la bonne taille les images
        /*
        ImageIcon imageIcon = (ImageIcon) this.bonheurIcon.getIcon(); 
        Image image = imageIcon.getImage(); 
        Image newimg = image.getScaledInstance(this.bonheurIcon.getWidth(), this.bonheurIcon.getHeight(),  java.awt.Image.SCALE_SMOOTH);  
        this.bonheurIcon.setIcon(new ImageIcon(newimg));
        
        image = ((ImageIcon) this.bonhommeIcon.getIcon()).getImage(); 
        image = image.getScaledInstance(this.bonhommeIcon.getWidth(), this.bonhommeIcon.getHeight(),  java.awt.Image.SCALE_SMOOTH);  
        this.bonhommeIcon.setIcon(new ImageIcon(image));*/
    }
}
