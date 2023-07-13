
import java.rmi.*;
import java.rmi.server.UnicastRemoteObject;

// La classe RFicheImpl est remote
public class RFicheImpl extends UnicastRemoteObject implements RFiche {
	
	private static final long serialVersionUID = 1;

	String nom, email;
	
	public RFicheImpl (String n, String e) throws RemoteException {
		System.out.println("RFicheImpl: new: "+n+" "+e);
		// TODO
		nom = n; 
		email = e;
	}

	public String getNom () throws RemoteException {
		System.out.println("RFicheImpl: getNom: ");
		// TODO
		return nom;
	}
	public String getEmail () throws RemoteException {
		System.out.println("RFicheImpl: getEmail: ");
		// TODO
		return email;
	}
}
