clc;

Training_Set_Folder = 'FaceDatabase/Database1/Train_Data';
m1 = 6;
n1 = 3;
TS_Vector = dir(Training_Set_Folder);
No_Folders_In_Training_Set_Folder = length(TS_Vector);

File_Count = 1;
Class_Count = 1;
% for each folder in trainnig set folder we have files of one class
for k = 3:No_Folders_In_Training_Set_Folder
    Class_Folder = [Training_Set_Folder '/' TS_Vector(k).name,'/'];
    CF_Tensor = dir(Class_Folder);
    No_Files_In_Class_Folder(Class_Count) = length(CF_Tensor)-2;
    
    % for each file of one class
    for p = 3:No_Files_In_Class_Folder(Class_Count)+2
        Tmp_Image_Path = Class_Folder;
        Tmp_Image_Name = CF_Tensor(p).name;
        Tmp_Image_Path_Name = [Tmp_Image_Path,Tmp_Image_Name];
        if strcmp(Tmp_Image_Name,'Thumbs.db')
            break
        end
        
        % read image. if rgb, transform to gray scale. saves the image.
        test = imread(Tmp_Image_Path_Name);
        if length(size(test))==3
            Tmp_Image = rgb2gray(test);
        else
            Tmp_Image = test;
        end
        
        % resize the image to 6x3. it uses bicubic interpolation and
        % performs antialiasing. convert to double. save the image as a
        % atom of the dictionary, which has 5 images per class  
        Tmp_Image_resized = imresize(Tmp_Image,[m1 n1]);
        Tmp_Image_Down_Sampled = double(Tmp_Image_resized);
        Image_Data_Matrix(:,File_Count) = Tmp_Image_Down_Sampled(:);
        
        File_Count = File_Count+1;
    end
    Class_Count = Class_Count+1;
end
% normalize the dictionary to the columns have l^2 norm
A = Image_Data_Matrix;
A = A/(diag(sqrt(diag(A'*A))));


%% Test Case 01 - 03.pgm
fprintf('[TestCase01] Starting...\n');

% load test image
Test_File = '03.pgm';
Test_File_Path = 'FaceDatabase/Database1/Test_Data/s12/';
test_image_path = [Test_File_Path Test_File];
Test_File = [Test_File_Path Test_File];
test = imread(Test_File);
if length(size(test))==3
    Test_Image = rgb2gray(test);
else
    Test_Image = test;
end

% resize the image to 6x3. it uses bicubic interpolation and performs
% antialiasing. convert to double. save the image as a atom of the
% dictionary, which has 5 images per class  
Test_Image_Down_Sampled = double(imresize(Test_Image,[m1 n1]));
test_img_dict = Test_Image_Down_Sampled(:);

% x1 is the sparse code of test_img by l^1 minimization
n = size(A,2); %number of atoms or trained files
f = ones(2*n,1);
lb = zeros(2*n,1);
Aeq = [A -A];
x1 = linprog(f,[],[],Aeq,test_img_dict,lb,[],[],[]);
x1 = x1(1:n)-x1(n+1:2*n);

nn = No_Files_In_Class_Folder;
files_class_cumsum = cumsum(nn);
k1 = Class_Count-1;
% for each class, fill its corresponding columns with the sparse code of x1
for i = 1:k1
    delta_xi = zeros(length(x1),1);
    if i == 1
        delta_xi(1:files_class_cumsum(i)) = x1(1:files_class_cumsum(i));
    else
        begs = files_class_cumsum(i-1)+1;
        ends = files_class_cumsum(i);
        delta_xi(begs:ends) = x1(begs:ends);
    end
    recov_error = test_img_dict - A * delta_xi;
    tmp(i) = norm(recov_error, 2);
end

% the class with min error is the selected one
clss = find(tmp==min(tmp));

% print results
cccc = dir([Training_Set_Folder]);
Which_Folder = dir([Training_Set_Folder,'/',cccc(clss+2).name,'/']);
Which_Image = randsample(3:length(Which_Folder),1);
Class_Image = [Training_Set_Folder,'/',cccc(clss+2).name,'/',Which_Folder(Which_Image).name];
Detected_Class = cccc(clss+2).name;
fprintf('[TestCase01] Testing Image : %s\n', test_image_path);
fprintf('[TestCase01] Detected Image: %s\n', Class_Image);
fprintf('[TestCase01] Done!\n');


%% Test Case 02
fprintf('\n[TestCase02] Starting...\n');
IsTrue=0;
TotImg=0;
Testing_Set_Folder='FaceDatabase/Database1/Test_Data';
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
                test_img_dict = Test_Image_Down_Sampled(:);
                n = size(A,2);
                f=ones(2*n,1);
                Aeq=[A -A];
                lb=zeros(2*n,1);
                x1 = linprog(f,[],[],Aeq,test_img_dict,lb,[],[],[]);
                x1 = x1(1:n)-x1(n+1:2*n);
                files_class_cumsum = No_Files_In_Class_Folder;
                files_class_cumsum = cumsum(files_class_cumsum);
                tmp_var = 0;
                k1 = Class_Count-1;
                for i = 1:k1
                    delta_xi = zeros(length(x1),1);
                    if i == 1
                        delta_xi(1:files_class_cumsum(i)) = x1(1:files_class_cumsum(i));
                    else
                        tmp_var = tmp_var + files_class_cumsum(i-1);
                        begs = files_class_cumsum(i-1)+1;
                        ends = files_class_cumsum(i);
                        delta_xi(begs:ends) = x1(begs:ends);
                    end
                    tmp(i) = norm(test_img_dict-A*delta_xi,2);
                    tmp1(i) = norm(delta_xi,1)/norm(x1,1);
                end
                TotImg=TotImg+1;
                Sparse_Conc_Index(TotImg) = (k1*max(tmp1)-1)/(k1-1);
                clss = find(tmp==min(tmp));
                cccc = dir([Training_Set_Folder]);
                Which_Folder = dir([Training_Set_Folder,'/',cccc(clss+2).name,'/']);
                Which_Image = randsample(3:length(Which_Folder),1);
                Image_Path = [Training_Set_Folder,'/',cccc(clss+2).name,'/',Which_Folder(Which_Image).name];                
                Class_Image = (Image_Path);
                detectedClass = strcmp(TestFiles(k,1).name, cccc(clss+2).name);
                detectedFile = strcmp(Imgfiles(m,1).name, Which_Folder(Which_Image).name);
                fprintf('[TestCase02] Image %s.%d: %d/%d\n', TestFiles(k,1).name, m-2, detectedClass, detectedFile);
            end
        end
    end
end
fprintf('[TestCase02] Done!\n');