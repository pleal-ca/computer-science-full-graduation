#include<stdio.h>;
int main()
{
   // Defini&ccedil;&atilde;o das vari&aacute;veis b&aacute;sicas
   int i, j, aux, menor, trocas, tamanho=9;
  // int vetor[]={1,2,3,4,5,6,7,8,9,10};
  int vetor[]={10,9,8,7,6,5,4,3,2,1};

   // Inicializa a variavel trocas
   trocas = 0;

   for(i=0;i<tamanho-1;i++)
      {
      menor = i;
      for(j=i+1;j<tamanho;j++)
         {
         if(vetor[j] < vetor[menor]) menor = j;
         }
      aux = vetor[i];
      vetor[i] = vetor[menor];
      vetor[menor] = aux;
      trocas++;
      }

   printf("\nVetor ordenado:\n");
   for(i=0;i<tamanho;i++) 
	printf("Elemento %2d: %3d\n",i+1,vetor[i]);
   printf("\nTrocas efetuadas: %2d\n",trocas);   
   system("pause");
}
