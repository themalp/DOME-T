clear;
close all;
clc;
% put here the names of the original image
addpath('Images','Output')  
savepath pathdef.m
dinfo = dir('./images');
names_cell = {dinfo.name};
names_cell(:,1:2)=[];
%name_shell(1,2) = [];
strcat('./images', '/', names_cell);
Order = input('place the order of the DOME-T Adversarial Example');
%Order = int64(Order);
i = 0;
% put here the names of the original images in " "
for name = names_cell % string array for iteration
    i = i+1
    pathname = strcat(name{:});
    namechars = char(name); %convert to character vector for using it later
    path = cellstr(pathname);
    
    % %%%%%%% Load image
    img = imread(pathname);
    img = imresize(img,[224 224]);
    img_r = img(:,:, 1);
    img_g = img(:,:, 2);
    img_b = img(:,:, 3);
    Error(i,:) = {name,'RecNormError_r','RecNormError_g','RecNormError_b','Mean Reconstruction & Normalization Error','PSNRError_r','PSNRError_g','PSNRError_b', 'Mean PSNR Error'};%,'RecNormError_r2','RecNormError_g2','RecNormError_b2','PSNRError_r2','PSNRError_g2','PSNRError_b2','RecNormError_r3','RecNormError_g3','RecNormError_b3','PSNRError_r3','PSNRError_g3','PSNRError_b3'};
    % %%%%%%% Compute Tchebichef Moments of each RGB chanels 
	[Moments_r,NumMoments_r,RecNormError_r,PSNRError_r,T_vec_r,RecImg_r] = TMs(Order,img_r,1,0);
	[Moments_g,NumMoments_g,RecNormError_g,PSNRError_g,T_vec_g,RecImg_g] = TMs(Order,img_g,1,0);
	[Moments_b,NumMoments_b,RecNormError_b,PSNRError_b,T_vec_b,RecImg_b] = TMs(Order,img_b,1,0);
	
	% Build Reconstructed image from reconstructed RGB channels
	RecImg = img; %just to inherit the same structure
	%overwrite each chanel with the appropriate reconstructed chanel
	RecImg(:,:,1) = RecImg_r;
	RecImg(:,:,2) = RecImg_g;
	RecImg(:,:,3) = RecImg_b;
	% Build the name of the output image
	imname = strcat('Output/', namechars,'_Order',int2str(Order),'.jpg');
	% Write the reconstructed image
	RecImg2 = uint8(255 * mat2gray(RecImg));
	imwrite(RecImg2 ,imname);
	% Write the error measurements to "Error" matrix
	i=i+1;
    MeanRecNormError = (RecNormError_r(1)+RecNormError_g(1)+RecNormError_b(1))/3;
    MeanPSNRError = (PSNRError_r(1)+PSNRError_g(1)+PSNRError_b(1))/3;
	Error(i,:) = {imname,RecNormError_r(1),RecNormError_g(1),RecNormError_b(1),MeanRecNormError,PSNRError_r(1),PSNRError_g(1),PSNRError_b(1),MeanPSNRError};%,RecNormError_r(2),RecNormError_g(2),RecNormError_b(2),PSNRError_r(2),PSNRError_g(2),PSNRError_b(2),RecNormError_r(3),RecNormError_g(3),RecNormError_b(3),PSNRError_r(3),PSNRError_g(3),PSNRError_b(3)};
	clear RecImg RecImg_r RecImg_g RecImg_b Moments_b Moments_g Moments_r;  % delete the unused staff from the memory
 end
    %save('Output/Error.mat','Error');
	filename = 'Output/error.xlsx';
	xlswrite(filename,Error);
   
    %writecell(Error,'Error.csv');
    %Error = repmat(cell2mat( [ Error{:} ] ),size(Error));
    %dlmwrite('Errors.txt',Error, ',');  %clear % emptying ram load, makes code light and fast.end

