using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CourbesFermees : MonoBehaviour
{
    // Liste des points composant la courbe
    private List<Vector3> ListePoints = new List<Vector3>();
    // Donnees i.e. points cliqués
    public GameObject Donnees;
    // Coordonnees des points composant le polygone de controle
    private List<float> PolygoneControleX = new List<float>();
    private List<float> PolygoneControleY = new List<float>();

    // degres des polynomes par morceaux
    public int degres = 5;
    // nombre d'itération de subdivision
    public int nombreIteration = 5;

    //////////////////////////////////////////////////////////////////////////
    // fonction : subdivise                                                 //
    // semantique : réalise nombreIteration subdivision pour des polys de   //
    //              degres degres                                           //
    // params : - List<float> X : abscisses des point de controle           //
    //          - List<float> Y : odronnees des point de controle           //
    // sortie :                                                             //
    //          - (List<float>, List<float>) : points de la courbe          //
    //////////////////////////////////////////////////////////////////////////
    (List<float>, List<float>) subdivise(List<float> X, List<float> Y) {
        List<float> Xr = new List<float>();
        List<float> Yr = new List<float>();

        List<float> Xres = new List<float>();
        List<float> Yres = new List<float>();
        int n = X.Count;
        for (int k=0 ; k<n ; k++){
            Xres.Add(X[k]);
            Yres.Add(Y[k]);
        }

        float temp_prem_x = X[0];
        float temp_prem_y = Y[0];
        for (int j = 0; j<degres; j++){
            //Duplication
            List<float> Xresint = new List<float>();
            List<float> Yresint = new List<float>();
            for (int k=0 ; k<n ; k++){
                Xresint.Add(Xres[k]);
                Xresint.Add(Xres[k]);
                Yresint.Add(Yres[k]);
                Yresint.Add(Yres[k]);
            }

            n = Xresint.Count;
            Debug.Log(n);
            //Calcul des milieux
            for (int i=1 ; i<n ; i++){
                Xresint[i-1] = (Xresint[i-1] + Xresint[i])/2;
                Yresint[i-1] = (Yresint[i-1] + Yresint[i])/2;
            }
            //Calcul du dernier point
            Debug.Log(n-1);
            Xresint[n-1] = (Xresint[n-1] + temp_prem_x)/2;
            Yresint[n-1] = (Yresint[n-1] + temp_prem_y)/2;
            temp_prem_x = Xresint[0];
            temp_prem_y = Yresint[0];

            for (int k=0 ; k<Xres.Count ; k++){
                Xres.Add(Xres[k]);
                Yres.Add(Yres[k]);
            }

            for (int k=0 ; k<Xres.Count ; k++){
                Xres[k] = Xresint[k];
                Yres[k] = Yresint[k];
            }
        }
        
        return (Xr, Yr);
    }

    //////////////////////////////////////////////////////////////////////////
    //////////////////////////// NE PAS TOUCHER //////////////////////////////
    //////////////////////////////////////////////////////////////////////////

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
                
                List<float> Xres = new List<float>();
                List<float> Yres = new List<float>();

                (Xres, Yres) = subdivise(ListePointsCliques.X,ListePointsCliques.Y);
                for (int i = 0; i < Xres.Count; ++i) {
                    ListePoints.Add(new Vector3(Xres[i],-4.0f,Yres[i]));
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
        if (PolygoneControleX.Count > 0 ) {
            Gizmos.DrawLine(new Vector3(PolygoneControleX[PolygoneControleX.Count - 1],-4.0f, PolygoneControleY[PolygoneControleY.Count - 1]), new Vector3(PolygoneControleX[0], -4.0f, PolygoneControleY[0]));
        }

        Gizmos.color = Color.blue;
        for (int i = 0; i < ListePoints.Count - 1; ++i)
        {
            Gizmos.DrawLine(ListePoints[i], ListePoints[i + 1]);
        }
        if (ListePoints.Count > 0 ) {
            Gizmos.DrawLine(ListePoints[ListePoints.Count - 1], ListePoints[0]);
        }
    }
}
