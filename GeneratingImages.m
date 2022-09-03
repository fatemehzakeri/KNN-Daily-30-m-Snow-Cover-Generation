function GeneratingImages(Landsat,Dates,R,info,ResultIndAll,destinationFolder,KNN,Type);
%% Inputs:
% Landsat: Landsat images
% 
% Dates=:Landsat Dates 
% 
% R:spatial referencing object 
% 
% info: Information about GeoTIFF file 
% 
% ResultIndAll:Ranked Learning Dates per Each Query Dates
%destinationFolder: Folder for Saving Tiff binary snow cover maps
%KNN: number of selected images
%Type:1='BINARY'or 2='NDSI'
%%

ResultInd2=ResultIndAll(:,1:KNN);

A=[];
B={};
for i=1:size(ResultInd2,1)
    for j=2:KNN
   [tf1,idx2] = ismember(ResultInd2(i,j),Dates);
   A(:,:,j-1)=Landsat{idx2,1};
    end
    if Type==1
    B{i,1}=mode(A,3);
    else if Type==2
    B{i,1}=mean(A,3);
        end
    end
    outputBaseName=string(ResultInd2(i,1))+ '.tif';
    fullDestinationFileName = fullfile(destinationFolder, outputBaseName);
    geotiffwrite(fullDestinationFileName, B{i,1},R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag)
end
end