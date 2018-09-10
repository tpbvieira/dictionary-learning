% Autor: Paulo Henrique de Castro Oliveira
%% Função para inicilização do dicionários
function D_normalized = normalizeColumns(D)
  D_normalized=[];
  [L K]=size(D);
    for i = 1:K
      D_normalized(:,i)=D(:,i)./norm(D(:,i));
    end
end

%% D_normalized=D/norm(D);
% end

