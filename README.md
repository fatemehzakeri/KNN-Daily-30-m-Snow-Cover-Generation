# Fatemeh-Zakeri

KNN Daily 30 m Snow Cover Generation is composed of a main function named KNNSnowGeneration.mat for ranking learning dates based on their closeness. The second function is named GeneratingImages.mat for visulization and saving the generated binary 30 m snow cover maps.

KNN Daily 30 m Snow Cover Generation is composed of a main function named KNNSnowGeneration.mat for ranking learning dates based on their closeness.

KNNSnowGeneration needes two main imports and one otional import.

The first import in the funtion is a table named QueryDates (needed).

The columns of the QueryDates is a table composed of the short and long climate temporal-neighborhood of temperature min/max and precipitation, shadow,  MOD10A1, MYD10A1and the nearest actual Landsat/Sentinel within 30 days. The rows is exch Query Dates. 

The second import in the funtion is a table named LearningDates (needed).

The columns of the LearningDates is a table composed of the short and long climate temporal-neighborhood of temperature min/max and precipitation, shadow,  MOD10A1, MYD10A1 and the actual Landsat/Sentinel for the Learning Dates. The rows is exch  Learning Dates.

The second import in the funtion is a table named Weights (Optinal).

The columns of the Weights is a table composed of the weights for: TmaxShortTemporal-neighborhood, TminShortTemporal-neighborhood,PreShortTemporal-neighborhood, TmaxLongTemporal-neighborhood, TminLongTemporal-neighborhood, PreLongTemporal-neighborhood, MOD10A1, MYD10A1, Shadow, Nearest30mSnowMap
