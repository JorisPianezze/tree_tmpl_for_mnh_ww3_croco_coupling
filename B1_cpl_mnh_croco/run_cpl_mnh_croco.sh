#!/bin/bash
#######################################################
#SBATCH -J MESONH 
#SBATCH -N 1         
#SBATCH -n 2
#SBATCH -o output_PREP_PGD.eo%j
#SBATCH -e output_PREP_PGD.eo%j
#SBATCH -t 01:00:00
#SBATCH -p normal256
#SBATCH  --exclusive
#SBATCH  --no-requeue
#######################################################

ulimit -s unlimited
ulimit -c 0

# --------------------------------------------------
# -- load Meso-NH/SurfEx environment variables
# --------------------------------------------------

. ../../models/MNH-V5-5-0/conf/profile_mesonh

# --------------------------------------------------
# -- link to croco executable
# --------------------------------------------------
export dir_exe_croco=../../models/croco-v1.1/exe_IROISE_1core_CPLOA
ln -sf ${dir_exe_croco}/croco croco.exe

# --------------------------------------------------
# -- link to the data
# --------------------------------------------------

#~~~~~ MESONH
ln -sf ../1_input_mnh/PGD_IROISE_5km.* .
ln -sf ../1_input_mnh/ECMWF_20210915_??.* .
ln -sf ../1_input_mnh/EXSEG1.nam_B_mnh_croco EXSEG1.nam

#~~~~~ CROCO
ln -sf ../3_input_croco/croco_grd.nc .
ln -sf ../3_input_croco/croco_ini_mercator_15597.5.nc croco_ini.nc
ln -sf ../3_input_croco/croco_bry_mercator_15597.5.nc croco_bry.nc
ln -sf ../3_input_croco/croco.in_B_mnh_croco croco.in

#~~~~~ OASIS
ln -sf ../4_input_oasis/namcouple_B_mnh_croco namcouple
cp ../4_input_oasis/rst_A.nc .
cp ../4_input_oasis/rst_O.nc .
cp ../4_input_oasis/rmp*nc .

# ------------------------------
# Simulation
# ------------------------------

#========
#---
time mpirun : -np 1 MESONH${XYZ} : -np 1 ./croco.exe
#---
#========

