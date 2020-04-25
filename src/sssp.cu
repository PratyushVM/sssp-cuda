#include"../include/graph.cuh"

//host function for parallel bellman ford routine that invokes sssp_kernel iteratively 

void sssp(graph *cpu_g, graph *gpu_g)
{
    int i = cpu_g->v;
    while(i--)
    {
        sssp_kernel<<<nblocks,threads_per_block>>>(gpu_g);
    }

}