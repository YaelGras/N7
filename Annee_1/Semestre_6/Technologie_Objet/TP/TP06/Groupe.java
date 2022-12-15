import java.awt.Color;
import java.util.ArrayList;
import java.util.List;

public class Groupe extends Schema{
	
	private List<Schema> ensemble;
	
	
	Groupe(){
		super(Color.green);
		this.ensemble = new ArrayList<Schema>();
	}
	
	Groupe(Schema... elements){
		super(Color.green);
		this.ensemble = new ArrayList<Schema>();
		for (int i = 0; i < elements.length; i++) {
			this.ensemble.add(elements[i]);
		}
	}
	
	void addElement(Schema e) {
		this.ensemble.add(e);
	}
	
	@Override
	void afficher() {
		System.out.println("Le groupe contient : ");
		for (Schema schema : this.ensemble) {
			schema.afficher();
			System.out.println();
		}
		System.out.println("Fin du groupe.");
	}
	
	@Override
	void dessiner(afficheur.Afficheur ecran) {
		for (Schema schema : this.ensemble) {
			schema.dessiner(ecran);			
		}
	}

	@Override
	void translater(double x, double y) {
		for (Schema schema : this.ensemble) {
			schema.translater(x, y);
		}
	}
	
}
