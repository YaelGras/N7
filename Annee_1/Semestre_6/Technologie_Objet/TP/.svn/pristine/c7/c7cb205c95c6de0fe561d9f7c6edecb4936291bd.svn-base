/** Tester le polymorphisme (principe de substitution) et la liaison
 * dynamique.
 * @author	Xavier Crégut
 * @version	1.5
 */
public class TestPolymorphisme {

	/** Méthode principale */
	public static void main(String[] args) {
		// Créer et afficher un point p1
		Point p1 = new Point(3, 4);	// Est-ce autorisé ? Pourquoi ? Oui car Point est toujours une classe avec un constructur valide
		p1.translater(10,10);		// Quel est le translater exécuté ? C'est le translater de la classe point
		System.out.print("p1 = "); p1.afficher (); System.out.println ();
										// Qu'est ce qui est affiché ? "p1 = (13, 14)"

		// Créer et afficher un point nommé pn1
		PointNomme pn1 = new PointNomme (30, 40, "PN1");
										// Est-ce autorisé ? Pourquoi ? Oui car Point nommé est une classe a un constructeur de ce type
		pn1.translater (10,10);		// Quel est le translater exécuté ? C'est le translater de la classe Point à travers la classe PointNomme car la classe point nomme hérite des méthode de Point
		System.out.print ("pn1 = "); pn1.afficher(); System.out.println ();
										// Qu'est ce qui est affiché ? "pn1 = PN1:(40,50)" 

		// Définir une poignée sur un point
		Point q;

		// Attacher un point à q et l'afficher
		q = p1;				// Est-ce autorisé ? Pourquoi ? oui car q et p1 sont de même type
		System.out.println ("> q = p1;");
		System.out.print ("q = "); q.afficher(); System.out.println ();
										// Qu'est ce qui est affiché ? "q = (13, 14)"

		// Attacher un point nommé à q et l'afficher
		q = pn1;			// Est-ce autorisé ? Pourquoi ? Oui mais q devient un PointNomme
		System.out.println ("> q = pn1;");
		System.out.print ("q = "); q.afficher(); System.out.println ();
										// Qu'est ce qui est affiché ? "q = PN1:(40, 50)"

		// Définir une poignée sur un point nommé
		PointNomme qn;

		// Attacher un point à q et l'afficher
		//qn = p1;			// Est-ce autorisé ? Pourquoi ? Non parce que p1 n'est pas de type PointNommé et il ne contient pas toutes les infos d'un point nomme
		System.out.println ("> qn = p1;");
		//System.out.print ("qn = "); qn.afficher(); System.out.println ();
										// Qu'est ce qui est affiché ? error

		// Attacher un point nommé à qn et l'afficher
		qn = pn1;			// Est-ce autorisé ? Pourquoi ? Oui car ils sont de même type
		System.out.println ("> qn = pn1;");
		System.out.print ("qn = "); qn.afficher(); System.out.println ();
										// Qu'est ce qui est affiché ? "qn = PN1:(40,50)" 

		double d1 = p1.distance (pn1);	// Est-ce autorisé ? Pourquoi ? oui car ils sont tous les deux des sous-type de points utilisant la même fonction
		System.out.println ("distance = " + d1);

		double d2 = pn1.distance (p1);	// Est-ce autorisé ? Pourquoi ?  oui car ils sont tous les deux des sous-type de points utilisant la même focntion
		System.out.println ("distance = " + d2);

		double d3 = pn1.distance (pn1);	// Est-ce autorisé ? Pourquoi ?  oui car ils sont tous les deux du même sous-type
		System.out.println ("distance = " + d3);

		System.out.println ("> qn = q;");
		//qn = q;				// Est-ce autorisé ? Pourquoi ? Non car qn est un objet de la sous-classe de la classe objet de q
		System.out.print ("qn = "); qn.afficher(); System.out.println ();
										// Qu'est ce qui est affiché ? error mais après commentaire de la ligne :  "qn = PN1:(30,40)"

		System.out.println ("> qn = (PointNomme) q;");
		qn = (PointNomme) q;		// Est-ce autorisé ? Pourquoi ? Oui car q est la poignée sur sur PN1 donc un PointNomme
		System.out.print ("qn = "); qn.afficher(); System.out.println ();

		System.out.println ("> qn = (PointNomme) p1;");
		//qn = (PointNomme) p1;		// Est-ce autorisé ? Pourquoi ? Non car qn est un objet de la sous-classe de la classe objet de q
		System.out.print ("qn = "); qn.afficher(); System.out.println ();
	}

}
