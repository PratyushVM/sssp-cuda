#include<stdio.h>
#include<cuda.h>
#include<utility>

#define pii std::pair<int,int>
#define piii std::pair<int,std::pair<int,int>>
#define mp std::make_pair
#define f first
#define s second 

//declaration of class object - graph

class graph
{
public:
    
    int v,e; //number of vertices and edges
    int *distance; //array that stores distance of each vertex from source
    piii *edgelist; //list of edges in the form of <weight,vertex1,vertex2> tuples  

};

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

//Kernel invoked in sssp routine

__global__ void sssp_kernel(graph *g)
{
    unsigned int id = blockIdx.x*blockDim.x + threadIdx.x; //id of thread

    //storing corresponding weight, vertices and distance values into thread's local memory 
    int w = g->edgelist[id].f;
    int v1 = g->edgelist[id].s.f;
    int v2 = g->edgelist[id].s.s;
    int d1 = g->distance[v1];
    int d2 = g->distance[v2];

    __syncthreads(); //to create a barrier and sync all threads
    
    /*Implementing relax routine of bellman ford algorithm
     *AtomicMin is used to resolve read-write conflicts during interleaving
     */
    atomicMin(&(g->distance[v1]),(d2+w));
    atomicMin(&(g->distance[v2]),(d1+w));
    
}

//host function for simple_bfs routine that invokes sssp_kernel iteratively 

void sssp(graph *cpu_g, graph *gpu_g)
{
    int i = (cpu_g->v - 1);
    while(i--)
    {
        sssp_kernel<<<1,cpu_g->e>>>(gpu_g);
    }

}


//host function that reads graph data from command line

void readgraph(piii *c_edgelist, int nv, int ne, int argc, char **argv)
{
    if(argc <= 4 || argc%3 != 1)
    {
        printf("Enter valid arguments in command line\n");
        exit(0);
    }

    else
    {
        int i,j;
        for(i=0, j=4;j<argc-2;i++,j+=3)
        {
            int wt = atoi(argv[j]);
            int e1 = atoi(argv[j+1]);
            int e2 = atoi(argv[j+2]);
            c_edgelist[i] = mp(wt,mp(e1,e2));
        }
    }
    
}

//host function to print the distance of each vertex

void printgraph(graph *cpu_g)
{
    for(int i=0;i<cpu_g->v;i++)
    {
        printf("The distance of vertex %d is %d\n",i,cpu_g->distance[i]);
    }
}

//main function

int main(int argc, char **argv)
{
    //declaration of variables to store graph data on host and device
    graph *cpu_g,*gpu_g;
    int *c_distance,*g_distance;
    piii *c_edgelist,*g_edgelist;

    //asking user to run with inputs in command line if no inputs are given
    if(argc == 1)
    {
        printf("Enter arguments in command line\n");
        return 0;
    }

    int nv = atoi(argv[1]); //number of vertices
    int ne = atoi(argv[2]); //number of edges
    int start = atoi(argv[3]);  //source vertex

    //allocating host memory for data of graph in host
    c_distance = (int*)malloc(nv*sizeof(int));
    c_edgelist = (piii *)malloc(ne*sizeof(piii));

    //invoking function to read graph data from command line
    readgraph(c_edgelist,nv,ne,argc,argv);

    //allocating host memory for graph object
    cpu_g = (graph*)malloc(sizeof(graph));

    //assigning values to data members of graph object from host data
    cpu_g->v = nv;
    cpu_g->e = ne;
    cpu_g->distance = c_distance;
    cpu_g->edgelist = c_edgelist;

    //allocating device memory for graph object on GPU    
    cudaMalloc((void**)&gpu_g,sizeof(graph));
    cudaMalloc((void**)&g_distance,nv*sizeof( int));
    cudaMalloc((void**)&g_edgelist,ne*sizeof(piii));

    //copying host data onto device
    cudaMemcpy(g_distance,c_distance,nv*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(g_edgelist,c_edgelist,ne*sizeof(piii),cudaMemcpyHostToDevice);
    cudaMemcpy(gpu_g,cpu_g,sizeof(graph),cudaMemcpyHostToDevice);

    cudaMemcpy(&(gpu_g->edgelist),&g_edgelist,sizeof(piii *),cudaMemcpyHostToDevice);
    cudaMemcpy(&(gpu_g->distance),&g_distance,sizeof(int*),cudaMemcpyHostToDevice);

    //invoking kernel to initialize the distance array of the graph 
    init_distance_kernel<<<1,nv>>>(gpu_g,start);

    //declaration of bool variables in host - used for routine to invoke bfs kernel
    /*bool *cpu_done;
    cpu_done = (bool*)malloc(sizeof(bool));
    *cpu_done = false;

    //declaration of bool variables in device for routine to invoke bfs kernel   
    bool *gpu_done;
    cudaMalloc((void**)&gpu_done,sizeof(bool));
    cudaMemcpy(gpu_done,cpu_done,sizeof(bool),cudaMemcpyHostToDevice);*/

    //routine that invokes sssp kernel from host
    sssp(cpu_g,gpu_g);
    //cudaDeviceSynchronize();

    //copying device data back into host memory
    cudaMemcpy(c_distance,g_distance,nv*sizeof(int),cudaMemcpyDeviceToHost);
    cudaMemcpy(c_edgelist,g_edgelist,ne*sizeof(piii),cudaMemcpyDeviceToHost);
    cudaMemcpy(cpu_g,gpu_g,sizeof(graph),cudaMemcpyDeviceToHost);
    
    cpu_g->edgelist = c_edgelist;
    cpu_g->distance = c_distance;

    //printing distance of vertices from host memory
    printgraph(cpu_g);
   
    return 0;

}