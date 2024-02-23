clc
clear
close all

%% Data Input
%------Reference image
[RefName, RefPath] = uigetfile('*','Select the reference image');
RefImg = abs(double(imread(fullfile(RefPath, RefName))));
%-------Subject image
[SubName, SubPath] = uigetfile('*','Select the subject image');
SubImg = abs(double(imread(fullfile(SubPath, SubName))));
thresh = multithresh(SubImg(:,:,1), 3);

% Replace NaN values with 0
RefImg(isnan(RefImg)) = 0;
SubImg(isnan(SubImg)) = 0;

%% Location-independent relative radiometric normalization (LIRRN)
N = 1000;

% Perform normalization
tic
[NormImg, RMSE, R_ad] = LIRRN(N, SubImg, RefImg);
Time = round(toc, 2);

%% Results depiction
disp(['Time= ', num2str(Time), ' (s).'])

% Display images
figure('color', 'w'), imshow(uint8(abs(SubImg(:,:,[3 2 1]))),[]), title('Subject image','FontName','Times New Roman')
figure('color', 'w'), imshow(uint8(NormImg(:,:,[3 2 1])),[]), title('Normalized image','FontName','Times New Roman')
figure('color', 'w'), imshow(uint8(RefImg(:,:,[3 2 1])),[]), title('Reference image','FontName','Times New Roman')
