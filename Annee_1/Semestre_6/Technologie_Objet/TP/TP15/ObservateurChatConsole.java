import java.util.Observable;
import java.util.Observer;

@SuppressWarnings("deprecation")
public class ObservateurChatConsole implements Observer{
	
	public ObservateurChatConsole (Chat discussion) {
		discussion.addObserver(this);
	}
	
	@Override
	public void update(Observable arg0, Object arg1) {
		System.out.println(arg1.toString());
	}

}
