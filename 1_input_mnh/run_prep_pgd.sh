#!/bin/bash
#######################################################
#SBATCH -J PREP_PGD 
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

ln -sf ${PREP_PGD_FILES}/CLAY_HWSD_MOY.??? .
ln -sf ${PREP_PGD_FILES}/SAND_HWSD_MOY.??? .
ln -sf ${PREP_PGD_FILES}/gtopo30.??? .
ln -sf ${PREP_PGD_FILES}/ECOCLIMAP_v2.0.??? .

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#--
time mpirun -np 1 PREP_PGD${XYZ} | tee output_PREP_PGD.out
#--
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
