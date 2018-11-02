% Autor: Paulo Henrique de Castro Oliveira
%% Função para inicilização do dicionários
% function D_initialized = initialize(lines,columns)
% %inicializando aleatóriamente o dicionário
%     D_initialized = rand(lines,columns);
% end

%% Inicializando o dicionário com colunas aleatórias do sinal
%function D_initialized = initialize(lines,columns,signal)
% Dic=[];
% for i=1:columns
%   pos=randi(columns);
%   Dic(:,i)=signal(:,pos);
% end
% D_initialized=Dic;
%end
%end
%% Inicializando o dicionário com colunas sequenciais do sinal 
function D_initialized = initialize(lines,columns,signal)
pos = randperm(size(signal,2),columns);
D_initialized=signal(:,pos);%Atribui 3 colunas aleatórias do sinal ao dicionário
end
%% Gerando um dicionário 2D-DCT  %Professor Elad
% K=columns;
% n=lines;
% Dictionary=zeros(n,K);
% for k=0:1:9
%   V=cos(384*k*pi/10);
%   if k>0, V=V-mean(V);end
%     Dictionary(:,k+1)=V/norm(V);
%   end
% D_initialized = kron(Dictionary,Dictionary);
% plot(D_initialized);
%end