import java.io.*;
import java.rmi.RemoteException;
import java.util.Vector;



public class ServerObject implements Serializable, ServerObject_itf {
	public enum Lock{NL, RL, WL};
	private Lock lock;
	private int id_SO;
	private Object obj;
	private Vector<Client_itf> lecteurs = new Vector<>();
	private boolean ecriture;
	private Client_itf ecrivain;
	//private String name;
	
	public ServerObject(Lock lock, int id, Object obj) {
		//this.name = name;
		this.lock = lock;
		this.id_SO = id;
		this.obj = obj;
		this.ecriture = false;
		this.ecrivain = null;
		this.lecteurs = null;
	}
	
	public int getId() {
		return this.id_SO;
	}
	
	// invoked by the client on the shared object
	public Object lock_read(Client_itf client) {
		switch (lock) {
		case NL:
			lecteurs.add(client);
			lock = Lock.RL;
			break;
		case RL:
			lecteurs.add(client);
			lock = Lock.RL;
			break;
		case WL:
			//si le serveur est en mode ecriture, 
			//le serveur doit appeler reduce_lock pour changer le lock en mode lecture et invalider l'ecrivain courant
			try {
				this.obj = ecrivain.reduce_lock(id_SO);
			} catch (RemoteException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			ecriture = false;
			lecteurs.add(client);
			lock = Lock.RL;
			break;
		default :
			break;
			
			
		}
		return obj;
	}


	public Object lock_write(Client_itf client) {
		switch (lock) {
		case NL:
			lock = Lock.WL;	
			ecrivain = client; 
			ecriture = true;
			break;
		case RL:
			//si le serveur est en mode lecture, 
			//on appelle invalidate_reader pour stopper toutes les lectures en cours
			for (Client_itf lecteur : lecteurs) {
				try {
					lecteur.invalidate_reader(id_SO);
				} catch (Exception e) {
				}
			}
			ecrivain = client;
			ecriture = true;
			lock = Lock.WL;
			break;
			
		case WL:
			//si le serveur est en mode ecriture, 
			//on appelle invalidate_writer pour stopper l'ecriture en cours et pouvoir lancer la nouvelle
			try {
				this.obj = ecrivain.invalidate_writer(id_SO);
			} catch (RemoteException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			ecrivain = client;
			lock = Lock.WL;
			break;
		default :
			break;
			
		}
		return obj;
	}

}
