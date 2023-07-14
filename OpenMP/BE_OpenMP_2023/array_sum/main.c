#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <string.h>
#include <math.h>
#include "omp.h"
#include "aux.h"
#define MAX_THREADS 4

double superfast_sum_par(long n, double *x);

int main(int argc, char **argv){
  long n, i;
  long  t_start, t_end;
  double *x, *y, ss, ps;
  
  // Command line arguments
  if ( argc == 2 ) {
    n = atoi(argv[1]);    /* size of x */
  } else {
    printf("Usage:\n\n ./main n\n where n is the size of the array.\n");
    return 1;
  }
  
  x  = (double*) malloc(n*sizeof(double));
  y  = (double*) malloc(n*sizeof(double));

  /* init arrays with random values */
  for(i=0; i<n; i++){
    x[i] = (float)rand()/(float)(RAND_MAX/10.0);
    y[i] = x[i];
    printf("%lf\n", x[i]);
  }
  
  printf("===== Sequential sum =======================================\n");
  t_start = usecs();
  ss = superfast_sum(n, x);
  printf("%lf\n", ss);
  t_end = usecs();
  printf("Execution   time seq : %8.2f msec.\n",((double)t_end-t_start)/1000.0);

  printf("\n===== Parallel   sum =======================================\n");
  t_start = usecs();
  ps = superfast_sum_par(n, y);
  printf("%lf\n", ps);
  t_end = usecs();
  printf("Execution   time par : %8.2f msec.\n",((double)t_end-t_start)/1000.0);

  if(fabs((ss-ps)/ss) < 1e-12){
    printf("The result is correct.\n");
  } else {
    printf("The result is wrong.\n");
  }
  return 0;

}



double superfast_sum_par(long n, double *x){

  double sum;
  int i,j;
  int h = n/MAX_THREADS;
  double x_compart[MAX_THREADS][h];

  //J'ai essayé de scinder le tableau initial en plusieurs sous tableaux 
  //qui doivent être exécutés en même temps puis l'on fait la somme sur 
  //ces sous-tableaux et on somme la somme.

  #pragma omp parallel 
  {
    #pragma omp for private(x_compart)
    for (i = 0; i < h; i++){
      x_compart[omp_get_thread_num()][i] = x[i+omp_get_thread_num()*h];
      printf("%lf\n", x[i+omp_get_thread_num()*h]);
      sum += superfast_sum(n, x_compart[omp_get_thread_num()]);
    }
  }

  return sum;
}
 
