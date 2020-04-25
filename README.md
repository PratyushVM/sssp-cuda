# sssp-cuda
Implementation of parallel Bellman-Ford single-source shortest path algorithm in CUDA.

## Execution:
```
To build the project, run :
make

```
```

To run the algorithm on graphs from standard input:
./sssp <number of vertices> <number of edges> <source vertex>

In a file "sssp-cuda/edgelist.txt", edges in the form :
<weight of edge 0><end of edge 0> <end of edge 0>
<weight of edge 1><end of edge 1> <end of edge 1>
<weight of edge 2><end of edge 2> <end of edge 2>
...

Note : The graph cannot have negative cycles.

```


