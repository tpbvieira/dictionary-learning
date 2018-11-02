% Autor: Paulo Henrique de Castro Oliveira
%% Fun��o para iniciliza��o do dicion�rios
% function D_initialized = initialize(lines,columns)
% %inicializando aleat�riamente o dicion�rio
%     D_initialized = rand(lines,columns);
% end

%% Inicializando o dicion�rio com colunas aleat�rias do sinal
%function D_initialized = initialize(lines,columns,signal)
% Dic=[];
% for i=1:columns
%   pos=randi(columns);
%   Dic(:,i)=signal(:,pos);
% end
% D_initialized=Dic;
%end
%end
%% Inicializando o dicion�rio com colunas sequenciais do sinal 
function D_initialized = initialize(lines,columns,signal)
pos = randperm(size(signal,2),columns);
D_initialized=signal(:,pos);%Atribui 3 colunas aleat�rias do sinal ao dicion�rio
end
%% Gerando um dicion�rio 2D-DCT  %Professor Elad
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