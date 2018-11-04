function matrixofpatches = sliding(distorted)

save('distorted.mat','distorted'); %Salvando a imagem em um arquivo .mat

system('python createPatches.py 3'); % Executando o comando no cmd

patches = struct2array(load('patches.mat')); % Leitura do arquivo

matrixofpatches=[];

[a b c]=size(patches);
    for i = 1: a
        matrixofpatches=[squeeze(patches(i,:,:)) matrixofpatches];
    end
delete('distorted.mat');
delete('patches.mat');

end
