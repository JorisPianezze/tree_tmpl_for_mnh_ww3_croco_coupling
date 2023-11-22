#!/bin/sh
#######################################################
#SBATCH -J ww3_shel
#SBATCH -N 1
#SBATCH -n 4
#SBATCH -o output_ww3_shel.eo%j
#SBATCH -e output_ww3_shel.eo%j
#SBATCH -t 03:00:00
#######################################################

ulimit -s unlimited
ulimit -c 0

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Executable directory
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
export dir_exe_ww3=/home/piaj/03_workdir/2J_devel_MNH_WW3_CROCO/models/WW3/model/exe_SANSOASIS


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Input files
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ln -sf ../2_input_ww3/mod_def.ww3 . 
ln -sf ../2_input_ww3/mapsta.ww3 . 
ln -sf ../2_input_ww3/mask.ww3 . 
ln -sf ../2_input_ww3/ST4TABUHF2.bin . 
ln -sf ../2_input_ww3/wind.ww3 . 
#ln -sf ../2_input_ww3/nest.ww3 . 

ln -sf ../2_input_ww3/ww3_shel.nml_A2_frc_ww3_spinup ww3_shel.nml

########################################################
# ~~~~
#
echo ' '
echo 'Run ww3_shel program'
mpirun -np 4 $dir_exe_ww3/ww3_shel | tee ww3_shel.out
#
# ~~~~
########################################################
