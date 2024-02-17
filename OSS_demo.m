%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Auther: Xin Xiong
%  Institute of Geospatial Information, Information Engineering University
%  No.62, Kexue avenue, Zhengzhou City, Henan Provice, China
%  Version£ºOSS for multimodal image matching V1.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;close all;
warning('off');

%% data sets VI: Visible-Infrared; VS:Visible-SAR; LV:Lidar-Visible
addpath('.\Images');
% disp('Visible-Infrared');
% str = 'VI_1';
str = 'VI_2';
% str = 'VI_3';
% str = 'VS_1';
% str = 'LV_1';

disp(str);
str_ref = [str '_1.tif'];
str_sen= [str '_2.tif'];

image_1=imread(str_ref);
image_2=imread(str_sen);

%% Convert input image format
[~,~,L1]=size(image_1);
[~,~,L2]=size(image_2);
if(L1==3)
    image_11=rgb2gray(image_1);
else
    image_11=image_1;
end
if(L2==3)
    image_22=rgb2gray(image_2);
else
    image_22=image_2;
end

%Converted to floating point data
image_11=im2single(image_11);
image_22=im2single(image_22);

%% set parameters
t1=clock;
sr=4; % local area radius
nk=4; % number of selected points
nb=36; % number of orientation
K=0.01; % Number of extracted feature points = K * image_width * image_height
o=8; % number of oriented bin
PS = 72; % patch size
s0 = 1.2; % initial standard deviation
cform='affine'; % 'similarity','affine','perspective'

%% OSS Features
tic;
[kps1, M1] = OSS_detector(image_11, sr, nk, K, s0);
[kps2, M2] = OSS_detector(image_22, sr, nk, K, s0);
disp(['OSS detector time£º',num2str(toc),'s']);
tic;
ssf1 = OSS_descriptor(M1, kps1, sr, nb, o, PS, 4, 10);
ssf2 = OSS_descriptor(M2, kps2, sr, nb, o, PS, 4, 10);
disp(['OSS descriptor time£º',num2str(toc),'s']);

%% OSS Matching
tic;
[solution,rmse,cor1,cor2]=OSS_match(ssf1.des,double(ssf1.kps),ssf2.des,double(ssf2.kps),cform);
disp(['NNDR matching time£º',num2str(toc),'s']);

t2=clock;
disp(['Total time£º',num2str(etime(t2,t1)),'s']);

%% Matching
appendimages(image_1,image_2,cor1,cor2);

%% Registration
image_fusion(image_1,image_2,inv(solution));











