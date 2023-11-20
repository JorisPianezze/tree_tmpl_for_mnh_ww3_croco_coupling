#!/bin/bash
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++ 
# ++   Script used to download MERCATOR data on CMEMS database
# ++
# ++   author    : J. PIANEZZE
# ++
# ++   original  : 11.02.2019
# ++   last rev. : 17.09.2021 
# ++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# ------------------------------------------------------------------------------- 
# --
# --   Usage :
# --   -------
# --   . extract_mercator_data.sh
# --  
# -------------------------------------------------------------------------------
# --
# --   Documentation :
# --   ---------------
# --   http://marine.copernicus.eu/services-portfolio/access-to-products/?option=com_csw&task=results
# --   
# --   After  31.12.2019 --> Global Ocean 1/12 Physics Analysis and Forecast updated Daily
# --   Before 31.12.2019 --> Gloabl Ocean Physics Reanalysis
# --
# --------------------------------------------------------------------------------
# -- 
# --   Remark :
# --   --------
# --   variables for the ice sheet not downloaded because not necessary for most of configurations
# --   --variable 'siconc' --variable 'sithick' --variable 'usi' --variable 'vsi'
# --
# --------------------------------------------------------------------------------
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#    Use following python command for date after 31.12.2019
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

python -m motuclient --motu https://nrt.cmems-du.eu/motu-web/Motu                  \
                     --service-id GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS         \
                     --product-id global-analysis-forecast-phy-001-024             \
                     --user username       --pwd password                          \
                     --longitude-min -10.0 --longitude-max 5.0                     \
                     --latitude-min   40.0 --latitude-max 55.0                     \
                     --depth-min 0.493     --depth-max 5727.918                    \
                     --variable thetao     --variable bottomT                      \
                     --variable so         --variable zos                          \
                     --variable uo         --variable vo                           \
                     --variable mlotst                                             \
                     --date-min 2021-09-14 12:00:00 --date-max 2021-09-16 12:00:00 \
                     --out-dir ${PWD} --out-name mercator_data_20210915_20210917.nc

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 
#    Use following python command for date before 31.12.2019
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#python -m motuclient --motu https://my.cmems-du.eu/motu-web/Motu                  \
#		     --service-id GLOBAL_REANALYSIS_PHY_001_030-TDS                \
#		     --product-id global-reanalysis-phy-001-030-daily              \
#	             --user username     --pwd password                            \
#		     --longitude-min 0.0 --longitude-max 15.0                      \
#		     --latitude-min 35.0 --latitude-max  50.0                      \
#		     --depth-min 0.493   --depth-max 5727.918                      \
#		     --variable thetao   --variable bottomT                        \
#		     --variable so       --variable zos                            \
#	             --variable uo       --variable vo                             \
#		     --variable mlotst                                             \
#		     --date-min 2018-10-28 12:00:00 --date-max 2018-11-02 12:00:00 \
#		     --out-dir ${PWD} --out-name mercator_data_20181028_20181102.nc


