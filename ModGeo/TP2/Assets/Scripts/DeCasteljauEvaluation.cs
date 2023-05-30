using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//////////////////////////////////////////////////////////////////////////
///////////////// Classe qui gère l'évaluation via DCJ ///////////////////
//////////////////////////////////////////////////////////////////////////
public class DeCasteljauEvaluation : MonoBehaviour
{
    // Pas d'échantillonage construire la parametrisation
    public float pas = 1 / 100;
    // Liste des points composant la courbe
    private List<Vector3> ListePoints = new List<Vector3>();
    // Donnees i.e. points cliqués
    public GameObject Donnees;
    // Coordonnees des points composant le polygone de controle
    private List<float> PolygoneControleX = new List<float>();
    private List<float> PolygoneControleY = new List<float>();
    
    //////////////////////////////////////////////////////////////////////////
    // fonction : buildEchantillonnage                                       //
    // semantique : construit un échantillonnage regulier                    //
    // params : aucun                                                      //
    // sortie :                                                             //
    //          - List<float> tToEval : échantillonnage regulier             //
    //////////////////////////////////////////////////////////////////////////
    List<float> buildEchantillonnage()
    {
        List<float> tToEval = new List<float>();
        // TODO !!
        // Construction des échantillons
        float t_curr = 0;
        while (t_curr<1){
            tToEval.Add(t_curr);
            t_curr += pas;
        }
        return tToEval;
    }

   //////////////////////////////////////////////////////////////////////////
    // fonction : DeCasteljau                                               //
    // semantique : renvoie le point approxime via l'aglgorithme de DCJ     //
    //              pour une courbe définie par les points de controle      //
    //              (X,Y) à l'instant t                                     //
    // params : - List<float> X : abscisses des point de controle           //
    //          - List<float> Y : odronnees des point de controle           //
    //          - float t : temps d'approximation                           //
    // sortie :                                                             //
    //          - Vector2 : point atteint au temps t                        //
    //////////////////////////////////////////////////////////////////////////
    Vector2 DeCasteljau(List<float> X, List<float> Y, float t)
    {
        // TODO !!
        Vector2 vcurr = new Vector2(0,0);
        int n = X.Count;
        List<Vector2> Lcurr = new List<Vector2>();
        // Initialisation de Lcurr
        for (int i=0 ; i<n ; i++){
            vcurr[0] = X[i];
            vcurr[1] = Y[i];
            Lcurr.Add(vcurr);
        }

        // Début de l'algorithme
        while(n - 1 > 0){
            for (int i=1 ; i<n ; i++){
                vcurr[0] = (1-t) * Lcurr[i-1][0] + t * Lcurr[i][0];
                vcurr[1] = (1-t) * Lcurr[i-1][1] + t * Lcurr[i][1];
                Lcurr[i-1] = vcurr;
            }
            n -= 1;
        }
        return Lcurr[0];
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

                List<float> T = buildEchantillonnage();
                Vector2 point = new Vector2();
                foreach (float t in T)
                {
                    point = DeCasteljau(ListePointsCliques.X, ListePointsCliques.Y, t);
                    ListePoints.Add(new Vector3(point.x,-4.0f,point.y));
                }
            }
        }
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        for (int i = 0; i < PolygoneControleX.Count - 1; ++i)
        {
            Gizmos.DrawLine(new Vector3(PolygoneControleX[i],-4.0f, PolygoneControleY[i]), new Vector3(PolygoneControleX[i + 1], -4.0f, PolygoneControleY[i + 1]));
        }

        Gizmos.color = Color.blue;
        for (int i = 0; i < ListePoints.Count - 1; ++i)
        {
            Gizmos.DrawLine(ListePoints[i], ListePoints[i + 1]);
        }
    }
}
