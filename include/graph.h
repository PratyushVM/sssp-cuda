#ifndef __GRAPH__HEADER__
#define __GRAPH__HEADER__
#include<stdio.h>
#include<utility>

#define pii std::pair<int,int>
#define piii std::pair<int,std::pair<int,int>>
#define mp std::make_pair

#define nthreads 35592
#define threads_per_block 256
#define nblocks nthreads/threads_per_block + 1

//declaration of class object - graph

class graph
{
public:
    
    int v,e; //number of vertices and edges
    int *distance; //array that stores distance of each vertex from source
    piii *edgelist; //list of edges in the form of <weight,vertex1,vertex2> tuples  

};

//function prototypes for host functions
void sssp(graph *cpu_g, graph *gpu_g);
void readgraph(piii *c_edgelist, int nv, int ne, int argc, char **argv);
void printgraph(graph *cpu_g);

#endif
