import java.rmi.*;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.net.InetAddress;

import java.rmi.registry.*;
import java.net.*;

public class Client extends UnicastRemoteObject implements Client_itf {
	
	private static String serverName = "Serveur";
	private static Registry registry;
	private static Server_itf server;
	private static Client_itf client;
	private static int nb_objets_c = 0;
	private static HashMap<SharedObject, Integer> id_objets_c = new HashMap<>();
	private static HashMap<Integer, SharedObject> objets_id = new HashMap<>();
	
	public Client() throws RemoteException {
		super();
	}


///////////////////////////////////////////////////
//         Interface to be used by applications
///////////////////////////////////////////////////

	// initialization of the client layer
	public static void init() {
		try {
			int port = registry.REGISTRY_PORT;
			System.out.println(InetAddress.getLocalHost().getHostName());
			server = (Server_itf) Naming.lookup("//" + InetAddress.getLocalHost().getHostName()
					+ ":" + port + "/" + serverName);
			client = new Client();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("1");
		}
			
		
	}
	
	// lookup in the name server
	public static SharedObject lookup(String name) {
		try {
			System.out.println("oh");
			int id = server.lookup(name);
			System.out.println("L'id est :");
			System.out.println(id);
			if (id == -1) {
				return null;
			}
			return objets_id.get(id);

		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}		
	
	// binding in the name server
	public static void register(String name, SharedObject_itf so) {
		//so = lookup(name);
		try {
			server.register(name, id_objets_c.get(so));
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	// creation of a shared object
	public static SharedObject create(Object o) {
		//Cr�ation du ServerObject
		int id;
		try {
			id = server.create(o);
			//Cr�ation du SharedObject
			SharedObject obj = new SharedObject(SharedObject.Lock.NL, id, o);

			id_objets_c.put(obj,id);
			objets_id.put(id, obj);
			nb_objets_c++;
			return obj;
			
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
/////////////////////////////////////////////////////////////
//    Interface to be used by the consistency protocol
////////////////////////////////////////////////////////////

	// request a read lock from the server
	public static Object lock_read(int id) {
		try {
			Object obj = server.lock_read(id, client);
			return obj;
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	// request a write lock from the server
	public static Object lock_write (int id) {
		try {
			System.out.println("t");
			System.out.println("Serveur" + server);
			Object obj = server.lock_write(id, client);
			return obj;
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	// receive a lock reduction request from the server
	public Object reduce_lock(int id) throws java.rmi.RemoteException {
		return objets_id.get(id).reduce_lock();
	}


	// receive a reader invalidation request from the server
	public void invalidate_reader(int id) throws java.rmi.RemoteException {
		objets_id.get(id).invalidate_reader();
	}


	// receive a writer invalidation request from the server
	public Object invalidate_writer(int id) throws java.rmi.RemoteException {
		return objets_id.get(id).invalidate_writer();
	}
}
