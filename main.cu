#include"include/graph.cuh"

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

    //routine that invokes sssp kernel from host
    sssp(cpu_g,gpu_g);

    //copying device data back into host memory
    cudaMemcpy(c_distance,g_distance,nv*sizeof(int),cudaMemcpyDeviceToHost);
    cudaMemcpy(c_edgelist,g_edgelist,ne*sizeof(piii),cudaMemcpyDeviceToHost);
    cudaMemcpy(cpu_g,gpu_g,sizeof(graph),cudaMemcpyDeviceToHost);
    
    cpu_g->edgelist = c_edgelist;
    cpu_g->distance = c_distance;

    printf("From source vertex %d :\n",start);

    //printing distance of vertices from host memory
    printgraph(cpu_g);
   
    return 0;

}