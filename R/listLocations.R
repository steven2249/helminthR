#' Lists geographic locations
#' 
#' Lists geographic locations that can be input to `findHost()` or
#' `findParasite()` and the corresponding latitude and longitude coordinates 
#' of the country's centroid. The georeferencing is performed dynamically using 
#' `ggmap` and is potentially incorrect. 
#' 
#' 
#' @return Returns a vector of locations. However, it is important to note that
#' some locations are nested inside of other locations. For instance, you can
#' search for all host-parasite associations in the Great Lakes as a whole, or
#' you can target Lake Ontario specifically. 
#' @author Tad Dallas
#' @references Gibson, D. I., Bray, R. A., & Harris, E. A. (Compilers) (2005).
#' Host-Parasite Database of the Natural History Museum, London. 
#' @examples
#' 
#' \dontrun{listLocations()}
#' 
#' 

listLocations <-function(){
  locationUrl <- html(paste("http://www.nhm.ac.uk/research-curation/scientific-resources/taxonomy-systematics/host-parasites/database/location.jsp?location=&paragroup=&showparasites=on&paraspecies=&fmhostgenus=Contains&fmparagenus=Starts+with&showrefs=on&fmsubgroup=Starts+with&groupby=parasite&pstatus=&showhosts=on&hostspecies=&hostgenus=&paragenus=&fmparaspecies=Starts+with&subgroup=&fmhostspecies=Contains&hstate=&getlocation=select"))

  locations <- locationUrl %>%  
             html_nodes("option") %>%
             html_attr("value")

 if(any(locations == "")){
   loc <- locations[-which(locations == "")]
 }

 loc1 <- vector()
  for(i in 1:length(loc)){
 	 if(any(unlist(strsplit(loc[i],'')) ==":")){
		loc1[i]=sub(' ', '', tail(unlist(strsplit(loc[i], ':')),1))
	 }else{
 	   loc1[i] =loc[i]
 	 }
   }
  latLong <- geocode(loc1)
  ret <- data.frame(Location = loc1, Latitude = latLong[,1], Longitude = latLong[,2])
  return(ret)
}
