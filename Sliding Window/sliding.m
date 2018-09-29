function matrixofpatches = sliding(distorted)

save('distorted.mat','distorted'); %Salvando a imagem em um arquivo .mat

system('python C:\Users\paulo\Downloads\WinPython-64bit-3.5.3.1Qt5\notebooks\createPatches.py 3'); % Executando o comando no cmd

matrixofpatches = struct2array(load('patches.mat')); % Leitura do arquivo


end
