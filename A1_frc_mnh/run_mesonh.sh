#!/bin/bash
#######################################################
#SBATCH -J MESONH 
#SBATCH -N 1         
#SBATCH -n 1
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
# -- link to the data
# --------------------------------------------------

ln -sf ../1_input_mnh/PGD_IROISE_5km.* .
ln -sf ../1_input_mnh/ECMWF_20210915_??.* .
ln -sf ../1_input_mnh/EXSEG1.nam_A1_frc_mnh EXSEG1.nam

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#--
time mpirun -np 1 MESONH${XYZ} | tee output_MESONH.out
#--
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
