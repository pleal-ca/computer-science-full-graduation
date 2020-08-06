/*
FCG  - BasicoDesenho.cpp
incrementa o programa Basico com desenho de uma figura geometrica 

a) Modifique a cor de cada um dos v�rtices do tri�ngulo. 
    Para isso, voc� vai precisar colocar uma fun��o glColor3f(<red>f, <green>f,<blue>f ); 
   com valores diferentes para <red>, <green> e <blue> antes de cada chamada de fun��o glVertex2f (...);

b) Inclua, antes da chamada da fun��o glBegin(GL_TRIANGLES); uma chamada glShadeModel (GL_FLAT); 
    e verifique a diferen�a para a situa��o anterior.

c) Modifique a fun��o glBegin (GL_TRIANGLES);  para glBegin (GL_LINES);   e observe o resultado.

d) Declare uma nova vari�vel P4, para armazenar as coordenadas de um quarto v�rtice, inicializando-a 
com os valores (0.5,0.5) e utilize-a colocando uma chamada  glVertex2f (P4.x,P4.y); como �ltima 
chamada no bloco begin-end. Observe o resultado.

e) Modifique novamente glBegin (GL_LINES); pelas constantes abaixo observando o resultado 
a cada modifica��o: GL_LINE_STRIP, GL_LINE_LOOP, GL_TRIANGLE_STRIP, GL_TRIANGLE_FAN

f) Acrescente outras 4 chamadas na estrutura begin-end, da seguinte forma:
glVertex2f (0.8f, 0.5f); 
glVertex2f (0.8f, 0.8f); 
glVertex2f (1.0f, 0.8f); 
glVertex2f (1.0f,1.0f);
   Observe o que � exibido se voc� utiliza:  GL_QUADS, GL_QUAD_STRIP, GL_POLYGON, GL_POINTS.

g) Crie pol�gonos diferentes (por exemplo um octaedro), substituindo os que est�o no bloco begin-end. 

h) Pontos, linhas e pol�gonos tem atributos visuais al�m da cor. Pontos t�m 
tamanho do s�mbolo marcador; linhas t�m espessura e padr�o (tracejado, pontilhado) 
e pol�gonos tamb�m t�m padr�o de preenchimento.

Observe as chamadas abaixo, testando-as no programa acima, com as primitivas adequadas:

glPointSize (2.0);  // especifica que os pontos v�o ser representados por 2x2 pixels 
glLineWidth (2.0);  // especifica espessura das linhas
*/

/*
include de definicoes das funcoes da glut 
glut.h inclui gl.h, que contem os headers de funcoes da OpenGL propriamente dita
glut.h inclui tambem definicoes necessarias para o uso de OpenGl nos diversos ambientes Windows
*/
#include <gl/glut.h>

// estrutura que descreve um ponto (x,y)
typedef struct XY {
        GLfloat x;
        GLfloat y;
} PontoXY;

PontoXY P1, P2, P3, P4;


/* 
Fun��o de callback de desenho
Executada sempre que � necessario re-exibir a imagem
*/
void RenderScene(void){
	// Limpa a janela com a cor especificada como cor de fundo
	glClear(GL_COLOR_BUFFER_BIT);
 
    // Define a pr�xima cor a ser utilizada 
    //glColor3f (1.0f, 0.0f, 1.0f); // cor rosa
    
    //glShadeModel (GL_FLAT);
    
    //glPointSize (2.0); // Aumenta o tamanho dos pontos
    
    glLineWidth (4.0);  // especifica espessura das linhas
    
    // Chamadas de fun��es OpenGL para desenho
    //glBegin (GL_LINE_STRIP);
    //glBegin (GL_TRIANGLES);
    glBegin (GL_LINE_LOOP);
    //glBegin (GL_TRIANGLE_STRIP);
    //glBegin (GL_TRIANGLE_FAN);
    //glBegin (GL_QUADS);
    //glBegin (GL_QUAD_STRIP);
    //glBegin (GL_POLYGON);
    //glBegin (GL_POINTS);
      glColor3f (1.0f, 0.0f, 0.0f); // cor vermelha
	  glVertex2f (P1.x,P1.y);
      glColor3f (0.0f, 1.0f, 0.0f); // cor verde	  
	  glVertex2f (P2.x,P2.y);
      glColor3f (0.0f, 0.0f, 1.0f); // cor azul
	  glVertex2f (P3.x,P3.y);
	  glColor3f (1.0f, 0.0f, 1.0f); // cor rosa
	  glVertex2f (P4.x,P4.y);
	  glVertex2f (0.8f, 0.5f); 
	  glColor3f (1.0f, 1.0f, 0.0f);
      glVertex2f (0.8f, 0.8f); 
      glVertex2f (1.0f, 0.8f); 
      glVertex2f (1.0f,1.0f);
    glEnd();

	// Flush dos comandos de desenho que estejam no &quot;pipeline&quot; da OpenGL
    // para conclusao da geracao da imagem
    glFlush();
}

/* Inicializa aspectos do rendering */
void SetupRC(void){
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);  // Cor de fundo da janela - branco
}

/* Inicializa os tres pontos com valores default */
void SetupObjeto (void){ 
    P1.x = 0;
    P1.y = 1;
    P2.x = -1;
    P2.y = 0;
    P3.x = 1;
    P3.y = 0;
    P4.x = 0.5;
    P4.y = 0.5;
}


/* 
Parte principal - ponto de in�cio de execu��o
Cria janela 
Inicializa aspectos relacionados a janela e a geracao da imagem
Especifica a funcao de callback de desenho
*/
int main(void){
	// Indica que deve ser usado um unico buffer para armazenamento da imagem e representacao de cores RGB
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    
    // Cria uma janela com o titulo especificado
	glutCreateWindow("Meu primeiro programa OpenGL");
 
    // Especifica para a OpenGL que funcao deve ser chamada para geracao da imagem
	glutDisplayFunc(RenderScene);

    // Executa a inicializacao de parametros de exibicao
	SetupRC();
 
    // Inicializa as informacoes geometricas do objeto
    SetupObjeto();

    // Dispara a &quot;maquina de estados&quot; de OpenGL 
	glutMainLoop();
	
	return 0;
}

