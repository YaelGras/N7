import javax.swing.*;
import java.awt.*;
import javax.swing.event.*;
import java.awt.event.*;
import java.util.*;;

@SuppressWarnings("deprecation")
public class VueChat extends JTextArea implements Observer{
	
	public VueChat() {
		this(new Chat());
	}
	
	public VueChat(Chat discussion) {
		super(20, 25);
		discussion.addObserver(this);
		this.setVisible(true);
		this.setEditable(false);
		this.setBackground(Color.WHITE);
	}
	
	@Override
	public void update(Observable arg0, Object arg1) {
		this.append(arg1.toString() + "\n");		
	}
}
