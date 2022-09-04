function CreatClearShdowCloudBands(ResultInd,ShadowDates,Shadow,CloudDates,Cloud,destinationFolder,R,info,KNN)

% Creat a tiff image with 2 baneds. The first band: is the precentage of clear-sky candidates per pixel (a map), 
%and the second band is the precentage of candidates per pixel that are not under the shadow (a map).


%Input:1) ResultInd:Ranked Learning Dates per Each Query Dates
% ShadowDates: Shadow Dates,
% Shadow: Shadow images,
% CloudDates: Cloud Images
% Cloud: Cloud images,
% destinationFolder= TO save Output
% R:spatial referencing object 
% % info: Information about GeoTIFF file 
%KNN: number of selected images

ResultInd2=ResultInd(:,1:KNN);

 A=[];
 A1=[];
 B1=[];
 B={};
 Image=[];
 


for i=1:size(ResultInd2,1)
    for j=2:KNN
   [tf1,idx1] = ismember(ResultInd2(i,j),ShadowDates);
   [tf2,idx2] = ismember(ResultInd2(i,j),CloudDates);
   B1=double(Shadow{idx1,1});
   B1_1=double(Cloud{idx2,1});
     A(:,:,j-1)=B1;
     A1(:,:,j-1)=B1_1;

    end
 [m,n,k] = size(A);
  B2 = reshape(permute(A,[3,1,2]),k,[]);
  B2_1 = reshape(permute(A1,[3,1,2]),k,[]);

  countsPercentage=[];
  for k= 1:size(B2,2)
      B3=B2(:,k);
      B3_1=B2_1(:,k);
      idx=isnan(B3);
      idx_1=isnan(B3_1);
        B3(idx)=[];
         B3_1(idx_1)=[];
    countsPercentage(k,:) = 100 * hist(B3, 2) / numel(B3);
    countsPercentage_1(k,:) = 100 * hist(B3_1, 2) / numel(B3_1);
  end
    kk=countsPercentage(:,2);
    kk_1=countsPercentage_1(:,2);
    B = reshape(kk,[m,n]);
    B_1 = reshape(kk_1,[m,n]);
   Image(:,:,1)=B;
   Image(:,:,2)=B_1;
   outputBaseName=string(ResultInd2(i,1))+ '.tif';
    fullDestinationFileName = fullfile(destinationFolder, outputBaseName);
    geotiffwrite(fullDestinationFileName, Image,R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag)
end

end