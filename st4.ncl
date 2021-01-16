;************************************************
;LOAD FUNCTIONS
;************************************************

load "read_st4_data.ncl"

;************************************************
;READ DATA
;************************************************

p2010 = read_st4_data("201005")
p2015 = read_st4_data("201512")

;************************************************
;CREATE PLOT
;************************************************

wks = gsn_open_wks("x11", "st4") ;Open a workstation
gsn_define_colormap(wks, "colormap_precip_16levs") ;Set the workstation colormap

res                 = True ;Set resources

;GSN resources
;res@gsnMaximize     = True ;Maximize the plot in the workstation
res@gsnDraw         = False ;Do not draw
res@gsnFrame        = False ;Do not advance frame
res@gsnAddCyclic    = False ;Set to false for non-global data
res@gsnRightString  = "" ;No right string

;Contour resources
res@cnFillOn              = True ;Filled contours on
res@cnLinesOn             = False ;No contour lines
res@cnLineLabelsOn        = False ;No line labels
res@cnInfoLabelOn         = False ;No contour range label
res@cnLevelSelectionMode  = "ExplicitLevels" ;User-defined contour levels
res@cnLevels              = fspan(1.0, 16.0, 16) ;Specify the contour levels in INCHES
res@cnFillMode            = "AreaFill" ;Set to "CellFill" for quickest plotting"
;res@cnMissingValFillColor = "grey" ;Show regions with missing values as grey
;res@cnFillPalette         = "WhiteBlueGreenYellowRed" ;Specify the color palette

;Label bar resources
res@lbLabelBarOn = False ;Turn off individual label bars

;Tickmarck resources
res@pmTickMarkDisplayMode = "Always" ;Turn on tickmarks

;Map resources
res@mpDataBaseVersion     = "MediumRes"
res@mpOutlineBoundarySets = "GeophysicalAndUSStates"
res@mpProjection          = "Mercator"
res@mpLimitMode           = "LatLon"
res@mpMinLatF             = 29
res@mpMaxLatF             = 39
res@mpMinLonF             = -94
res@mpMaxLonF             = -80
res@mpFillOn              = False ;No land fill

;res@mpGridAndLimbOn       = True ;Draw grid lines
;res@mpGridLatSpacingF     = 2
;res@mpGridLonSpacingF     = 2
;res@mpGridLineColor       = "lightgrey"
;res@mpGridLineDashPattern = 6 ;Choose the grid line pattern (https://www.ncl.ucar.edu/Document/Graphics/Images/dashpatterns.png)

plot = new(2, graphic) ;Assign a new graphic variable of length 2

res@gsnLeftString   = "48-h accum. precip. (in) ending 0000 UTC 03 May 2010" ;Set left string
plot(0) = gsn_csm_contour_map(wks, p2010(:,:), res)

res@gsnLeftString   = "168-h accum. precip. (in) ending 0000 UTC 29 Dec 2015" ;Set left string
plot(1) = gsn_csm_contour_map(wks, p2015(:,:), res)

;Set resources for the panel plot
resP                  = True
resP@gsnPanelLabelBar = True ;Add a common colorbar
resP@pmLabelBarWidthF = 0.8

gsn_panel(wks, plot, (/1,2/), resP) ;Draw a 1 row, 2 column panel plot
