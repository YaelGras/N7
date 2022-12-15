
public interface EnsembleOrdonne extends Ensemble{
				
		/**	Renvoie le plus petit element de la liste.
		  */
		//@ ensures  contient(x);      // élément supprimé
		int minus();
}


