
### R Script and related files used to analyze and plot the data associated with the article entitled 
### "Soybean dependence on biotic pollination decreases with latitude"
### submitted for consideration for publication by 
### Nicolay Leme da Cunha, Natacha P. Chacoff, Agustín Sáez, 
### Reto Schmucki, Leonardo Galetto, Mariano Devoto, 
### Julieta Carrasco, Mariana P. Mazzei, Silvio Egunio Castillo, 
### Tania Paula Palacios, José Luis Vesprini, Kayna Agostini, 
### Antônio Saraiva, Ben Woodcock, 
### Jeff Ollerton and Marcelo Adrián Aizen 


The dataset consists in two files

1) "[data] Cunha et al. MS_soybean.xlsx", which is an excel file containing two sheets,
	"data" and "data_map". All available data for running the models in the R script 
	"[R script] Cunha et al. MS_soybean.R"

	in "data" sheet there are the variables: 
			Value = log_ratios
			Lat = latitude in decimal degrees
			Variable = yield component
			Treatment = treatment type for comparing pollinator dependence
			Reference_Data_owner = study ID where the data was obtained
			Site = site within the study where each field experiment was performed

	in "data_map" sheet there are the information necessary for plotting the geographical distribution of the used studies:
			Reference_Data_owner = study ID where the data was obtained
			Country = country where the study was performed
			Province = province where the study was performed
			Locality/Farm = locality where the study was performed
			Lat = latitude in decimal degrees
			Long = longitude in decimal degrees


2) "[data] Cunha et al. MS_soybean [date_photoperiod].csv", which is an coma separated file, 
	containing the necessary information to be used in the R script 
	"[R script] Cunha et al. AGEE - gee_temp_ts_extract.R" and make Figure S2.
	The dataset contains the following variables:
			study_ID = study ID number where the data was obtained
			study_ref = study ID where the data was obtained
			latitude = latitude in decimal degrees
			longitude = longitude in decimal degrees
			date1 = date of the sowing or flowering when the experiment was done
			date2 = a second date, when available, of the sowing or flowering when the experiment was done
			event = if the date was related to the sowing of seeds or flowering of soybean. 


