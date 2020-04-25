#include"../include/graph.cuh"

//Kernel invoked in parallel bellman ford sssp routine

__global__ void sssp_kernel(graph *g)
{
    if(threadIdx.x < g->e)
    {    
        unsigned int id = blockIdx.x*blockDim.x + threadIdx.x; //id of thread

        //storing corresponding weight, vertices and distance values into thread's local memory 
        int w = g->edgelist[id].first; //weight of edge
        int v1 = g->edgelist[id].second.first; //end 1 of edge
        int v2 = g->edgelist[id].second.second; //end 2 of edge
        int d1 = g->distance[v1]; //distance value of end 1 at that iteration
        int d2 = g->distance[v2]; //distance value of end 2 at that iteration

        //__syncthreads(); //to sync all threads - so that all threads take only the value of the previous iteration
                         //preserves invariant of the algorithm 
        
        /*Implementing relax routine of bellman ford algorithm
        *AtomicMin is used to resolve read-write conflicts during interleaving
        */
        
        atomicMin(&(g->distance[v1]),(d2+w));
        atomicMin(&(g->distance[v2]),(d1+w)); 
    }
        
}