#!/bin/bash
#SBATCH -J prep_wind_for_ww3
#SBATCH -N 1               # nodes number
#SBATCH -n 1               # CPUs number (on all nodes)
#SBATCH -o output_prep_wind_for_ww3.eo%j
#SBATCH -e output_prep_wind_for_ww3.eo%j
#SBATCH -t 01:00:00        # time limit

# --------------------------------------------------
# -- load Meso-NH/SurfEx environment variables
# --------------------------------------------------
#export ECCODES_DEFINITION_PATH=${SRC_MESONH}/src/LIB/eccodes-2.18.0/definitions/

# NOM : grib_to_netcdf_uv10_propre.sh

# DESCRIPTION : Convert grib to netcdf
# (with all the forecast time choosen)

# APPEL : get_and_convert_grib_to_nc.sh

# input GRIB files location
#dirin=/scratch/work/biellis/WAVE  # /home/users/bielli/xp/RARE/9COV
#dirin=/scratch/work/tulet/ECMWF
dirin=../era5/

# "radical" of GRIB file
#file=ecmwa.OD
file=era5

# output NETCDF files location / make sure the directory exist
#dirout=/home/users/bielli/GRIB_TO_NC/BEJISA_9CIH_test

# Days
#dates='20131230 20131231'
#dates='20190310 20190311 20190312 20190313 20190314 20190315 20190316 20190317 20190318 20190319 20190320 20190321 20190322 20190323 20190324 20190325 20190326 20190327'
#dates='20200201 20200202 20200203 20200204 20200205 20200206 20200207 20200208 20200209 20200210'
dates='20210914 20210915'

# Reseaux
hours='00 06 12 18'
#hours='12'

# Hours of the forecast (with 2 characters)
forecast='00'

# Name of output_file
#fileout='wind_20190310_20190327.nc'
fileout='wind.nc'

# End of part modified by user


############## PART 0 : load library #############################

#module load intel/2018.5.274 
#module load netcdf-c/4.7.1_V2
#module load jasper/1.900.28
#module load eccodes/2.17.0
#module load nco

############## PART 1 : conversion grib to nc #############################


for day in $dates
do
  for hour in $hours
  do
    for fc in $forecast
    do

      # extract the hs variable from the ecmwf file
      #grib_filter filter_wind ${dirin}/${file}.${day}.${hour}.${fc}
      grib_filter filter_wind ${dirin}/${file}.${day}.${hour}
      # convert to netcdf in float
      grib_to_netcdf -D NC_FLOAT ${day}_u10.grib1 -o u10_$day.${hour}.${fc}.nc
      grib_to_netcdf -D NC_FLOAT ${day}_v10.grib1 -o v10_$day.${hour}.${fc}.nc


 # menage
   rm ${day}_*.grib1
   # make record variable (time) unlimited
    ncks -O --mk_rec_dmn time u10_$day.${hour}.${fc}.nc u10_$day.${hour}.${fc}.nc
    ncks -O --mk_rec_dmn time v10_$day.${hour}.${fc}.nc v10_$day.${hour}.${fc}.nc

    done  # end of the forecast hours
  done # end of the "reseaux"
done # end of the days

#
ncrcat u10_????????.??.??.nc u10_cat.nc
ncrcat v10_????????.??.??.nc v10_cat.nc

# menage

rm u10_????????.??.??.nc
rm v10_????????.??.??.nc

############## PART 2 : reformating netcdf file to be compliant with ww3 standard #############################


# get v10 
cp u10_cat.nc ${fileout}
ncks -A -v v10 v10_cat.nc ${fileout}
# create new variable time of type double and 
#unis days since 1900-01-01T00:00:00Z

ncap2 -s 'time2=double(time)/24' ${fileout} uv10_cat_time.nc

# pour conversion latitude/longitude en double

ncap2 -O -s 'latitude2=double(latitude)' uv10_cat_time.nc uv10_cat_time.nc
ncap2 -O -s 'longitude2=double(longitude)' uv10_cat_time.nc uv10_cat_time.nc

# delete attribute

ncatted -O -a units,time2,d,s,"hours since 1900-01-01 00:00:0.0" uv10_cat_time.nc uv10_cat_time2.nc

ncatted -O -a calendar,time2,m,c,"standard" uv10_cat_time2.nc 

# create new attribute units

ncatted -O -a units,time2,c,c,"days since 1900-01-01T00:00:00Z" uv10_cat_time2.nc

# remove old time variable and latitude/longitude

ncks -C -x -v time,latitude,longitude uv10_cat_time2.nc uv10_cat_time3.nc

# rename time2 in time

ncrename -O -v time2,time uv10_cat_time3.nc uv10_cat_time3.nc

# rename variable name and attribute longname

ncatted -O -a long_name,u10,m,c,"u10m" uv10_cat_time3.nc uv10_cat_time3.nc
ncatted -O -a long_name,v10,m,c,"v10m" uv10_cat_time3.nc uv10_cat_time3.nc

ncrename -O -v u10,u10m uv10_cat_time3.nc uv10_cat_time3.nc
ncrename -O -v v10,v10m uv10_cat_time3.nc uv10_cat_time3.nc


ncatted -O -a standard_name,latitude2,c,c,"latitude" uv10_cat_time3.nc uv10_cat_time3.nc
ncatted -O -a axis,latitude2,c,c,"Y" uv10_cat_time3.nc uv10_cat_time3.nc
ncatted -O -a standard_name,longitude2,c,c,"longitude" uv10_cat_time3.nc uv10_cat_time3.nc
ncatted -O -a axis,longitude2,c,c,"X" uv10_cat_time3.nc uv10_cat_time3.nc

ncrename -O -v latitude2,latitude uv10_cat_time3.nc uv10_cat_time3.nc
ncrename -O -v longitude2,longitude uv10_cat_time3.nc uv10_cat_time3.nc

# invert order of latitude

ncpdq -O -a -latitude uv10_cat_time3.nc uv10_cat_time3.nc


mv uv10_cat_time3.nc ${fileout}

# menage
rm uv10_cat_time.nc
rm uv10_cat_time2.nc
rm u10_cat.nc
rm v10_cat.nc
