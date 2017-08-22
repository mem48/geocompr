devtools::install_github("r-spatial/mapedit")
devtools::install_github("ropensci/pdftools")
devtools::install_github("bhaskarvk/leaflet.extras")
library(raster)
library(sf)

u = "https://github.com/Robinlovelace/geocompr/files/1241093/17_02730_FU-REV._SITE_LAYOUT_-_EXTERNAL_WORKS-1993244.pdf"
download.file(url = u, destfile = "site-plan.pdf")
img = pdftools::pdf_convert(pdf = "site-plan.pdf", dpi = 50)
b = brick("site-plan_1.png")
r = raster("site-plan_1.png")
plotRGB(b) # check result - looks OK
study_area = tmaptools::bb("Barrack Road, Leeds")
study_area_polygon = stplanr::bb2poly(study_area)
new_area_approx = mapedit::editFeatures(study_area_polygon) # Update polygon to go on site
extent(r) = as.numeric(st_bbox(new_area_approx))[c(1, 3, 2, 4)]
crs(r) = "+init=epsg:4326"
library(mapview)
m = mapview(r) 
r_new = mapedit::editMap(m) # draw updated polygon of image bounds
extent(r) = st_bbox(r_new$drawn)[c(1, 3, 2, 4)]
m = mapview(r)
library(leaflet.extras)
leaflet.extras::addDrawToolbar(m@map)
mapview::mapview(r)
