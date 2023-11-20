#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
######################################################################
#====================================================================#
# J. Pianezze (date de creation/modification):
# ----------------------------------------
#
# Explication du programme:
# -------------------------
#      Creating restart file from ww3 files : WW3 model
#
# Convention d'ecriture des variables:
# ------------------------------------
#
#   ------------------------------------------------------------------
#        Type                    |     Convention
#   ------------------------------------------------------------------
#        variables               |     ma_variable
#        parametres config.py    |     cfg_mon_param
#   ------------------------------------------------------------------
# 
# Choses a ameliorer:
# -------------------
#
# Langue:
# -------
# - commentaires en francais
# - nom des variables en anglais
#
#=====================================================================#
#######################################################################
#
print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&')
print('&&&                                           ')
print('&&&   Execution de:')
print('&&&   '+__file__)
print('&&&                                           ')
print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&')
#
print('##############################################')
print('###')
#
import netCDF4
import numpy as np
import os
#
curdir_path=os.getcwd()+'/'
home_path=os.environ['HOME']
print('###   Dossier courant:', curdir_path)
#
print('###')
print('##############################################')
#
cfg_debug=False
#
if cfg_debug : print('++++++++++++++++++++++++++++++++++++++++++++++')
if cfg_debug : print('+++                                           ')
if cfg_debug : print('+++   0. Lecture des variables                ')
if cfg_debug : print('+++                                           ')
if cfg_debug : print('++++++++++++++++++++++++++++++++++++++++++++++')

file_WW3 = netCDF4.Dataset(curdir_path+'../A2_frc_ww3_spinup/ww3.20210915.nc')

LON_WW3=file_WW3.variables['longitude'][:,:]
LAT_WW3=file_WW3.variables['latitude'][:,:]

HS_WW3=file_WW3.variables['hs'][-1,:,:]
UCUR_WW3=file_WW3.variables['ucur'][-1,:,:]
VCUR_WW3=file_WW3.variables['vcur'][-1,:,:]
FWS_WW3=file_WW3.variables['tws'][-1,:,:]
TP_WW3=1./file_WW3.variables['fp'][-1,:,:]
CHA_WW3=file_WW3.variables['cha'][-1,:,:]
DIR_WW3=file_WW3.variables['dir'][-1,:,:]

if cfg_debug : print('++++++++++++++++++++++++++++++++++++++++++++++')
if cfg_debug : print('+++                                           ')
if cfg_debug : print('+++   1. Creation du netcdf                   ')
if cfg_debug : print('+++                                           ')
if cfg_debug : print('++++++++++++++++++++++++++++++++++++++++++++++')

nlon_WW3=len(LON_WW3[0,:])
nlat_WW3=len(LAT_WW3[:,0])

print('nlon_WW3', nlon_WW3)
print('nlat_WW3', nlat_WW3)

#====================================================
#===   1.0 Create the netcdf restart file
#====================================================
fout=netCDF4.Dataset(curdir_path+'rstrt_SAVE.nc','w',format='NETCDF3_64BIT')
fout.Description='Restart file for WW3 coupling'

#====================================================
#===   1.1 Create the dimensions of the files
#====================================================
fout.createDimension ('nlat_WW3', nlat_WW3)
fout.createDimension ('nlon_WW3', nlon_WW3)

#====================================================
#===   1.2 Create the variables
#====================================================
varout=fout.createVariable('WW3__OHS','d',('nlat_WW3','nlon_WW3'),fill_value=999.)
varout=fout.createVariable('WW3_T0M1','d',('nlat_WW3','nlon_WW3'),fill_value=999.)
varout=fout.createVariable('WW3__AHS','d',('nlat_WW3','nlon_WW3'),fill_value=999.)
varout=fout.createVariable('WW3_WSSU','d',('nlat_WW3','nlon_WW3'),fill_value=999.)
varout=fout.createVariable('WW3_WSSV','d',('nlat_WW3','nlon_WW3'),fill_value=999.)
varout=fout.createVariable('WW3_ACHA','d',('nlat_WW3','nlon_WW3'),fill_value=999.)
varout=fout.createVariable('WW3__FWS','d',('nlat_WW3','nlon_WW3'),fill_value=999.)
varout=fout.createVariable('WW3__DIR','d',('nlat_WW3','nlon_WW3'),fill_value=999.)

#====================================================
#===   1.3 Write out the data arrays into the file
#====================================================
fout.variables['WW3__OHS'][:,:] = HS_WW3[:,:]
fout.variables['WW3_T0M1'][:,:] = TP_WW3[:,:]
fout.variables['WW3__AHS'][:,:] = HS_WW3[:,:]
fout.variables['WW3_WSSU'][:,:] = 0.0   # UCUR_WW3[:,:]
fout.variables['WW3_WSSV'][:,:] = 0.0   # VCUR_WW3[:,:]
fout.variables['WW3_ACHA'][:,:] = 0.011 # CHA_WW3[:,:]
fout.variables['WW3__FWS'][:,:] = FWS_WW3[:,:]
fout.variables['WW3__DIR'][:,:] = DIR_WW3[:,:]

#====================================================
#===   1.4 Close the netcdf file
#====================================================
fout.close()

print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&')
print('&&&                                           ')
print('&&&   Fin                                     ')
print('&&&                                           ')
print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&')
