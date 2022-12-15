package allumettes;

import java.util.ArrayList;
import java.util.List;

public abstract class StrategieAbstraite {

	private static List<StrategieAbstraite> strategie
		= new ArrayList<StrategieAbstraite>();

	public abstract String toString();

	public String getNom() {
		return "";
	}

	public static StrategieAbstraite getStrategy(String nomStrategy, String nomJoueur) {
		for (StrategieAbstraite strat : strategie) {
			if (strat.toString().equalsIgnoreCase(nomStrategy)) {
				if (!strat.getNom().contentEquals("")) {
					if (strat.getNom().equalsIgnoreCase(nomJoueur)) {
						return strat;
					}
				} else {
					return strat;
				}
			}
		}

		throw new ConfigurationException("Strategie inconnue");
	}

	public static void addStrategy(StrategieAbstraite strategieAdd) {
		StrategieAbstraite.strategie.add(strategieAdd);
	}
}

