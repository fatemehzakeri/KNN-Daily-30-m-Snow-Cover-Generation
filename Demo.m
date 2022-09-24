%% Demo
%This is a demo to show how you are able to use the codes
%% Clearing Workspace
clc
clear
close all
%% Reading the data needed for ranking learning dates using "KNNSnowGeneration" Function
QueryDates=load('QueryDates.mat');%Load Query Dates Table 
QueryDates=QueryDates.QueryDates;
LearningDates=load('LearningDates.mat');%Load Learning Dates Table 
LearningDates=LearningDates.LearningDates;
Weights=load('BayesResultXAtMinObjective.mat');%Load Weights Table (Optional)
Weights=Weights.BayesResultXAtMinObjective;
%% The function for Ranking the learning dates

[ResultIndAll,ErrorSTD,ErrorMean]=KNNSnowGeneration(QueryDates,LearningDates,Weights);%Generate Ranked Learning Dates per Each Query Dates
save('ResultIndAll.mat','ResultIndAll');%Save Ranked Learning Dates per Each Query Dates
%% Reading the data needed for Generation Snow Cover Maps using "GeneratingImages" Function 
Landsat=load('Landsat.mat');%Load Landsat images
Landsat=Landsat.Landsat;
Dates=load('LandsatDates.mat');%Load Landsat Dates 
Dates=Dates.LandsatDates;
R=load('R.mat');%Load spatial referencing object 
R=R.R1;
info=load('info.mat');%Load Information about GeoTIFF file 
info=info.info1;
ResultIndAll=load('ResultIndAll.mat');%Load Ranked Learning Dates per Each Query Dates (it is the output of KNNSnowGeneration function)
ResultIndAll=ResultIndAll.ResultIndAll;
destinationFolder = './OutputAll';%Define a destination folder for the output
%% The function for Generation Snow Cover Maps
GeneratingImages(Landsat,Dates,R,info,ResultIndAll,destinationFolder,12,1);
%% Reading the data needed for creating a tiff image with 2 baneds using "CreatClearShdowCloudBands" Function:
%The first band: is the precentage of clear-sky candidates per pixel (a map), 
% and the second band is the precentage of candidates per pixel that are not under the shadow (a map).

ShadowDates=load('ShadowDates.mat');%Load ShadowDates
ShadowDates=ShadowDates.ShadowDates;
Shadow=load('Shadow.mat');%Load Shadow data
Shadow=Shadow.Shadow;
ResultIndAll=load('ResultIndAll.mat');%Load Ranked Learning Dates per Each Query Dates
ResultIndAll=ResultIndAll.ResultIndAll;

Cloud=load('Cloud.mat');%Load Cloud data
Cloud=Cloud.Cloud;

CloudDate=load('CloudDate.mat');%Load CloudDates
CloudDate=CloudDate.CloudDate;

destinationFolder='./QB';%Define a destination folder for the output
R=load('R.mat');%Load spatial referencing object 
R=R.R1;
info=load('info.mat');%Load Information about GeoTIFF file 
info=info.info1;
%% The function for creating a map of contaning two bands: one the precentage of clear-sky candidates, the other for  the precentage of candidates per pixel that are not under the shadow
CreatClearShdowCloudBands(ResultIndAll,ShadowDates,Shadow,CloudDate,Cloud,destinationFolder,R,info,12);