import java.util.Observer;

public class Test {
	@SuppressWarnings("deprecation")
	public static void main(String[] args) {
		Chat chat = new Chat();
		ObservateurChatConsole observe = new ObservateurChatConsole(chat);
		Message message = new MessageTexte("ajhgajhg", "Bh");
		chat.ajouter(message);
	}
}
