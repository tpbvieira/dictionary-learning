%Paulo Henrique de Castro Oliveira
%% Method Of Optimal Directions
function [S_hat,D_hat] = modDic(D,X,iterations)
 D_hat=D;
 %A=zeros(10,512);
 %Repeat for N iterations
 for i=1:iterations
  %S_hat = omp(D_hat,X,5);
  S_hat = OMPerr(D_hat,X,0.05); 
  D_hat = X*pinv(full(S_hat));
  D_hat = normalizeColumns(D_hat);
 end
end
