#!/usr/bin/python
# -*- coding: utf-8 -*-
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
import scipy
from   pylab import *
import os
import glob
import datetime
#
import integrate
#
curdir_path = os.getcwd()+'/'
home_path   = os.environ['HOME']
#
print('###   Dossier courant:', curdir_path)
#
print('###')
print('##############################################')

cfg_debug         = False
cfg_ind_time_strt = 0
cfg_name_file     = 'mercator_data_20210915_20210917.nc'
#cfg_ind_time_strt = 3

if cfg_debug : print('++++++++++++++++++++++++++++++++++++++++++++++')
if cfg_debug : print('+++                                           ')
if cfg_debug : print('+++   0. Recuperaton des variables            ')
if cfg_debug : print('+++                                           ')
if cfg_debug : print('++++++++++++++++++++++++++++++++++++++++++++++')

if cfg_debug : print('----------------------------------------------')
if cfg_debug : print('---   0.1 Initialisation des variables        ')
if cfg_debug : print('----------------------------------------------')

file_mercator = netCDF4.Dataset(curdir_path+cfg_name_file)

if cfg_debug : print('nlon_MNH  = ', nlon_MNH)
if cfg_debug : print('nlat_MNH  = ', nlat_MNH)
if cfg_debug : print('nalt_MNH  = ', nalt_MNH)
if cfg_debug : print('ntime_MNH = ', ntime_MNH)

if cfg_debug : print('----------------------------------------------')
if cfg_debug : print('---   0.2 Lecture et stockage des variables   ')
if cfg_debug : print('----------------------------------------------')

lon_mercator   = file_mercator.variables['longitude'][:] ; nlon_mercator   = np.size(lon_mercator)
lat_mercator   = file_mercator.variables['latitude'][:]  ; nlat_mercator   = np.size(lat_mercator)
depth_mercator = file_mercator.variables['depth'][:]     ; ndepth_mercator = np.size(depth_mercator)
time_mercator  = file_mercator.variables['time'][:]      ; ntime_mercator  = np.size(time_mercator)

# conversion seconds since ref en days since ref
days_since_ref=(datetime.datetime.utcnow() - datetime.datetime(1970,1,1)).days

time_mercator=file_mercator.variables['time']
time_new = netCDF4.num2date(time_mercator[:],units=time_mercator.units,calendar=time_mercator.calendar)

delta_since_ref=(time_new-datetime.datetime(1979, 1, 1, 0, 0, 0, 0))

days_since_ref=np.zeros((np.size(time_new)))
for ind_time in range(np.size(time_new)):
  days_since_ref[ind_time]=delta_since_ref[ind_time].days+delta_since_ref[ind_time].seconds/86400.0

temp_mercator = file_mercator.variables['thetao'][:,:,:,:]
salt_mercator = file_mercator.variables['so'][:,:,:,:]
u_mercator    = file_mercator.variables['uo'][:,:,:,:]
v_mercator    = file_mercator.variables['vo'][:,:,:,:]
ssh_mercator  = file_mercator.variables['zos'][:,:,:]

ubar_mercator = u_mercator[:,0,:,:]-u_mercator[:,0,:,:] #np.zeros((ntime_mercator,nlat_mercator,nlon_mercator))
vbar_mercator = v_mercator[:,0,:,:]-v_mercator[:,0,:,:] #np.zeros((ntime_mercator,nlat_mercator,nlon_mercator))

# depth_mercator_3D_ubar=np.zeros((ntime_mercator,nlat_mercator,nlon_mercator))
# depth_mercator_3D_vbar=np.zeros((ntime_mercator,nlat_mercator,nlon_mercator))

# # for ind_tim in xrange(ntime_mercator):
# #   print('ind_tim = ', ind_tim
# #   for ind_lon in xrange(nlon_mercator):
# #     for ind_lat in xrange(nlat_mercator):
# int_ubar=ubar_mercator
# int_vbar=vbar_mercator

