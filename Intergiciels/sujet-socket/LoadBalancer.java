import java.util.Random;
import java.net.*;
import java.io.*;

public class LoadBalancer implements Runnable {
    static String hosts[] = {"localhost", "localhost"};
    static int ports[] = {8081,8082};
    static int nbHosts = 2;
    static Random rand = new Random();
    private Socket s = new Socket();
    public LoadBalancer (Socket s) {this.s = s;}

    public static void main (String[] args) throws IOException {
		ServerSocket s = new ServerSocket(Integer.parseInt(args[0]));
		while (true) { new Thread(new LoadBalancer(s.accept())).start(); }
	}

    public void run () {
        try {
            System.out.println("Received new request");
            int nombre_choisi = rand.nextInt(nbHosts);
            System.out.println(ports[nombre_choisi]);
            Socket Output = new Socket(hosts[nombre_choisi], ports[nombre_choisi]);
            
            /* Récupération des inputStream */
            InputStream inputInputStream = Output.getInputStream();
            OutputStream inputOutputStream = s.getOutputStream();
            InputStream outputInputStream = s.getInputStream();

            // Initialisation du buffer
            byte[] buffer = new byte[1024];
            int bytesRead;
            bytesRead = inputInputStream.read(buffer);
            // Ecriture dans les buffers
            while ((bytesRead = outputInputStream.read(buffer))!=-1){
                inputOutputStream.write(buffer,0,bytesRead);
                System.out.println("end thread");

            //fermeture de tout
            Output.close();
            }
            } catch (IOException ex) {
            ex.printStackTrace();
		}
	}
} 
    
    