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
<weight of edge 0><end of edge 0> <end of edge 0>
<weight of edge 1><end of edge 1> <end of edge 1>
<weight of edge 2><end of edge 2> <end of edge 2>
...

```

## Sample Input
```
./sssp 4 6 1 2 0 1 15 0 3 7 0 2 10 1 3 3 1 2 4 2 3
```
```
Output :

From source vertex 1 :
The distance of vertex 0 is 2
The distance of vertex 1 is 0
The distance of vertex 2 is 3
The distance of vertex 3 is 7

```

