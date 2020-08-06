#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

#define N 8

int main(int argc, char **argv) {

	int rank,size,i, *vet, restotal, resparcial=0;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	MPI_Comm_size(MPI_COMM_WORLD,&size);

	/* cada processo precisa de parte dos dados: N/size */
	vet = (int *) malloc(N/size*sizeof(int));

	/* todos inicializam seu vetor */
	for(i=0;i<N/size;i++)
		vet[i] = rank;

	/* cada um calcula sua parte */
	for(i=0;i<N/size;i++)
		resparcial += vet[i] * vet[i];

	/* soma geral; tamanho por proc: 1 */
	MPI_Reduce(&resparcial, &restotal, 1, MPI_INT,
	MPI_SUM, 0, MPI_COMM_WORLD);

	/* imprime resultado final */
	if (rank==0)
	printf("Produto Escalar %d\n", restotal);

	MPI_Finalize();
	return(0);
}
