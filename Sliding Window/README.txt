Para teste da fun��o sliding.m basta executar o script Teste.m


1o-  Importa uma image de uma face e a passa como argumento da fun��o sliding.m 
que transformar� em v�rios patches.

2o -Na fun��o sliding.m, salvo a image da face em um arquivo distorted.mat

3o - Em seguida, o script em python que far� a leitura desse arquivo,
distorted.mat (imagem da face), e o transformar� em patches.

4o - Os patches ser�o salvos em um arquivo patches.mat

5o - O arquivo patches.mat ser� importado novamente pelo Matlab e atribu�do a vari�vel matrixOfPatches.

A vari�vel matrixOfPatches importada pelo matlab ter� 3 dimens�es : a x b x c. Portanto, trata-se de um cubo, onde:

a - n�mero de pacotes gerados
b - n�mero de linhas de cada pacote
c - n�mero de colunas de cada pacote. 

Para uma imagem original 112x92, a vari�vel matrixOfPatches ficou com dimens�es 9309x6x6. Ou seja:
a - 9309 pacotes
b - 6 linhas por pacote
c - 6 colunas por pacotes