ubar_mercator=integrate.integrate(nlon_mercator,nlat_mercator,ndepth_mercator,ntime_mercator,depth_mercator,u_mercator)
vbar_mercator=integrate.integrate(nlon_mercator,nlat_mercator,ndepth_mercator,ntime_mercator,depth_mercator,v_mercator)

print('np.shape(ubar_mercator)=', np.shape(ubar_mercator))
print('np.shape(vbar_mercator)=', np.shape(vbar_mercator))

#print('ubar_mercator=', ubar_mercator

# test_loop=0
# for ind_tim in xrange(ntime_mercator):
#   print('--> traitement du temps :', ind_tim
#   for ind_dpt in xrange(ndepth_mercator-1):
#     for ind_lat in xrange(nlat_mercator-1):
#       for ind_lon in xrange(nlon_mercator-1):     
#         test_loop=test_loop+1

# print('ntime_mercator*ndepth_mercator*nlat_mercator*nlon_mercator = : ', ntime_mercator*ndepth_mercator*nlat_mercator*nlon_mercator
# print('test boucle            = : ', test_loop

# #
# for ind_tim in xrange(ntime_mercator):
#   print('--> traitement du temps :', ind_tim
#   for ind_dpt in xrange(ndepth_mercator-1):
#     for ind_lat in xrange(nlat_mercator-1):
#       for ind_lon in xrange(nlon_mercator-1):     
#         if (ma.is_masked(u_mercator[ind_tim,ind_dpt+1,ind_lat,ind_lon]) or ma.is_masked(u_mercator[ind_tim,ind_dpt,ind_lat,ind_lon])):
#           ubar_mercator[ind_tim,ind_lat,ind_lon]=ubar_mercator[ind_tim,ind_lat,ind_lon]+0.0
#         else:
#           ubar_mercator[ind_tim,ind_lat,ind_lon]=ubar_mercator[ind_tim,ind_lat,ind_lon]+\
#                                                  abs(depth_mercator[ind_dpt+1]-depth_mercator[ind_dpt])*\
#                                                  (u_mercator[ind_tim,ind_dpt+1,ind_lat,ind_lon]-u_mercator[ind_tim,ind_dpt,ind_lat,ind_lon])
#           depth_mercator_3D_ubar[ind_tim,ind_lat,ind_lon]=depth_mercator[ind_dpt+1]

#         if (ma.is_masked(v_mercator[ind_tim,ind_dpt+1,ind_lat,ind_lon]) or ma.is_masked(v_mercator[ind_tim,ind_dpt,ind_lat,ind_lon])):
#           vbar_mercator[ind_tim,ind_lat,ind_lon]=vbar_mercator[ind_tim,ind_lat,ind_lon]+0.0         
#         else:           
#           vbar_mercator[ind_tim,ind_lat,ind_lon]=vbar_mercator[ind_tim,ind_lat,ind_lon]+\
#                                                  abs(depth_mercator[ind_dpt+1]-depth_mercator[ind_dpt])*\
#                                                  (v_mercator[ind_tim,ind_dpt+1,ind_lat,ind_lon]-v_mercator[ind_tim,ind_dpt,ind_lat,ind_lon])
#           depth_mercator_3D_vbar[ind_tim,ind_lat,ind_lon]=depth_mercator[ind_dpt+1]                                                 

# ubar_mercator[:,:,:]=ubar_mercator[:,:,:]/abs(depth_mercator_3D_ubar[:,:,:])
# vbar_mercator[:,:,:]=vbar_mercator[:,:,:]/abs(depth_mercator_3D_vbar[:,:,:])

# print('boucle finie'
# a=b+c

if cfg_debug : print('++++++++++++++++++++++++++++++++++++++++++++++')
if cfg_debug : print('+++                                           ')
if cfg_debug : print('+++   1. Creation du netcdf                   ')
if cfg_debug : print('+++                                           ')
if cfg_debug : print('++++++++++++++++++++++++++++++++++++++++++++++')

