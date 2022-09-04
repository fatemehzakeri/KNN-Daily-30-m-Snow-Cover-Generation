
KNN Daily 30 m Snow Cover Generation is composed of the main function named KNNSnowGeneration.m for ranking learning dates based on their closeness. 
It also provides the average of the similarity metric over the candidates (a scalar), 2) the standard deviation of the similarity metric over the candidates (a scalar)

KNNSnowGeneration needs two main imports and one optional import.

The first import in the function is a table named QueryDates (needed).

The columns of the QueryDates are composed of the short and long climate temporal-neighborhood of temperature min/max and precipitation, shadow,  MOD10A1, MYD10A1and the nearest actual Landsat/Sentinel within 30 days. The rows are exch Query Dates. 

The second import in the function is a table named LearningDates (needed).

The columns of the LearningDates are composed of the short and long climate temporal-neighborhood of temperature min/max and precipitation, shadow,  MOD10A1, MYD10A1, and the actual Landsat/Sentinel for the Learning Dates. The rows are exch  Learning Dates.

The third import in the function is a table named Weights (Optional).

The columns of the Weights is a table composed of the weights for: TmaxShortTemporal-neighborhood, TminShortTemporal-neighborhood,PreShortTemporal-neighborhood, TmaxLongTemporal-neighborhood, TminLongTemporal-neighborhood, PreLongTemporal-neighborhood, MOD10A1, MYD10A1, Shadow, Nearest30mSnowMap

The second function is named GeneratingImages.m for visualization and saving the generated binary 30 m snow cover maps.
GeneratingImages needs 10 imports: 1) Landsat images, Landsat Dates, spatial referencing object, Information about GeoTIFF file, Ranked Learning Dates per Each Query Dates, destinationFolder, number of candidates, snow cover type: 1=Binary, 2=NDSI. The output is GeoTiff snow cover maps.

The third function creates a tiff image with 2 bands. The first band: is the percentage of clear-sky candidates per pixel (a map), 
and the second band is the percentage of candidates per pixel that are not under the shadow (a map). The inputs include Ranked Learning Dates per Query Dates, Shadow Dates,  Shadow images, Cloud Images, Cloud images, destinationFolder to save the output, spatial referencing object, and information about the GeoTIFF file.
