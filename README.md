# Soybean dependence on biotic pollination decreases with latitude

Release of Datasets and R Scripts used to analyze and produce figures to accompany the acceptance of the paper 'Soybean dependence on biotic pollination decreases with latitude' in Agriculture, Ecosystems & Environment.

> *see data description below*

## Citation
Cunha, N.L., Chacoff, N. P., Sáez, A., Schmucki, R., Galetto, L., Devoto, M., Carrasco, J., Mazzei, M. P., Castillo, S. E., Palacios, T. P., Vesprini, J. L., Agostini, K., Saraiva, A. M., Woodcock, B., Ollerton, J., & Aizen, M. A. (2023). Soybean dependence on biotic pollination decreases with latitude (Version 1.0.0) [Data and Computer code]. https://doi.org/10.5281/zenodo.TBC


## Highlights
 - In the absence of pollinators, soybean yield decreases between 0 and ~50%.
 - Variation in pollinator dependence (PD) was found to be structured latitudinally.
 - PD decreases at high latitudes due to an apparently higher incidence of autogamy.
 - Temperature and photoperiod could play an important role in determining PD.
 - Changes in cleistogamy and androsterility might explain the reported trends. 

## Abstract
Identifying large-scale patterns of variation in pollinator dependence (PD) in crops is important from both basic and applied perspectives. Evidence from wild plants indicates that this variation can be structured latitudinally. Individuals from populations at high latitudes may be more selfed and less dependent on pollinators due to higher environmental instability and overall lower temperatures, environmental conditions that may affect pollinator availability. However, whether this pattern is similarly present in crops remains unknown. Soybean (Glycine max), one of the most important crops globally, is partially self-pollinated and autogamous, exhibiting large variation in the extent of PD (from a 0 to ~50% decrease in yield in the absence of animal pollination). We examined latitudinal variation in soybean’s PD using data from 28 independent studies distributed along a wide latitudinal gradient (4-43 degrees). We estimated PD by comparing yields between open pollinated and pollinator-excluded plants. In the absence of pollinators, soybean yield was found to decrease by an average of ~30%. However, PD decreases abruptly at high latitudes, suggesting a relative increase in autogamous seed production. Pollinator supplementation does not seem to increase seed production at any latitude. We propose that latitudinal variation in PD in soybean may be driven by temperature and photoperiod affecting the expression of cleistogamy and androsterility. Therefore, an adaptive mating response to an unpredictable pollinator environment apparently common in wild plants can also be imprinted in highly domesticated and genetically-modified crops.

> ## Keywords
> autogamy, autonomous self-pollination, ecosystem services, Glycine max, honey bees, latitudinal gradients, pollinator dependence, soybean, yield.

## Content

### The dataset consists in two files

1 - [\[data\] Cunha et al. MS_soybean.xlsx](https://github.com/NERC-CEH/Soybean-dependence-on-biotic-pollination-decreases-with-latitude/blob/main/%5Bdata%5D%20Cunha%20et%20al.%20MS_soybean.xlsx) is an excel file with two sheets,
	**data** and **data_map**. These sheets contain the data used in the models defined in the R script 
	[\[R script\] Cunha et al. MS_soybean.R](https://github.com/NERC-CEH/Soybean-dependence-on-biotic-pollination-decreases-with-latitude/blob/main/%5BR%20script%5D%20Cunha%20et%20al.%20MS_soybean.R).

  - 1.1 The **data** sheet contains the variables:
   	* Value = log_ratios
   	* Lat = latitude in decimal degrees
   	* Variable = yield component
   	* Treatment = treatment type for comparing pollinator dependence
   	* Reference_Data_owner = study ID where where the data was obtained
   	* Site = site within study where each field experiment was performed
  
  - 1.2 The **data_map** sheet contains information used for plotting the geographical distribution of the used studies:
	
	* Reference_Data_owner = study ID where where the data was obtained
	* Country = country where the study was performed
	* Province = province where the study was performed
	* Locality/Farm = locality where the study was performed
	* Lat = latitude in decimal degrees
	* Long = longitude in decimal degrees

2 - [\[data\] Cunha et al. MS_soybean [date_photoperiod].csv](https://github.com/NERC-CEH/Soybean-dependence-on-biotic-pollination-decreases-with-latitude/blob/main/%5Bdata%5D%20Cunha%20et%20al.%20MS_soybean%20%5Bdate_photoperiod%5D.csv) is an coma separated file that 
	contains the information used in the R script [\[R script\] Cunha et al. ProcB - gee_temp_ts_extract.R](https://github.com/NERC-CEH/Soybean-dependence-on-biotic-pollination-decreases-with-latitude/blob/main/%5BR%20script%5D%20Cunha%20et%20al.%20AGEE%20-%20gee_temp_ts_extract.R) and produce Figure S2.
  
  - 2.1 The dataset contains the following variables:
	
	* study_ID = study ID number where where the data was obtained
	* study_ref = study ID where where the data was obtained
	* latitude = latitude in decimal degrees
	* longitude = longitude in decimal degrees
	* date1 = date of the sowing or flowering when the experiment was done
	* date2 = a second date, when availablee, of the sowing or flowering when the experiment was done
	* event = if the date was related to sowing of seeds or flowering of soybean. 

