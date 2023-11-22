#!/usr/bin/python
# -*- coding: utf-8 -*-
# ----------------------------------------------------
#       Auteur (date de creation)
#  J. PIANEZZE (      25.07.2022)
# ----------------------------------------------------
#
print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&')
print('&&&                                           ')
print('&&&   Execution de :                          ')
print('&&&  ',__file__                                )
print('&&&                                           ')
print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&')
#
######################################################
###                                           
import os, sys
import netCDF4
import numpy as np
###                                           
######################################################

cfg_debug = True

if cfg_debug : print('++++++++++++++++++++++++++++++++++++++++++++++')
if cfg_debug : print('+++                                           ')
if cfg_debug : print('+++   0. Lecture des fichiers et des variables')
if cfg_debug : print('+++                                           ')
if cfg_debug : print('++++++++++++++++++++++++++++++++++++++++++++++')

# ---------------------------------------------------------------------
#  Get datasets
# ---------------------------------------------------------------------
file_pgd       = netCDF4.Dataset('../../1_input_mnh/PGD_IROISE_5km.nc')
file_bathy_pgd = netCDF4.Dataset('../../1_input_mnh/PGD_IROISE_5km.nc')

# ---------------------------------------------------------------------
#  Read PGD grid, mask and depth
# ---------------------------------------------------------------------
lon_pgd       = file_pgd.variables['longitude'][1:-1,1:-1]
lat_pgd       = file_pgd.variables['latitude'][1:-1,1:-1]
frac_sea_pgd  = file_pgd.variables['FRAC_SEA'][1:-1,1:-1]
depth_pgd     = file_bathy_pgd.variables['BATHY'][1:-1,1:-1]

# ---------------------------------------------------------------------
#  Create mask for WW3 from FRAC_SEA
# ---------------------------------------------------------------------
mask_pgd        = np.zeros((np.shape(frac_sea_pgd)))
ind             = np.where(frac_sea_pgd>0.0)
mask_pgd[ind]   = 1
mask_pgd[ 0, :] = 2
mask_pgd[-1, :] = 2
mask_pgd[ :, 0] = 2
mask_pgd[ :,-1] = 2

# ---------------------------------------------------------------------
#  Create obst for WW3 from FRAC_SEA
# ---------------------------------------------------------------------
obst_pgd        = np.zeros((np.shape(frac_sea_pgd)))

if cfg_debug : print('++++++++++++++++++++++++++++++++++++++++++++++')
if cfg_debug : print('+++                                           ')
if cfg_debug : print('+++   1. Ecriture des fichiers pour WW3       ')
if cfg_debug : print('+++                                           ')
if cfg_debug : print('++++++++++++++++++++++++++++++++++++++++++++++')

# ---------------------------------------------------------------------
#  Open txt files
# ---------------------------------------------------------------------
file_lon_txt   = open("WW3_IROISE_DX5KM.lon.inp"  , "w")
file_lat_txt   = open("WW3_IROISE_DX5KM.lat.inp"  , "w")
file_bathy_txt = open("WW3_IROISE_DX5KM.bathy.inp", "w")
file_mask_txt  = open("WW3_IROISE_DX5KM.mask.inp" , "w")
file_obst_txt  = open("WW3_IROISE_DX5KM.obst.inp" , "w")

# ---------------------------------------------------------------------
#  Fill txt files
# ---------------------------------------------------------------------
np.savetxt(file_lon_txt  , lon_pgd  , fmt='%.6e')
np.savetxt(file_lat_txt  , lat_pgd  , fmt='%.6e')
np.savetxt(file_bathy_txt, depth_pgd, fmt='%.6e')
np.savetxt(file_mask_txt , mask_pgd , fmt='%i'  )
np.savetxt(file_obst_txt , obst_pgd , fmt='%i'  )
np.savetxt(file_obst_txt , obst_pgd , fmt='%i'  )

# ---------------------------------------------------------------------
#  Close txt files
# ---------------------------------------------------------------------
file_lon_txt.close()
file_lat_txt.close()
file_bathy_txt.close()
file_mask_txt.close()
file_obst_txt.close()

print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&')
print('&&&                                           ')
print('&&&   Fin de :                                ')
print('&&&  ',__file__                                )
print('&&&                                           ')
print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&')
