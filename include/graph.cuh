#ifndef __GRAPH__HEADER__CUDA__
#define __GRAPH__HEADER__CUDA__

#include<cuda.h>
#include"graph.h"

//function prototypes for kernels
__global__ void init_distance_kernel(graph *g, int start);

__global__ void sssp_kernel(graph *g);

#endif


