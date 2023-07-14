import java.rmi.*;
import java.util.HashMap;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;

public class Server extends UnicastRemoteObject implements Server_itf{
	
	private int nb_objets = 0;
	private HashMap<String, Integer> noms_objets = new HashMap<>();
	private HashMap<Integer, ServerObject> id_objets = new HashMap<>();
	
	public Server() throws RemoteException {
		this.noms_objets = new HashMap<>();
		this.id_objets = new HashMap<>();
	}
	
	@Override
	public int lookup (String nom) throws RemoteException {
		int id;
		if (noms_objets.get(nom)==null) {
			id = -1;
		}
		else {
			id = noms_objets.get(nom);
		}
		return id;
	}

	@Override
	public void register(String name, int id) throws RemoteException {
		noms_objets.put(name, id);
	}

	@Override
	public int create(Object o) throws RemoteException {
		ServerObject so = new ServerObject(ServerObject.Lock.NL,nb_objets, o);
		id_objets.put(nb_objets, so);
		int id = nb_objets;
		nb_objets++;
		return id;
	}

	@Override
	public Object lock_read(int id, Client_itf client) throws RemoteException {
		ServerObject so = id_objets.get(id);
		return so.lock_read(client);
	}

	@Override
	public Object lock_write(int id, Client_itf client) throws RemoteException {
		System.out.println(id);
		System.out.println(noms_objets);
		System.out.println(id_objets);
		ServerObject so = id_objets.get(id);
		ServerObject so1 = id_objets.get( id);
		ServerObject so2 = id_objets.get(1);
		System.out.println(so);
		System.out.println(so1);
		System.out.println(so2);
		return so.lock_write(client);
	}

	/**
	 * La méthode lançant le serveur
	 * @param args inutilisé
	 * @throws UnknownHostException
	 */
	public static void main(String[] args) throws UnknownHostException {
		System.out.println(">>>>>> Server Init. <<<<<<");
		try {
			// On choisit le port et l'url par défaut.
			int port = Registry.REGISTRY_PORT;
			String url = InetAddress.getLocalHost().getHostName();

			// Creates and exports a Registry on the local host that accepts
			// requests on the specified port.
			Registry registry = LocateRegistry.createRegistry(port);
			Server server = new Server();
			String Server_URL = "//" + url + ":" + port + "/Serveur";

			// Définition du lien entre Server_URL et l'objet Remote server.
			//Naming.rebind(Server_URL, server);
			registry.bind("Serveur", server);

		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println(">>>>>> Server Ready <<<<<<");
	}
	
}
