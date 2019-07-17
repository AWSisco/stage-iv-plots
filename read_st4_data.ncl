function read_st4_data (dir)
begin

  files = systemfunc("cd "+dir+" ; ls ST4."+dir+"*.06h") ;List files to use
  ;num_files = dimsizes(files) ;Check number of files

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

  return (p_acc)
end
