using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CalculHodographe : MonoBehaviour
{
    // Nombre de subdivision dans l'algo de DCJ
    public int NombreDeSubdivision = 3;
    // Liste des points composant la courbe de l'hodographe
    private List<Vector3> ListePoints = new List<Vector3>();
    // Donnees i.e. points cliqués

    public GameObject Donnees;
    public GameObject particle;

    //////////////////////////////////////////////////////////////////////////
    // fonction : DeCasteljauSub                                            //
    // semantique : renvoie la liste des points composant la courbe         //
    //              approximante selon un nombre de subdivision données     //
    // params : - List<float> X : abscisses des point de controle           //
    //          - List<float> Y : odronnees des point de controle           //
    //          - int nombreDeSubdivision : nombre de subdivision           //
    // sortie :                                                             //
    //          - (List<float>, List<float>) : liste des abscisses et liste //
    //            des ordonnées des points composant la courbe              //
    //////////////////////////////////////////////////////////////////////////
    (List<float>, List<float>) DeCasteljauSub(List<float> X, List<float> Y, int nombreDeSubdivision)
    { 
        // Début de l'algorithme
        if (nombreDeSubdivision <= 0){
            return (X, Y);
        }

        else{
            // TODO !!
            int n = X.Count;
            List<float> LcurrX = new List<float>();
            List<float> LcurrY = new List<float>();
            List<float> RcurrX = new List<float>();
            List<float> QcurrX = new List<float>();
            List<float> RcurrY = new List<float>();
            List<float> QcurrY = new List<float>();
            
            // Initialisation de R et Q
            QcurrX.Add(X[0]);
            QcurrY.Add(Y[0]);
            RcurrX.Add(X[n-1]);
            RcurrY.Add(Y[n-1]);

            // Initialisation de Lcurr
            for (int i=0 ; i<n ; i++){
                LcurrX.Add(X[i]);
                LcurrY.Add(Y[i]);
            }

            while(n - 1 > 0){
                for (int i=1 ; i<n ; i++){
                    LcurrX[i-1] = (LcurrX[i-1] + LcurrX[i])/2;
                    LcurrY[i-1] = (LcurrY[i-1] + LcurrY[i])/2;   
                }
                n -= 1;
                QcurrX.Add(LcurrX[0]);
                QcurrY.Add(LcurrY[0]);
                RcurrX.Add(LcurrX[n-1]);
                RcurrY.Add(LcurrY[n-1]);
            }

            // Reverse Rcurr
            RcurrX.Reverse();
            RcurrY.Reverse();

            // Return la concaténation
            List<float> L1X = new List<float>();
            List<float> L1Y = new List<float>();
            List<float> L2X = new List<float>();
            List<float> L2Y = new List<float>();

            (L1X, L1Y) = DeCasteljauSub(QcurrX, QcurrY, nombreDeSubdivision-1);
            (L2X, L2Y) = DeCasteljauSub(RcurrX, RcurrY, nombreDeSubdivision-1);
            L1X.AddRange(L2X);
            L1Y.AddRange(L2Y);
            return (L1X,L1Y);
        }
    }

    //////////////////////////////////////////////////////////////////////////
    // fonction : Hodographe                                                //
    // semantique : renvoie la liste des vecteurs vitesses entre les paires //
    //              consécutives de points de controle                      //
    //              approximante selon un nombre de subdivision données     //
    // params : - List<float> X : abscisses des point de controle           //
    //          - List<float> Y : odronnees des point de controle           //
    //          - float Cx : offset d'affichage en x                        //
    //          - float Cy : offset d'affichage en y                        //
    // sortie :                                                             //
    //          - (List<float>, List<float>) : listes composantes des       //
    //            vecteurs vitesses sous la forme (Xs,Ys)                   //
    //////////////////////////////////////////////////////////////////////////
    (List<float>, List<float>) Hodographe(List<float> X, List<float> Y, float Cx = 1.5f, float Cy = 0.0f)
    {
        List<float> XSortie = new List<float>();
        List<float> YSortie = new List<float>();

        // TODO !!
        // Initialisation de Xsortie et Ysortie
        int n = X.Count;
        for (int i=1 ; i<n ; i++){
            XSortie.Add(X[i] - X[i-1]);
            YSortie.Add(Y[i] - Y[i-1]);
        }

        Debug.Log(XSortie.Count);
        
        return (XSortie, YSortie);
    }

    //////////////////////////////////////////////////////////////////////////
    //////////////////////////// NE PAS TOUCHER //////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    void Start()
    {
        
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return))
        {
            Instantiate(particle, new Vector3(1.5f, -4.0f, 0.0f), Quaternion.identity);
            var ListePointsCliques = GameObject.Find("Donnees").GetComponent<Points>();
            if (ListePointsCliques.X.Count > 0)
            {
                List<float> XSubdivision = new List<float>();
                List<float> YSubdivision = new List<float>();
                List<float> dX = new List<float>();
                List<float> dY = new List<float>();
                
                (dX, dY) = Hodographe(ListePointsCliques.X, ListePointsCliques.Y);

                (XSubdivision, YSubdivision) = DeCasteljauSub(dX, dY, NombreDeSubdivision);
                for (int i = 0; i < XSubdivision.Count; ++i)
                {
                    ListePoints.Add(new Vector3(XSubdivision[i], -4.0f, YSubdivision[i]));
                }
            }

        }
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.blue;
        for (int i = 0; i < ListePoints.Count - 1; ++i)
        {
            Gizmos.DrawLine(ListePoints[i], ListePoints[i + 1]);
        }
    }
}
