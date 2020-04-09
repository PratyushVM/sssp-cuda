CC = g++
NVCC = nvcc

all : sssp

sssp : obj/main.o obj/readgraph.o obj/printgraph.o obj/sssp.o obj/init_dist.o obj/sssp_kernel.o
	$(NVCC) obj/main.o obj/readgraph.o obj/printgraph.o obj/sssp.o obj/init_dist.o obj/sssp_kernel.o -o sssp

obj/main.o : main.cu obj     
	$(NVCC) -c main.cu -o obj/main.o 

obj/readgraph.o : src/readgraph.cpp obj
	$(CC) -c src/readgraph.cpp -o obj/readgraph.o  

obj/printgraph.o : src/printgraph.cpp obj
	$(CC) -c src/printgraph.cpp -o obj/printgraph.o

obj/sssp.o : src/sssp.cu obj
	$(NVCC) -c src/sssp.cu -o obj/sssp.o

obj/init_dist.o : src/init_dist.cu obj
	$(NVCC) -c src/init_dist.cu -o obj/init_dist.o

obj/sssp_kernel.o : src/sssp_kernel.cu obj
	$(NVCC) -c src/sssp_kernel.cu -o obj/sssp_kernel.o

obj : 
	mkdir obj

clean :
	rm obj/*.o ./sssp
	rmdir obj