#====================================================
#===   1.0 Create the netcdf restart file
#====================================================
fout=netCDF4.Dataset(curdir_path+'mercator_'+str(days_since_ref[cfg_ind_time_strt])+'.cdf','w',format='NETCDF3_64BIT')
fout.Description='netcdf file converted from '+cfg_name_file

#====================================================
#===   1.1 Create the dimensions
#====================================================
fout.createDimension ('lonT',  nlon_mercator)
fout.createDimension ('latT',  nlat_mercator)
fout.createDimension ('lonU',  nlon_mercator)
fout.createDimension ('latU',  nlat_mercator)
fout.createDimension ('lonV',  nlon_mercator)
fout.createDimension ('latV',  nlat_mercator)
fout.createDimension ('depth', ndepth_mercator)
fout.createDimension ('time',  None )

# Longitude
varout=fout.createVariable('lonT','d',('lonT') )
varout=fout.createVariable('lonU','d',('lonU') )
varout=fout.createVariable('lonV','d',('lonV') )

# Latitude
varout=fout.createVariable('latT','d',('latT') )
varout=fout.createVariable('latU','d',('latU') )
varout=fout.createVariable('latV','d',('latV') )

# depth
varout=fout.createVariable('depth','d',('depth') )

# Time
varout=fout.createVariable('time','d',('time') )
varout.long_name = "time"
varout.calendar  = "proleptic_gregorian"
varout.units     = "days since 1-Jan-1979 00:00:0.0"


#====================================================
#===   1.2 Create the variables
#====================================================
varout=fout.createVariable('temp','d',('time','depth','latT','lonT'), fill_value=NaN )
varout=fout.createVariable('salt','d',('time','depth','latT','lonT'), fill_value=NaN )
varout=fout.createVariable('u'   ,'d',('time','depth','latU','lonU'), fill_value=NaN )
varout=fout.createVariable('v'   ,'d',('time','depth','latV','lonV'), fill_value=NaN )
varout=fout.createVariable('ubar','d',('time',        'latU','lonU'), fill_value=NaN )
varout=fout.createVariable('vbar','d',('time',        'latV','lonV'), fill_value=NaN )
varout=fout.createVariable('ssh' ,'d',('time',        'latT','lonT'), fill_value=NaN )

#====================================================
#===   1.3 Write out the data arrays into the file
#====================================================
fout.variables['time'][:]  = days_since_ref[cfg_ind_time_strt::]
fout.variables['depth'][:] = depth_mercator[:]
fout.variables['latT'][:]  = lat_mercator[:]
fout.variables['lonT'][:]  = lon_mercator[:]
fout.variables['latU'][:]  = lat_mercator[:]
fout.variables['lonU'][:]  = lon_mercator[:]
fout.variables['latV'][:]  = lat_mercator[:]
fout.variables['lonV'][:]  = lon_mercator[:]

fout.variables['temp'][:,:,:] = temp_mercator[cfg_ind_time_strt::,:,:,:]
fout.variables['salt'][:,:,:] = salt_mercator[cfg_ind_time_strt::,:,:,:]
fout.variables['u'][:,:,:]    = u_mercator[cfg_ind_time_strt::,:,:,:]
fout.variables['v'][:,:,:]    = v_mercator[cfg_ind_time_strt::,:,:,:]
fout.variables['ubar'][:,:,:] = ubar_mercator[cfg_ind_time_strt::,:,:]
fout.variables['vbar'][:,:,:] = vbar_mercator[cfg_ind_time_strt::,:,:]
fout.variables['ssh'][:,:,:]  = ssh_mercator[cfg_ind_time_strt::,:,:]

#====================================================
#===   1.4 Close the netcdf file
#====================================================
fout.close()

print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&')
print('&&&                                           ')
print('&&&   Fin                                     ')
print('&&&                                           ')
print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&')
