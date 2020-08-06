# Aviões

/* Conjuntos de classes por trecho */
set TRECHO1;
set TRECHO2;
set TRECHO3;

set CLASSES := TRECHO1 union TRECHO2 union TRECHO3;

/* Parametros */
param cost1 {TRECHO1} >= 0;
param cost2 {TRECHO2} >= 0;
param cost3 {TRECHO3} >= 0;
param costs {CLASSES} >= 0;

param max1 {TRECHO1} >= 0;
param max2 {TRECHO2} >= 0;
param max3 {TRECHO3} >= 0;
param max123 {CLASSES} >= 0;

/* Variables */
var class {i in CLASSES} >= 0, <= max123[i];

/* print */
#printf "CLASSES\tOST\tMAX\tVAR\n";
#printf {classe in CLASSES} "%s\t%s\t%s\t%s\n", classe, costs[classe], max123[classe];

maximize profit : sum{i in CLASSES} costs[i] * class[i];

R1: sum{i in TRECHO1} class[i] + sum{j in TRECHO3} class[j] <= 30;
R2: sum{i in TRECHO3} class[i] + sum{j in TRECHO2} class[j] <= 30;

solve;

printf "SOLUTION: \n";
display class;

