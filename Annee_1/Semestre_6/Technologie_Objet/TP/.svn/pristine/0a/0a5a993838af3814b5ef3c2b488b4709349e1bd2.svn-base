import javax.swing.*;
import java.awt.*;
import javax.swing.event.*;
import java.awt.event.*;
import java.util.*;
import javax.swing.JOptionPane;;

/** Programmation d'un jeu de Morpion avec une interface graphique Swing.
  *
  * REMARQUE : Dans cette solution, le patron MVC n'a pas été appliqué !
  * On a un modèle (?), une vue et un contrôleur qui sont fortement liés.
  *
  * @author	Xavier Crégut
  * @version	$Revision: 1.4 $
  */

public class MorpionSwing {

	// les images à utiliser en fonction de l'état du jeu.
	private static final Map<ModeleMorpion.Etat, ImageIcon> images
		= new HashMap<ModeleMorpion.Etat, ImageIcon>();
	
	static {
		images.put(ModeleMorpion.Etat.VIDE, new ImageIcon("blanc.jpg"));
		images.put(ModeleMorpion.Etat.CROIX, new ImageIcon("croix.jpg"));
		images.put(ModeleMorpion.Etat.ROND, new ImageIcon("rond.jpg"));
	}

// Choix de réalisation :
// ----------------------
//
//  Les attributs correspondant à la structure fixe de l'IHM sont définis
//	« final static » pour montrer que leur valeur ne pourra pas changer au
//	cours de l'exécution.  Ils sont donc initialisés sans attendre
//  l'exécution du constructeur !

	private ModeleMorpion modele;	// le modèle du jeu de Morpion

//  Les éléments de la vue (IHM)
//  ----------------------------

	/** Fenêtre principale */
	private JFrame fenetre;

	/** Bouton pour quitter */
	private final JButton boutonQuitter = new JButton("Q");

	/** Bouton pour commencer une nouvelle partie */
	private final JButton boutonNouvellePartie = new JButton("N");

	/** Cases du jeu */
	private final JLabel[][] cases = new JLabel[3][3];

	/** Zone qui indique le joueur qui doit jouer */
	private final JLabel joueur = new JLabel();


// Le constructeur
// ---------------

	/** Construire le jeu de morpion */
	public MorpionSwing() {
		this(new ModeleMorpionSimple());
	}

	/** Construire le jeu de morpion */
	public MorpionSwing(ModeleMorpion modele) {
		// Initialiser le modèle
		this.modele = modele;

		// Créer les cases du Morpion
		for (int i = 0; i < this.cases.length; i++) {
			for (int j = 0; j < this.cases[i].length; j++) {
				this.cases[i][j] = new JLabel();
			}
		}

		// Initialiser le jeu
		this.recommencer();

		
		// Construire la vue (présentation)
		//	Définir la fenêtre principale
		this.fenetre = new JFrame("Morpion");
		this.fenetre.setLocation(100, 200);
		
		// Ajout des différents éléments
		Container contenu = this.fenetre.getContentPane();
		
		contenu.setLayout(new GridLayout(4,3));
		
		for (int i = 0; i < this.cases.length; i++) {
			for (int j = 0; j < this.cases[i].length; j++) {
				contenu.add(this.cases[i][j]);
				this.cases[i][j].addMouseListener(new actionCocher(this, i, j));
			}
		}
		
		contenu.add(this.boutonNouvellePartie);
		
		contenu.add(this.joueur);	
		
		contenu.add(this.boutonQuitter);
		
		
		JMenuBar menu = new JMenuBar();
		JMenu jeu = new JMenu("Jeu");
		JMenuItem newGame = new JMenuItem("Nouvelle Partie");
		JMenuItem quit = new JMenuItem("Quitter");
		
		newGame.addActionListener(new actionRecommencer(this));
		
		quit.addActionListener(new actionQuitter(this));
		
		jeu.add(newGame);
		jeu.add(quit);
		
		menu.add(jeu);
		
		fenetre.setJMenuBar(menu);
		
	
		// Les boutons réagissent
		this.boutonNouvellePartie.addActionListener(new actionRecommencer(this));
		
		this.boutonQuitter.addActionListener(new actionQuitter(this));
		
		
		// Construire le contrôleur (gestion des événements)
		this.fenetre.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		// afficher la fenêtre
		this.fenetre.pack();			// redimmensionner la fenêtre
		this.fenetre.setVisible(true);	// l'afficher
	}

// Quelques réactions aux interactions de l'utilisateur
// ----------------------------------------------------

	/** Recommencer une nouvelle partie. */
	public void recommencer() {
		this.modele.recommencer();

		// Vider les cases
		for (int i = 0; i < this.cases.length; i++) {
			for (int j = 0; j < this.cases[i].length; j++) {
				this.cases[i][j].setIcon(images.get(this.modele.getValeur(i, j)));
			}
		}

		// Mettre à jour le joueur
		joueur.setIcon(images.get(modele.getJoueur()));
	}

// La méthode principale
// ---------------------

	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				new MorpionSwing();
			}
		});
	}
	
	static class actionCocher implements MouseListener{

		private int x;
		private int y;
		private MorpionSwing vue;
		
		public actionCocher(MorpionSwing vue, int x, int y) {
			this.x = x;
			this.y = y;
			this.vue = vue;
		}
		
		@Override
		public void mouseClicked(MouseEvent arg0) {
			// TODO Auto-generated method stub
			
		}
	
		@Override
		public void mouseEntered(MouseEvent arg0) {
			// TODO Auto-generated method stub
			
		}
	
		@Override
		public void mouseExited(MouseEvent arg0) {
			// TODO Auto-generated method stub
			
		}
	
		@Override
		public void mousePressed(MouseEvent arg0) {
			try {
				vue.modele.cocher(this.x, this.y);
				vue.cases[x][y].setIcon(MorpionSwing.images.get(vue.modele.getValeur(x, y)));
				if(vue.modele.estTerminee()) {
					if(vue.modele.estGagnee()) {
						JOptionPane.showMessageDialog(vue.fenetre.getContentPane(), 
								"Victoire de " + vue.modele.getJoueur().toString());
					} else {
						JOptionPane.showMessageDialog(vue.fenetre.getContentPane(), 
								"Partie nulle");
					}					
				} else {
					vue.joueur.setIcon(images.get(vue.modele.getJoueur()));
				}
			} catch (CaseOccupeeException e) {
				System.out.println("Case déjà cochée : (" + this.x + ", " + this.y + ')');
			}
		}
	
		@Override
		public void mouseReleased(MouseEvent arg0) {
			// TODO Auto-generated method stub
			
		}
		
	}
	
	static class actionRecommencer implements ActionListener{
		private MorpionSwing vue;
		
		public actionRecommencer(MorpionSwing vue) {
			this.vue = vue;
		}
		
		@Override
		public void actionPerformed(ActionEvent arg0) {
			vue.recommencer();
		}
	}
	
	static class actionQuitter implements ActionListener{
		private MorpionSwing vue;
		
		public actionQuitter(MorpionSwing vue) {
			this.vue = vue;
		}
		
		@Override
		public void actionPerformed(ActionEvent arg0) {
			vue.fenetre.dispose();
		}
	}

}