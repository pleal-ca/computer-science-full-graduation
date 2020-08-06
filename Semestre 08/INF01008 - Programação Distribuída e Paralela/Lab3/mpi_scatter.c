/* Comunicação coletiva - Uso de MPI_Scatter

- é a primitiva responsável por distribuir uma
estrutura de dados de um processo para os
demais processos do grupo;

- incluindo o emissor
o processo emissor e os receptores
executam a mesma primitiva, com os
mesmos argumentos.

*/

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

/* processo zero envia a todos uma parte */
/* processo zero também recebe uma parte */
#define N 10

int main(int argc, char **argv){
	int size, rank, i;
	int *comp; /* área origem */
	int *parc; /* área destino */
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	
	/* calcula dados a enviar; somente o zero */
	/* envia N inteiros */
	if (rank == 0) {
		comp = (int *) malloc(N*sizeof(int));
		
		for(i = 0; i < N; i++)
			comp[i]=i;
	}
	
	/* aloca área de recepção por processo */
	/* (total_de_dados / total_de_processos) * tam_dado */
	/* obs.: tamanho de int = tamanho de MPI_INT */
	parc = (int *) malloc(N/size*sizeof(int));
	
	MPI_Scatter(comp, N/size, MPI_INT, parc, N/size, MPI_INT, 0, MPI_COMM_WORLD);
	
	for(i = 0; i < N/size; i++)
		printf("rank: %d - value: %d\n", rank, parc[i]);
	
	MPI_Finalize();
	return(0);
}
