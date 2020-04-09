#include"../include/graph.h"
#include<cstdlib>


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
            c_edgelist[i] = mp(wt,mp(e1,e2));   //stores each edge as (weight,(end1,end2))
        }
    }
    
}