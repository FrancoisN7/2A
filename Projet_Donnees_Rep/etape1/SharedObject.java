import java.io.*;


public class SharedObject implements Serializable, SharedObject_itf {
	public enum Lock{NL, RLT, WLT, RLC, WLC,RLT_WLC};
	private Lock lock;
	private int id;
	public Object obj;
	
	public SharedObject(Lock lock, int id, Object obj) {
		this.lock = lock;
		this.id = id;
		this.obj = obj;
	}
	
	public int getId() {
		return this.id;
	}
	
	// invoked by the user program on the client node
	public void lock_read() {
		switch (lock) {
		case NL:
			obj = Client.lock_read(id);
			lock = Lock.RLT;
			break; 
		case RLC:
			obj = Client.lock_read(id);
			lock = Lock.RLT;
			break;
		case WLC:
			lock = Lock.RLT_WLC;
			break;
		default:
			break;	
			
		}
		
	}

	// invoked by the user program on the client node
	public void lock_write() {
		switch (lock) {
		case NL:
			obj = Client.lock_write(id);
			lock = Lock.WLT;
			break;
		case RLT:
			throw new Error("Action illegale");
			
		case RLC:
			obj = Client.lock_write(id);
			lock = Lock.WLT;
			break;
		case WLC:
			obj = Client.lock_write(id);
			lock = Lock.WLT;
			
			break;
		default:
			break;
			
			
		}
	}

	// invoked by the user program on the client node
	public synchronized void unlock() {
		switch (lock) {
		case RLT:
			lock = Lock.RLC;
			break;
		case WLT:
			lock = Lock.WLC;
			break;

		case RLT_WLC:
			lock = Lock.WLC;
			break;
		default:
			break;
			
		}
	}


	// callback invoked remotely by the server
	public synchronized Object reduce_lock() {
		switch (lock) {

		case WLT:
			lock = Lock.RLC;
			break;
		case WLC:
			lock = Lock.RLC;
			break;
		case RLT_WLC:
			lock = Lock.RLT;
			break;
		default:
			break;
			
		}
		return obj;
		
	}

	// callback invoked remotely by the server
	public synchronized void invalidate_reader() {
		switch (lock) {

		case RLT:
			lock = Lock.NL;
			break;
		case RLC:
			lock = Lock.NL;
			break;
		default:
			break;
			
			
		}
		
	}

	public synchronized Object invalidate_writer() {
		switch (lock) {
		case RLC:
			lock = Lock.NL;
			break;
		case WLC:
			lock = Lock.NL;
			break;
		case RLT_WLC:
			lock = Lock.NL;
			break;
		default: 
			break;
			
		}
		return obj;
	}
}
