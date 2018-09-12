clc;

%Initialize DL parameters
% Image_Data_Matrix =[];
% K=3;
% noIt=2;

Training_Set_Folder = '/home/thiago/dev/projects/dictionary-learning/FaceRecogToolv4/FaceDatabase/Database1/Train_Data';
m1 = 6;
n1 = 3;
TS_Vector = dir(Training_Set_Folder);
No_Folders_In_Training_Set_Folder = length(TS_Vector);
File_Count = 1;
Class_Count = 1;
for k = 3:No_Folders_In_Training_Set_Folder
    Class_Folder = [Training_Set_Folder '/' TS_Vector(k).name,'/'];
    CF_Tensor = dir(Class_Folder);
    No_Files_In_Class_Folder(Class_Count) = length(CF_Tensor)-2;
    for p = 3:No_Files_In_Class_Folder(Class_Count)+2
        Tmp_Image_Path = Class_Folder;
        Tmp_Image_Name = CF_Tensor(p).name;
        Tmp_Image_Path_Name = [Tmp_Image_Path,Tmp_Image_Name];
        if strcmp(Tmp_Image_Name,'Thumbs.db')
            break
        end
        test = imread(Tmp_Image_Path_Name);
        if length(size(test))==3
            Tmp_Image = rgb2gray(test);
        else
            Tmp_Image = test;
        end
        Tmp_Image_Down_Sampled = double(imresize(Tmp_Image,[m1 n1]));
        Image_Data_Matrix(:,File_Count) = Tmp_Image_Down_Sampled(:);
        %         Tmp_Image_Down_Sampled=double(Tmp_Image_Down_Sampled/255);
        %         X = sliding(Tmp_Image_Down_Sampled);
        %         lines = size(X,1);
        %         D_hat=initialize(lines,K,X);
        %         [S_hat Dict]=modDic(D_hat,X,noIt);
        %         Dict=Dict(:);
        %         Image_Data_Matrix =[Dict Image_Data_Matrix];
        File_Count = File_Count+1;
    end
    Class_Count = Class_Count+1;    
