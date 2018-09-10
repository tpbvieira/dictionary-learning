function matrixofpatches = sliding(distorted)
%Patch size 6x6
matrixofpatches=[];
for row = 1:19
    for column=1:15
      cell = distorted((row*6-5):row*6,(column*6-5):column*6);
      matrixofpatches = [matrixofpatches cell];
    end
end
%matrixofpatches=reshape(distorted,8,12288); %Para teste
%matrixofpatches=im2col(distorted,[8 8],'sliding');
%matrixofpatches=[matrixofpatches distorted];
end
