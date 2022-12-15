import javax.swing.*;
import java.awt.*;
import javax.swing.event.*;
import java.awt.event.*;
import java.util.*;

public class ControleurChat extends JPanel {
	private Chat discussion;
	private JLabel pseudo;
	private JTextArea message;
	private JButton envoie = new JButton("OK");
	
	public ControleurChat(String nom) {
		this(new Chat(), nom);
	}

	public ControleurChat(Chat discussion, String nom) {
		super();
		this.discussion = discussion;
		
		pseudo = new JLabel(nom);
		message = new JTextArea(1, 20);
		
		envoie.addActionListener(new actionEnvoie(nom, this.discussion, this.message));
		
		this.setLayout(new FlowLayout());
		this.add(pseudo);
		this.add(message);
		this.add(envoie);
		this.setVisible(true);
		
	}
	
	static class actionEnvoie implements ActionListener{
		
		private Chat discussion;
		private String nom;
		private JTextArea message;
		
		public actionEnvoie(String nom, Chat chat, JTextArea message) {
			this.discussion = chat;
			this.message = message;
			this.nom = nom;
		}
			
		@Override
		public void actionPerformed(ActionEvent arg0) {
			Message envoyer = new MessageTexte(nom, message.getText());
			this.discussion.ajouter(envoyer);
		}
	}
}
