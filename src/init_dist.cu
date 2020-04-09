#include"../include/graph.cuh"

//Kernel that initializes distance array of graph

__global__ void init_distance_kernel(graph *g, int start)
{
    unsigned int id = blockIdx.x*blockDim.x + threadIdx.x; //id of thread

    //checking if vertex is the source vertex or not, and initializing distance value correspondingly
    if(id == start)
    {
        g->distance[id] = 0;
    }

    else
    {
        g->distance[id] = INT_MAX>>2;
    }

}