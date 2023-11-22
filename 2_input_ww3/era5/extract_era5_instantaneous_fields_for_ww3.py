#!/bin/python
# --------------------------------------------------------
#
#                 Author  (    date    ) :
#             J. Pianezze ( 14.08.2023 )
#
#                    ~~~~~~~~~~~~~~~
#       Script used to extract ERA5 instantaneous fields
#  for Meso-NH (PREP_REAL_CASE) or ABL1d (preprocessing tools)
#                    (1 time / file)
#                    ~~~~~~~~~~~~~~~
#
# --------------------------------------------------------
# https://cds.climate.copernicus.eu/api-how-to
# conda install cdsapi

import os, sys
import glob
import cdsapi
import datetime

cds = cdsapi.Client()

# #########################################################
# ###           To be defined by user                   ###
# #########################################################

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - -     First and last date to be extracted           - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
first_date_to_be_extracted = datetime.datetime(2021, 9, 14, 0, 0, 0)
last_date_to_be_extracted  = datetime.datetime(2021, 9, 16, 0, 0, 0)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - -          Type of data to be extracted             - -
# - -         analyses (an) or forecast (fc)            - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
type_data_to_be_extracted = 'an'

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - -     period_in_hr between two forcing files        - -
# - -          must be a multiple of 6                  - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
period_between_last_and_first_dates_in_hr = 6

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - -     Area to be extracted : 'North/West/South/East'- -
# - -     Benguela    : '-20.0/5.0/-40.0/25.0'          - -
# - -     Gulf Stream : '50.0/-90.0/20.0/-30.0'         - -
# - -     Iroise      : 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
area_to_be_extracted = '55.0/-10.0/40.0/5.0'

# #########################################################

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Define function to iterate over first and last dates
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
def range_for_date(start_date, end_date, period_in_hr):
  for n in range(int((end_date - start_date).total_seconds()/(3600.0*period_in_hr))+1):
    yield start_date + datetime.timedelta(seconds=n*3600.0*period_in_hr)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Loop over dates
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
for date in range_for_date(first_date_to_be_extracted, last_date_to_be_extracted, period_between_last_and_first_dates_in_hr):

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #   Compute date and time variables
  #     date_an format is yyyy-mm-dd
  #     time_an format is hh
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  date_to_be_extracted   = str(date.year)+'-'+str(date.month).zfill(2)+'-'+str(date.day).zfill(2)
  time_to_be_extracted   = str(date.hour).zfill(2)
  name_of_extracted_file = str(date.year)+str(date.month).zfill(2)+str(date.day).zfill(2)+'.'+str(date.hour).zfill(2)

  # Wave parameter
  #
  #cat <<EEOOFF > request_$GRDATIM
  #RETRIEVE,
  # CLASS=$CLASS,
  # STREAM=WAVE,
  # EXPVER=$EXPVER,
  # TYPE=${SURF_TYPE},
  # DATE=$DATE,
  # TIME=$TIME,
  # STEP=$STEPS,
  # TARGET=$OUTFILE,
  # AREA=$AREA,
  # GRID=$GRID,
  # PARAM=251.140,
  # DIRECTION=1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18/19/20/21/22/23/24/25/26/27/28/29/30/31/32/33/34/35/36,
  # FREQUENCY=1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18/19/20/21/22/23/24/25/26/27/28/29/30/31/32/33/34/35/36
  # EEOOFF
#

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #   Retrieve SurFaCe fields : u10, v10
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  cds.retrieve('reanalysis-era5-complete', {
        'date'     : date_to_be_extracted,
        'levtype'  : 'sfc',
        'param'    : '165.128/166.128',
        'stream'   : 'oper',
        'time'     : time_to_be_extracted,
        'type'     : type_data_to_be_extracted,
        'area'     : area_to_be_extracted,
        'grid'     : '0.28125/0.28125',
    },  'surface_levels_'+name_of_extracted_file+'.grib')

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #   Retrieve WAVE fields : spectra
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  cds.retrieve('reanalysis-era5-complete', {
      'date'     : date_to_be_extracted,
      'param'    : '251.140',
      'stream'   : 'wave',
      'direction': '1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18/19/20/21/22/23/24',
      'frequency': '1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18/19/20/21/22/23/24/25/26/27/28/29/30',
      'time'     : time_to_be_extracted,
      'type'     : type_data_to_be_extracted,
      'area'     : area_to_be_extracted,
      'grid'     : '0.28125/0.28125',
  }, 'wave_'+name_of_extracted_file+'.grib')

  #'direction': '1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18/19/20/21/22/23/24/25/26/27/28/29/30/31/32/33/34/35/36',
  #'frequency': '1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18/19/20/21/22/23/24/25/26/27/28/29/30/31/32/33/34/35/36',

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #   Concatenate & remove grib files
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  os.system('grib_copy surface_levels_'+name_of_extracted_file+'.grib '+\
                      'wave_'+name_of_extracted_file+'.grib           '+\
                      'era5.'+name_of_extracted_file)

  for file in glob.glob('*.grib'):
    os.remove(file)
