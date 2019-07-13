;************************************************
;READ DATA
;************************************************

dir = "dec2015" ;Directory where data files are stored
files = systemfunc("cd "+dir+" ; ls ST4.201512*.06h") ;List files to use
num_files = dimsizes(files)

files = str_insert(files, ".grb", -1) ;Append .grb to each file name

all_files = addfiles("./"+dir+"/"+files, "r") ;Open the files for reading using addfiles
ListSetType(all_files, "join") ;Specify "join" mode to read variables arcross files

p_acc = all_files[:]->A_PCP_GDS5_SFC_acc6h ;Extract the data in "join" mode

p_acc := dim_sum_n_Wrap(p_acc, 0) ;Reassign p_acc to be the accumulated precip across all files
;printVarSummary(p_acc)
;printMinMax(p_acc,0)

p_acc = p_acc/25.4 ;Convert from mm to inches

lat2d = all_files[0]->g5_lat_0 ;Extract the latitude coordinate array
lon2d = all_files[0]->g5_lon_1 ;Extract the longitude coordinate array

p_acc@lat2d = lat2d ;Assign the latitude coordinate array to the lat2d attribute
p_acc@lon2d = lon2d ;Assign the longitude coordinate array to the lon2d attribute

;************************************************
;CREATE PLOT
;************************************************

wks = gsn_open_wks("x11", "st4_2015") ;Open a workstation

res                 = True ;Set resources

;GSN resources
res@gsnMaximize     = True ;Maximize the plot in the workstation
res@gsnAddCyclic    = False ;Set to false for non-global data
res@gsnLeftString   = "48-h accum. precip. (in) ending 0000 UTC 03 May 2010" ;Set left string
res@gsnRightString  = "" ;No right string

;Contour resources
res@cnFillOn              = True ;Filled contours on
res@cnLinesOn             = False ;No contour lines
res@cnLineLabelsOn        = False ;No line labels
res@cnInfoLabelOn         = False ;No contour range label
res@cnLevelSelectionMode  = "ExplicitLevels" ;User-defined contour levels
res@cnLevels              = fspan(1.0, 15.0, 15) ;Specify the contour levels in INCHES
;res@cnLevels              = fspan(25.0, 225.0, 17) ;Specify the contour levels in MILLIMETERS
res@cnFillMode            = "AreaFill" ;Set to "CellFill" for quickest plotting"
;res@cnMissingValFillColor = "grey" ;Show regions with missing values as grey
;rgba_partial = span_color_rgba(color_map_name,nlevels)
res@cnFillPalette         = span_color_rgba("WhiteBlueGreenYellowRed", 16)
;res@cnFillPalette         = "WhiteBlueGreenYellowRed" ;Specify the color palette
;res@cnFillPalette         = "bosart_stageIV"

;Tickmarck resources
res@pmTickMarkDisplayMode = "Always" ;Turn on tickmarks

;Map resources
res@mpDataBaseVersion     = "MediumRes"
res@mpOutlineBoundarySets = "GeophysicalAndUSStates"

res@mpProjection          = "Mercator"
;res@mpLambertParallel1F   = 33.0 ;For "LambertConformal" projection only
;res@mpLambertParallel2F   = 45.0
;res@mpLambertMeridianF    = -87.0
res@mpLimitMode           = "LatLon"
res@mpMinLatF             = 29
res@mpMaxLatF             = 39
res@mpMinLonF             = -94
res@mpMaxLonF             = -80
res@mpFillOn              = False ;No land fill

res@mpGridAndLimbOn       = True ;Draw grid lines
res@mpGridLatSpacingF     = 2
res@mpGridLonSpacingF     = 2
res@mpGridLineColor       = "lightgrey"
res@mpGridLineDashPattern = 6 ;Choose the grid line pattern (https://www.ncl.ucar.edu/Document/Graphics/Images/dashpatterns.png)

plot = gsn_csm_contour_map(wks, p_acc(:,:), res)
