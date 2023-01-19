### extract mean temperature time-series from ECMWF/ERA5/DAILY, using GEE
# R
# rgee::ee_install()
# rgee::ee_check()
# rgee::ee_Initialize() ## google earth account

R
library(data.table)
library(sf)
library(meteor)
library(reticulate)
library(rgee)
library(ggplot2)
library(patchwork)

## load data
soy_dt <- fread("[data] Cunha et al. MS_soybean [date_photoperiod].csv")
soy_dt_u <- unique(soy_dt[!(is.na(date1) | date1 == ""), ])
soy_dt_u[ , ':=' (date1 = as.Date(date1, format = "%d/%m/%Y"), date2 = as.Date(date2, format = "%d/%m/%Y"))] 
soy_dt_u[ , sowing_date := date1]
soy_dt_u[event == 'flowering', sowing_date := date1-50]

## photoperiod 50d
photoperiod_site <- data.table()

for (i in seq_along(soy_dt_u$date1)) {
    d.1 <- as.integer(format(soy_dt_u$sowing_date[i], "%j"))
    d.2 <- d.1 + 50
    photoperiod_res <- data.table(daylength = unlist(meteor::photoperiod(d.1:d.2, soy_dt_u$latitude[i])))
    photoperiod_res[, day := seq_len(.N)]
    photoperiod_res[, study_ID := soy_dt_u$study_ID[i]]
    photoperiod_res[, latitude := soy_dt_u$latitude[i]]
    photoperiod_site <- rbind(photoperiod_site, photoperiod_res)
}

photoperiod_site[, latitude_abs := abs(latitude)]
photoperiod_site[, latitude_label := factor(paste0(round(latitude_abs, 2), "\u00B0"), levels = unique(paste0(sort(round(latitude_abs, 2)),"\u00B0")))]


## temperature via Google Earth Engine
aoi <- st_as_sf(soy_dt_u[, .(study_ID, longitude, latitude)], coords = c("longitude", "latitude"), crs = 4326)

mean_temp <- data.table()

for(i in seq_along(soy_dt_u$sowing_date)){

early <- ee$Date(as.character(soy_dt_u$sowing_date[i]))
late <- ee$Date(early)$advance(+150, "day")

# Map$centerObject(sf_as_ee(aoi[i, ]), zoom = 8)
# Map$addLayer(
#     eeObject = sf_as_ee(aoi[i,]),
#     visParams = list(pointRadius = 200, color = "FF0000"),
#     name = paste0("study_ID-", aoi[i, ]$study_ID)
#     )

## Load in image collection and filter by area and date
era5_dat <- ee$ImageCollection('ECMWF/ERA5/DAILY')$
            filterDate(early, late)$
            select('mean_2m_air_temperature')

##Create variables and extract data
scale <- era5_dat$first()$projection()$nominalScale()$multiply(0.05)
era5_dat <- era5_dat$filter(ee$Filter$listContains('system:band_names', era5_dat$first()$bandNames()$get(0)));
ee_temp <- ee_extract(x = era5_dat, y = aoi[i, "geometry"], sf = FALSE)
ee_temp_c <- data.frame(date = as.Date(substr(names(ee_temp), 2, 9), format = "%Y%m%d"), temp = as.numeric(round(ee_temp - 274.15, 2)))
ee_temp_c$study_ID <- aoi[i, ]$study_ID
ee_temp_c$day <- seq_along(ee_temp_c$date)
ee_temp_c$latitude <- st_coordinates(aoi[i, "geometry"])[,"Y"]
mean_temp <- rbind(mean_temp, data.table(ee_temp_c))
}

mean_temp <- mean_temp[, latitude_abs := abs(latitude)][order(latitude_abs), ]
fwrite(mean_temp, "study_mean_temperature_150d.csv")

mean_temp <- fread("study_mean_temperature_150d.csv")
mean_temp <- mean_temp[order(study_ID, latitude_abs, day), ][, cum_temp := cumsum(temp), by = .(study_ID, latitude_abs)]
mean_temp[is.na(day), ]

mt_gg <- ggplot(mean_temp) +
            geom_point(aes(x = day, y = temp, group = latitude_abs, colour = latitude_abs), cex = 0.5) +
            geom_line(aes(x = day, y = temp, group = latitude_abs, colour = latitude_abs)) +
            scale_color_gradient2(breaks = c(10,20,30,40), labels = paste0(c(10,20,30,40),"\u00B0"), 
                name = "abs(Latitude)", low = "#f13615", mid = 'yellow', high = "#2f2ff5", midpoint = 22) +
            geom_smooth(data = subset(mean_temp, latitude_abs <= 30), 
                        aes(x = day, y = temp),
                        method = "loess", formula = y ~ x, 
                        color = "#9e1316") + 
            geom_smooth(data = subset(mean_temp, latitude_abs > 30),
                        aes(x = day, y = temp), 
                        method = "loess", formula = y ~ x, 
                        color = "#3563a8") + 
            annotate("rect", xmin = c(40), xmax = c(55),
                  ymin = -Inf, ymax = Inf, alpha = 0.1, fill = c("#7a942e"),
                  color = "grey85",
                  linetype = 2) +
            annotate("text", x = 157, y = mean(unlist(mean_temp[latitude_abs <= 30 & day > 147, "temp"])),
                     label = "< 30\u00B0 lat", color = "#9e1316", fontface = "bold") +
            annotate("text", x = 157, y = mean(unlist(mean_temp[latitude_abs > 30 & day > 147, "temp"])),
                     label = "> 30\u00B0 lat", color = "#3563a8", fontface = "bold") +
            annotate("text", x = 1, y = 7,
                     label = "Planting", color = "grey25", 
                     fontface = "bold",
                     hjust = 0) +
            annotate("text", x = 41, y = 7,
                     label = "Flowering", color = "grey25", 
                     fontface = "bold",
                     hjust = 0) +
            xlim(1, 157) +
            ylim(-1,35) + 
            xlab("Day after planting") +
            ylab("Mean Temperature (\u00B0C)") +
            theme_bw() +
            theme(legend.position = c(0.85,0.9),
                legend.direction = "horizontal") +
            guides(colour = guide_colourbar(title.position = "top"))
 
pp_gg <- ggplot(data = photoperiod_site) +
    geom_boxplot(aes(x = latitude_label, y = daylength, fill = latitude_abs)) +
    scale_fill_gradient2(breaks = c(10,20,30,40), labels = paste0(c(10,20,30,40),"\u00B0"), 
        name = "abs(Latitude)", low = "#f13615", mid = 'yellow', high = "#2f2ff5", midpoint = 22) +
    xlab("abs(Latitude)") +
    ylab("Day length (h)") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 0, vjust = 1)) +
    theme(legend.position = "null") +
    guides(fill = guide_colourbar(title.position = "top"))

patched <- (mt_gg / pp_gg) 
p_fig <- patched + plot_annotation(tag_levels = c("A"), 
                            tag_prefix = "(", tag_sep = ".",
                            tag_suffix = ")") 
                            
ggsave(file = "meantemp150d_photoperiod50d.svg", plot = p_fig, width = 10, height = 12)

pdf(file = "meantemp150d_photoperiod50d.pdf",width = 10, height = 12)
p_fig
dev.off()

png(file = "meantemp150d_photoperiod50d.png", 
    width = 10, height = 12, units = "in", res = 300)
p_fig
dev.off()