#include "aux.h"

void tree_dist_par(node_t *nodes, int n){
  int weight;
  int dist;
  int node;
  node_t curr;
  
  #pragma omp parallel private(node,weight)
  #pragma omp single
  for(node=0; node<n; node++){
    #pragma omp task firstprivate(node) depend(in : nodes[node])
    curr = nodes[node];
    #pragma omp task depend(in : curr)
    weight = process(curr);
    #pragma omp task firstprivate(node) depend(in : weight)
    {
    nodes[node].weight = weight;
    nodes[node].dist   = weight;
    }
    
    if(curr.p){
      #pragma omp atomic update
      curr.dist += (curr.p)->dist;
    }
    }
  

}