end
A = Image_Data_Matrix;
%imshow(full(Dict));
%A=normalizeColumns(Image_Data_Matrix);
A = A/(diag(sqrt(diag(A'*A))));


%% Test Case 01
fprintf('[TestCase01] Starting...');
Test_File = '03.pgm';
Test_File_Path = '/home/thiago/dev/projects/dictionary-learning/FaceRecogToolv4/FaceDatabase/Database1/Test_Data/s12/';
test_image_path = [Test_File_Path Test_File];
Test_File = [Test_File_Path Test_File];
test = imread(Test_File);
if length(size(test))==3
    Test_Image = rgb2gray(test);
else
    Test_Image = test;
end
Test_Image_Down_Sampled = double(imresize(Test_Image,[m1 n1]));
y = Test_Image_Down_Sampled(:);
n = size(A,2);
f=ones(2*n,1);
Aeq=[A -A];
lb=zeros(2*n,1);
x1 = linprog(f,[],[],Aeq,y,lb,[],[],[]);
x1 = x1(1:n)-x1(n+1:2*n);
nn = No_Files_In_Class_Folder;
nn = cumsum(nn);
tmp_var = 0;
k1 = Class_Count-1;
for i = 1:k1
    delta_xi = zeros(length(x1),1);
    if i == 1
        delta_xi(1:nn(i)) = x1(1:nn(i));
    else
        tmp_var = tmp_var + nn(i-1);
        begs = nn(i-1)+1;
        ends = nn(i);
        delta_xi(begs:ends) = x1(begs:ends);
    end
    tmp(i) = norm(y-A*delta_xi,2);
    tmp1(i) = norm(delta_xi,1)/norm(x1,1);
end
Sparse_Conc_Index = (k1*max(tmp1)-1)/(k1-1);
clss = find(tmp==min(tmp));
cccc = dir([Training_Set_Folder]);
Which_Folder = dir([Training_Set_Folder,'/',cccc(clss+2).name,'/']);
Which_Image = randsample(3:length(Which_Folder),1);
Image_Path = [Training_Set_Folder,'/',cccc(clss+2).name,'/',Which_Folder(Which_Image).name];
Class_Image = (Image_Path);
Detected_Class = cccc(clss+2).name;
fprintf('[TestCase01] Testing Image : %s\n', test_image_path);
fprintf('[TestCase01] Detected Image: %s\n', Class_Image);
fprintf('[TestCase01] Done!');

%% Test Case 02
fprintf('[TestCase02] Starting...');
IsTrue=0;
TotImg=0;
Testing_Set_Folder='/home/thiago/dev/projects/dictionary-learning/FaceRecogToolv4/FaceDatabase/Database1/Test_Data';
TestFiles = dir(Testing_Set_Folder);
for k=1:length(TestFiles)
    if ~strcmp(TestFiles(k,1).name(1),'.')
        Imgfiles=dir([Testing_Set_Folder '/' TestFiles(k).name]);
        for m=1:length(Imgfiles)
            if ~strcmp(Imgfiles(m,1).name(1),'.')
                Test_File = [Testing_Set_Folder '/' TestFiles(k,1).name '/' Imgfiles(m,1).name];
                test = imread(Test_File);
                if length(size(test))==3
                    Test_Image = rgb2gray(test);
                else
                    Test_Image = test;
                end
                Test_Image_Down_Sampled = double(imresize(Test_Image,[m1 n1]));
                y = Test_Image_Down_Sampled(:);
                n = size(A,2);
                %                 cvx_quiet true
                %                 cvx_begin
                %                 variable x1(n)
                %                 minimize norm(x1,1)
                %                 subject to
                %                 A*x1 == y;
                %                 cvx_end
                % figure,plot(x1);
                f=ones(2*n,1);
                Aeq=[A -A];
                lb=zeros(2*n,1);
                x1 = linprog(f,[],[],Aeq,y,lb,[],[],[]);
                x1 = x1(1:n)-x1(n+1:2*n);
                nn = No_Files_In_Class_Folder;
                nn = cumsum(nn);
                tmp_var = 0;
                k1 = Class_Count-1;
                for i = 1:k1
                    delta_xi = zeros(length(x1),1);
                    if i == 1
                        delta_xi(1:nn(i)) = x1(1:nn(i));
                    else
                        tmp_var = tmp_var + nn(i-1);
                        begs = nn(i-1)+1;
                        ends = nn(i);
                        delta_xi(begs:ends) = x1(begs:ends);
                    end
                    tmp(i) = norm(y-A*delta_xi,2);
                    tmp1(i) = norm(delta_xi,1)/norm(x1,1);
                end
                TotImg=TotImg+1;
                Sparse_Conc_Index(TotImg) = (k1*max(tmp1)-1)/(k1-1);
                clss = find(tmp==min(tmp));
                % figure,plot(tmp)
                ssttrr = sprintf('The Test Image Corresponds to Class: %d',clss)
                cccc = dir([Training_Set_Folder]);
                Which_Folder = dir([Training_Set_Folder,cccc(clss+2).name,'/']);
                Which_Image = randsample(3:length(Which_Folder),1);
                Image_Path = [Training_Set_Folder,cccc(clss+2).name,'/',Which_Folder(Which_Image).name];
                Class_Image = (Image_Path);
                axes(handles.axes4);
                imshow(Class_Image)
                %                 title('Detected Image','Color','black','FontSize',25)
                
                set(handles.togglebutton3,'visible','on')
                set(handles.togglebutton4,'visible','on');
                set(handles.text3,'visible','on');
                
                while 1
                    pause(eps)
                    if get(handles.togglebutton3,'value')==1
                        IsTrue=IsTrue+1;
                        set(handles.togglebutton3,'value',0)
                        break;
                    elseif get(handles.togglebutton4,'value')==1
                        set(handles.togglebutton4,'value',0)
                        break;
                    end
                end
                set(handles.togglebutton3,'visible','off')
                set(handles.togglebutton4,'visible','off');
                set(handles.text3,'visible','off');
                axes(handles.axes4)
            end
        end
    end
end


eta = (IsTrue/TotImg)*100;
set(handles.edit2,'visible','on');
set(handles.text4,'visible','on');
set(handles.edit2,'String',[num2str(eta) '%']);
drawnow;
set(handles.togglebutton3,'visible','off')
set(handles.togglebutton4,'visible','off');
fprintf('[TestCase02] Done!');