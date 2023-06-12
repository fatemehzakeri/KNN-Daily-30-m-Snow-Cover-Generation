Attention:
When using the "Download zip" button, please ensure that you download the zip subfolders separately.



Introduction:

This method generates binary or NDSI daily 30 m Landsat snow cover maps using climate, environmental, and satellite data. It is based on learning from the dates that Landsat or Sentinel-2 data is available for mapping snow for those dates without satellite data. 

Functions:

It is composed of three functions that are explained as follows:

1) first function: KNNSnowGeneration.m

1-1) Output: 

- ranked learning dates (the dates that both climate, auxiliary, and almost clear-sky 30 m Landsat data is available) based on their closeness to the query date that only climate and auxiliary data is available. 
- the average of the similarity metric over the candidates (a scalar).
- the standard deviation of the similarity metric over the candidates (a scalar).

1-2) Inputs:

- a table named QueryDates (needed):
The rows are exch Query Dates. 
The columns are composed of the short and long climate temporal-neighborhood of temperature min/max and precipitation, shadow,  MODIS(MOD10A1, MYD10A1), and the nearest actual Landsat/Sentinel within 30 days. There is an example Table (named QueryDates.rar) belonging to the Western Swiss Alps generated using Era5 climate data, MODIS, and Landsat/Sentinel. 

- a table named LearningDates (needed):
The rows are each  Learning Dates.
The columns of the LearningDates are composed of the short and long climate temporal-neighborhood of temperature min/max and precipitation, shadow,  MOD10A1, MYD10A1, and the actual Landsat/Sentinel for the Learning Dates. An example Table (named LearningDates.rar) belonging to the Western Swiss Alps was generated using Era5 climate data, MODIS, and Landsat/Sentinel. 

- a table named Weights (Optional).

The  Weights table is composed of the weights belongs to: TmaxShortTemporal-neighborhood, TminShortTemporal-neighborhood,PreShortTemporal-neighborhood, TmaxLongTemporal-neighborhood, TminLongTemporal-neighborhood, PreLongTemporal-neighborhood, MOD10A1, MYD10A1, Shadow, Nearest30mSnowMap.

2) second function: GeneratingImages.m 

2-1) Output:

Saving the generated binary or NDSI 30 m snow cover maps with tiff format.

2-2) Inputs:
- Landsat images: a cell containing either binary or NDSI Landsat/Sentinel images.
- Landsat Dates: a matrix containing Landsat/Sentinel dates belong to the Landsat images, respectively.
- spatial referencing object: spatial referencing object belongs to one of the imported Landsat images.
- Information about GeoTIFF file:  Information about GeoTIFF file belongs to one of the imported Landsat images.
- Ranked Learning Dates per Each Query Date: This is the output of the KNNSnowGeneration.m  
- destinationFolder: The destination folder address for saving generated tiff images.
- number of candidates: is the number of best candidates, it always should be even. Based on our experiments,  if you have more than 300 images, you may use 11, but if you have around 150 images, we suggest using 5. 

- snow cover type: It should be a number: 1=Binary, 2=NDSI. 

3) third function: CreatClearShdowCloudBands.m

3-1) Output: 
Creating a tiff image with 2 bands. The first band: is the percentage of clear-sky candidates per pixel (a map), and the second band is the percentage of candidates per pixel that are not under the shadow (a map). 

3-2)Input: 

- Ranked Learning Dates per Each Query Date: This is the output of the KNNSnowGeneration.m

- Shadow images: a cell containing Shadow images. The Shadow images could be created using Google Earth Engine and SRTM 30 m DEM.

- Shadow Dates: a matrix containing Shadow dates belonging to the Shadow images, respectively.
 
- Cloud images: a cell containing Cloud images. The Cloud images could be obtained using Landsat Quality Band, or in Sentinel-2 images, it can be obtained using the SCL band. 
- Cloud Dates: a matrix containing Cloud dates belonging to the Cloud images, respectively.

- destinationFolder: The destination folder address for saving generated tiff images.

- spatial referencing object: spatial referencing object belongs to one of the imported Landsat images.
 
- Information about GeoTIFF file:  Information about GeoTIFF file belongs to one of the imported Landsat images.
- number of candidates: is the number of best candidates, it always should be even. Based on our experiments,  if you have more than 300 images, you may use 11, but if you have around 150 images, we suggest using 5. 
