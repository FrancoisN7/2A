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
    private List<Vector4> ListePoints = new List<Vector4>();
    // Coordonnees des points composant le polygone de controle
    private List<float> PolygoneControleX = new List<float>();
    private List<float> PolygoneControleY = new List<float>();
    private List<float> PolygoneControleZ = new List<float>();

    //////////////////////////////////////////////////////////////////////////
    // fonction : DeCasteljauSub                                            //
    // semantique : renvoie la liste des points composant la courbe         //
    //              approximante selon un nombre de subdivision données     //
    // params : - List<float> X : abscisses des points de controle           //
    //          - List<float> Y : odronnees des points de controle           //
    //          - List<float> Z : odronnees des points de controle           //
    //          - int nombreDeSubdivision : nombre de subdivision           //
    // sortie :                                                             //
    //          - (List<float>, List<float>) : liste des abscisses et liste //
    //            des ordonnées des points composant la courbe              //
    //////////////////////////////////////////////////////////////////////////
    (List<float>, List<float>, List<float>) DeCasteljauSub(List<float> X, List<float> Y,
                                        List<float> Z, int nombreDeSubdivision)
    {
        // Début de l'algorithme
        if (nombreDeSubdivision <= 0){
            return (X, Y, Z);
        }

        else{
            // TODO !!
            int n = X.Count;
            List<float> LcurrX = new List<float>();
            List<float> LcurrY = new List<float>();
            List<float> LcurrZ = new List<float>();

            List<float> RcurrX = new List<float>();
            List<float> QcurrX = new List<float>();
            List<float> RcurrY = new List<float>();
            List<float> QcurrY = new List<float>();
            List<float> RcurrZ = new List<float>();
            List<float> QcurrZ = new List<float>();
            
            // Initialisation de R et Q
            QcurrX.Add(X[0]);
            QcurrY.Add(Y[0]);
            QcurrZ.Add(Z[0]);

            RcurrX.Add(X[n-1]);
            RcurrY.Add(Y[n-1]);
            RcurrZ.Add(Z[n-1]);

            // Initialisation de Lcurr
            for (int i=0 ; i<n ; i++){
                LcurrX.Add(X[i]);
                LcurrY.Add(Y[i]);
                LcurrZ.Add(Z[i]);
            }

            while(n - 1 > 0){
                for (int i=1 ; i<n ; i++){
                    LcurrX[i-1] = (LcurrX[i-1] + LcurrX[i])/2;
                    LcurrY[i-1] = (LcurrY[i-1] + LcurrY[i])/2; 
                    LcurrZ[i-1] = (LcurrZ[i-1] + LcurrZ[i])/2;  
                }
                n -= 1;
                // Mise à jour des Q
                QcurrX.Add(LcurrX[0]);
                QcurrY.Add(LcurrY[0]);
                QcurrZ.Add(LcurrZ[0]);
                // Mise à jour des R
                RcurrX.Add(LcurrX[n-1]);
                RcurrY.Add(LcurrY[n-1]);
                RcurrZ.Add(LcurrZ[n-1]);
            }

            // Reverse Rcurr
            RcurrX.Reverse();
            RcurrY.Reverse();
            RcurrZ.Reverse();

            // Return la concaténation
            List<float> L1X = new List<float>();
            List<float> L1Y = new List<float>();
            List<float> L1Z = new List<float>();
            List<float> L2X = new List<float>();
            List<float> L2Y = new List<float>();
            List<float> L2Z = new List<float>();

            (L1X, L1Y, L1Z) = DeCasteljauSub(QcurrX, QcurrY, QcurrZ, nombreDeSubdivision-1);
            (L2X, L2Y, L2Z) = DeCasteljauSub(RcurrX, RcurrY, RcurrZ, nombreDeSubdivision-1);
            L1X.AddRange(L2X);
            L1Y.AddRange(L2Y);
            L1Z.AddRange(L2Z);
            return (L1X,L1Y,L1Z);
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
            var ListePointsCrees = GameObject.FindGameObjectsWithTag("Points");
            //if (ListePointsCrees.Count > 0)
            //{
                // Faire un forEach
                foreach(GameObject go in ListePointsCrees)
                {
                    Debug.Log(1);
                    Debug.Log(go.transform.position);
                    Vector3 position = go.transform.position;
                    PolygoneControleX.Add(position.x);
                    PolygoneControleY.Add(position.y);
                    PolygoneControleZ.Add(position.z);
                }
                List<float> XSubdivision = new List<float>();
                List<float> YSubdivision = new List<float>();
                List<float> ZSubdivision = new List<float>();

                (XSubdivision, YSubdivision, ZSubdivision) = DeCasteljauSub(PolygoneControleX, 
                                            PolygoneControleY, PolygoneControleZ, NombreDeSubdivision);

                for (int i = 0; i < XSubdivision.Count; ++i)
                {
                    // Ligne à vérifier !!
                    ListePoints.Add(new Vector3(XSubdivision[i], ZSubdivision[i], YSubdivision[i]));
                }
            }

        //}
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        for (int i = 0; i < PolygoneControleX.Count - 1; ++i)
        {
            Gizmos.DrawLine(new Vector3(PolygoneControleX[i], PolygoneControleY[i], PolygoneControleZ[i]), 
                            new Vector3(PolygoneControleX[i+1], PolygoneControleY[i+1], PolygoneControleZ[i+1]));
        }

        Gizmos.color = Color.blue;
        for (int i = 0; i < ListePoints.Count - 1; ++i)
        {
            Gizmos.DrawLine(ListePoints[i], ListePoints[i + 1]);
        }
    }
}
