#include"../include/graph.cuh"

//Kernel invoked in parallel bellman ford sssp routine

__global__ void sssp_kernel(graph *g)
{
    unsigned int id = blockIdx.x*blockDim.x + threadIdx.x; //id of thread

    //storing corresponding weight, vertices and distance values into thread's local memory 
    int w = g->edgelist[id].f; //weight of edge
    int v1 = g->edgelist[id].s.f; //end 1 of edge
    int v2 = g->edgelist[id].s.s; //end 2 of edge
    int d1 = g->distance[v1]; //distance value of end 1 at that iteration
    int d2 = g->distance[v2]; //distance value of end 2 at that iteration

    __syncthreads(); //to create a barrier and sync all threads
    
    /*Implementing relax routine of bellman ford algorithm
     *AtomicMin is used to resolve read-write conflicts during interleaving
     */
    atomicMin(&(g->distance[v1]),(d2+w));
    atomicMin(&(g->distance[v2]),(d1+w));
    
}