import javax.swing.*;
import java.awt.*;
import javax.swing.event.*;
import java.awt.event.*;
import java.util.*; 

public class VueChatFenetre {

	private Chat discussion;	// le modèle du jeu de Morpion

//  Les éléments de la vue (IHM)
//  ----------------------------

	/** Fenêtre principale */
	private JFrame fenetre;
	
	public VueChatFenetre(String name) {
		this(new Chat(), name);
	}

	public VueChatFenetre(Chat discussion, String name) {
		this.discussion = discussion;
		this.fenetre = new JFrame("Chat");
		Container contenu = fenetre.getContentPane();
		
		contenu.setLayout(new BorderLayout());
		
		contenu.add(new VueChat(discussion), BorderLayout.CENTER);
		
		contenu.add(new ControleurChat(discussion, name), BorderLayout.SOUTH);
		
		// Construire le contrôleur (gestion des événements)
		this.fenetre.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		// afficher la fenêtre
		this.fenetre.pack();			// redimmensionner la fenêtre
		this.fenetre.setVisible(true);	// l'afficher
	}
	
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				Chat discussion = new Chat();
				new VueChatFenetre(discussion, "Jacquie");
				new VueChatFenetre(discussion, "Jacquie");
			}
		});
	}
}
