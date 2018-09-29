Para teste da função sliding.m basta executar o script Teste.m


1o-  Importa uma image de uma face e a passa como argumento da função sliding.m 
que transformará em vários patches.

2o -Na função sliding.m, salvo a image da face em um arquivo distorted.mat

3o - Em seguida, o script em python que fará a leitura desse arquivo,
distorted.mat (imagem da face), e o transformará em patches.

4o - Os patches serão salvos em um arquivo patches.mat

5o - O arquivo patches.mat será importado novamente pelo Matlab e atribuído a variável matrixOfPatches.

A variável matrixOfPatches importada pelo matlab terá 3 dimensões : a x b x c. Portanto, trata-se de um cubo, onde:

a - número de pacotes gerados
b - número de linhas de cada pacote
c - número de colunas de cada pacote. 

Para uma imagem original 112x92, a variável matrixOfPatches ficou com dimensões 9309x6x6. Ou seja:
a - 9309 pacotes
b - 6 linhas por pacote
c - 6 colunas por pacotes