using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

//////////////////////////////////////////////////////////////////////////
///////////////// Classe qui gère la subdivision via DCJ /////////////////
//////////////////////////////////////////////////////////////////////////
public class DeCasteljauSubdivision : MonoBehaviour
{
    // Pas d'échantillonage pour affichage
    public float pas = 1 / 100;
    // Nombre de subdivision dans l'algo de DCJ
    public int NombreDeSubdivision = 3;
    // Liste des points composant la courbe
    private List<Vector3> ListePoints = new List<Vector3>();
    // Donnees i.e. points cliqués
    public GameObject Donnees;
    // Coordonnees des points composant le polygone de controle
    private List<float> PolygoneControleX = new List<float>();
    private List<float> PolygoneControleY = new List<float>();

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
    //////////////////////////// NE PAS TOUCHER //////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    void Start()
    {

    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return))
        {
            var ListePointsCliques = GameObject.Find("Donnees").GetComponent<Points>();
            if (ListePointsCliques.X.Count > 0)
            {
                for (int i = 0; i < ListePointsCliques.X.Count; ++i)
                {
                    PolygoneControleX.Add(ListePointsCliques.X[i]);
                    PolygoneControleY.Add(ListePointsCliques.Y[i]);
                }
                List<float> XSubdivision = new List<float>();
                List<float> YSubdivision = new List<float>();

                (XSubdivision, YSubdivision) = DeCasteljauSub(ListePointsCliques.X, ListePointsCliques.Y, NombreDeSubdivision);
                for (int i = 0; i < XSubdivision.Count; ++i)
                {
                    ListePoints.Add(new Vector3(XSubdivision[i], -4.0f, YSubdivision[i]));
                }
            }

        }
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        for (int i = 0; i < PolygoneControleX.Count - 1; ++i)
        {
            Gizmos.DrawLine(new Vector3(PolygoneControleX[i], -4.0f, PolygoneControleY[i]), new Vector3(PolygoneControleX[i + 1], -4.0f, PolygoneControleY[i + 1]));
        }

        Gizmos.color = Color.blue;
        for (int i = 0; i < ListePoints.Count - 1; ++i)
        {
            Gizmos.DrawLine(ListePoints[i], ListePoints[i + 1]);
        }
    }
}
