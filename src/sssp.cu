#include"../include/graph.cuh"

//host function for parallel bellman ford routine that invokes sssp_kernel iteratively 

void sssp(graph *cpu_g, graph *gpu_g)
{
    int i = (cpu_g->v - 1);
    while(i--)
    {
        sssp_kernel<<<1,cpu_g->e>>>(gpu_g);
    }

}