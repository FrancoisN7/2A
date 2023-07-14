// Time-stamp: <08 déc 2009 08:30 queinnec@enseeiht.fr>

import java.util.concurrent.Semaphore;

public class PhiloSem implements StrategiePhilo {
    /****************************************************************/
    private Semaphore[] fourchettes;
    private Semaphore mutex;
    
    public PhiloSem (int nbPhilosophes) {
        int nbFourchettes = nbPhilosophes;
        // Création sémaphores
        mutex = new Semaphore(1);
        fourchettes = new Semaphore[nbFourchettes];
        for (int i = 0 ; i < nbFourchettes ; i++){
            fourchettes[i] = new Semaphore(1);
        }
    }

    /** Le philosophe no demande les fourchettes.
     *  Précondition : il n'en possède aucune.
     *  Postcondition : quand cette méthode retourne, il possède les deux fourchettes adjacentes à son assiette. */
    public void demanderFourchettes (int no) throws InterruptedException
    {
        int fg = Main.FourchetteGauche(no);
        int fd = Main.FourchetteDroite(no);

        mutex.acquire();
        fourchettes[fg].acquire();
        IHMPhilo.poser(fg, EtatFourchette.AssietteGauche);

        fourchettes[fd].acquire();
        IHMPhilo.poser(fd, EtatFourchette.AssietteGauche);
        mutex.release();
    }

    /** Le philosophe no rend les fourchettes.
     *  Précondition : il possède les deux fourchettes adjacentes à son assiette.
     *  Postcondition : il n'en possède aucune. Les fourchettes peuvent être libres ou réattribuées à un autre philosophe. */
    public void libererFourchettes (int no)
    {
        int fg = Main.FourchetteGauche(no);
        int fd = Main.FourchetteDroite(no);
        
        fourchettes[fg].release();
        IHMPhilo.poser(fg, EtatFourchette.Table);

         fourchettes[fd].release();
        IHMPhilo.poser(fd, EtatFourchette.Table);
    }

    /** Nom de cette stratégie (pour la fenêtre d'affichage). */
    public String nom() {
        return "Implantation Sémaphores, stratégie ???";
    }

}

