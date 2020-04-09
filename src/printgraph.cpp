#include"../include/graph.h"

//host function to print the distance of each vertex

void printgraph(graph *cpu_g)
{
    for(int i=0;i<cpu_g->v;i++)
    {
        printf("The distance of vertex %d is %d\n",i,cpu_g->distance[i]);
    }
}