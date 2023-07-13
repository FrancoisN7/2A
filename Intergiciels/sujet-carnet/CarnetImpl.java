import java.rmi.*;
import java.rmi.server.UnicastRemoteObject;
import java.rmi.registry.*;
import java.util.*;

public class CarnetImpl extends UnicastRemoteObject implements Carnet {	

	private static final long serialVersionUID = 1;
	
	Hashtable<String, RFiche> table = new Hashtable<String, RFiche>();
	int numCarnet;
	Carnet other = null;
	
	public CarnetImpl(int n) throws RemoteException {
		numCarnet = n;
	}

	public void Ajouter(SFiche sf) throws RemoteException {
		try {
			System.out.println("CarnetImpl Ajouter ("+sf.getNom()+","+sf.getEmail()+")");
			// TODO
			RFiche fiche = new RFicheImpl(sf.getNom(), sf.getEmail());
			table.put(getClientHost(), fiche);

		} catch (Exception e) {
			System.out.println("CarnetImpl-Ajouter error: " + e.getMessage());
			e.printStackTrace();
		}
	}
	
	public RFiche Consulter(String n, boolean forward) throws RemoteException {
		forward = true;
		RFiche retour = null;
		Carnet autreCarnet = null;
		try {
		    if (table.get(n)!=null){
				forward = false;
				retour = table.get(n);
			}
			if (forward){
				if (autreCarnet == null){
					autreCarnet = (Carnet) Naming.lookup("//localhost:4000/" + n);
				}
				if (autreCarnet != null) {
					forward = false;
					retour = autreCarnet.Consulter(n, forward);
				}
			}
			return retour;

			
		} catch (Exception e) {
			System.out.println("CarnetImpl-Consulter error: " + e.getMessage());
			e.printStackTrace();
			return null;
		}
	}
	
	
	public static void main(String args[]) {
		String URL;
		Integer i;
		int n;
		// Récupérer le numéro du Carnet depuis args[0] : 1 ou 2
		// TODO
		try{
			i = new Integer(args[0]);
			n = i.intValue();


			System.out.println(" Launching the registry");
			// TODO	
			Registry registry = LocateRegistry.createRegistry(4000);
			// Create an instance of the server object
			Carnet carnet = new CarnetImpl(n);


			System.out.println(" Rebinding");
			// TODO
			// Launching the naming service – rmiregistry – within the JVM
			
			
			// compute the URL of the server
			URL = "//localhost:4000/carnet1";
			Naming.rebind(URL, carnet);
		} 
		catch (Exception ex) {
			System.out.println(" Eh non! Ca ne fonctionne pas"); return;
		}
	}
}

