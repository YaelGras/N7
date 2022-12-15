import java.util.ArrayList;
import java.util.List;

public class GroupeAgenda extends AgendaAbstrait implements Agenda{
	private List<Agenda> groupe;
	
	public GroupeAgenda(String nom, Agenda... agendas) {
		super(nom);
		this.groupe = new ArrayList<Agenda>();
		for (int i = 0; i < agendas.length; i++) {
			this.groupe.add(agendas[i]);
		}
	}
	
	public void ajouter(Agenda... agendas) {
		for (int i = 0; i < agendas.length; i++) {
			this.groupe.add(agendas[i]);
		}
	}
	
	public void ajouter(GroupeAgenda agendas) {
		for (Agenda agenda : agendas.groupe) {
			this.ajouter(agenda);
		}
	}
	
	
	public void enregistrer(int creneau, String rdv) throws OccupeException {
		for (Agenda agenda : groupe) {
			try {
				String recup = agenda.getRendezVous(creneau);
				throw new OccupeException(); 
			} catch (LibreException e) {
				// Exception à avoir pour que tous les creneaux soient libres 
			}
		}
		
		for (Agenda agenda : groupe) {
			agenda.enregistrer(creneau, rdv); 
			// Si le nom n'est pas valide une exception est remontée dès la première itération
		}
	}
	
	public String getRendezVous(int creneau) throws LibreException {
		String rdv = "";
		boolean premierAgendaOcc = true;
		
		for (int i = 0; i < groupe.size(); i++) {
			try {
				String recup = groupe.get(i).getRendezVous(creneau);
				
				if (i > 0 && premierAgendaOcc) {
					return null;
				} else if(premierAgendaOcc) {
					rdv = recup;
					premierAgendaOcc = false;
				} else if (rdv != recup) {
					return null; 
				}
			}
			catch (LibreException e) {
				// Si on passe à chaque fois ici 
				// On ne modifie jamais la valeur
				// de premierAgendaOcc 
			}
		}
		
		if (premierAgendaOcc) {
			throw new LibreException();
		}
		
		return rdv;
	}

	@Override
	public boolean annuler(int creneau) {
		boolean annule = false;
		
		for (Agenda agenda : groupe) {
			if(agenda.annuler(creneau)) {
				annule = true;
			}			
		}
		return annule;
	}
		
	
}
