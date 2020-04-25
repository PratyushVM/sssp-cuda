#include"../include/graph.h"
#include<cstdlib>
#include<bits/stdc++.h>


//host function that reads graph data from command line

void readgraph(piii *c_edgelist, int nv, int ne, int argc, char **argv)
{

    FILE *fp = fopen("edgelist.txt","r");

    char buf1[10],buf2[10],buf3[10],buf4[30];
    int i=0,e1,e2,w;
    
    while(i<ne)
    {
       fscanf(fp,"%s",buf1);
       fscanf(fp,"%s",buf2);
       fscanf(fp,"%s",buf3);
       fscanf(fp,"%s",buf4);

       //fscanf(fp,"%s,%s,%s,%s ",buf1,buf2,buf3,buf4);

       e1 = atoi(buf1);
       e2 = atoi(buf2);
       w = abs(atoi(buf3));
       c_edgelist[i++] = mp(w,mp(e1,e2));
    }
    
}