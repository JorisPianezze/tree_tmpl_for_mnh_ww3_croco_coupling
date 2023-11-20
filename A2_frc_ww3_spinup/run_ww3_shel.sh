#!/bin/sh
#######################################################
#SBATCH -J ww3_shel
#SBATCH -N 1               # nodes number
#SBATCH -n 1               # CPUs number (on all nodes)
#SBATCH -o output_ww3_grid.eo%j
#SBATCH -e output_ww3_grid.eo%j
#SBATCH -t 03:00:00        # time limit
#SBATCH -p normal256
#######################################################

ulimit -s unlimited
ulimit -c 0

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Executable directory
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
export dir_exe_ww3=../../models/ww3_v7-12/model/exe_SANSOASIS

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Input files
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~ WW3
ln -sf ../2_input_ww3/mod_def.ww3 . 
ln -sf ../2_input_ww3/mapsta.ww3 . 
ln -sf ../2_input_ww3/mask.ww3 . 
ln -sf ../2_input_ww3/ST4TABUHF2.bin . 
ln -sf ../2_input_ww3/wind.ww3 . 
ln -sf ../2_input_ww3/nest.ww3 . 

ln -sf ../2_input_ww3/ww3_shel.nml_A2_frc_ww3_spinup ww3_shel.nml

########################################################
# ~~~~
#
mpirun -np 4 $dir_exe_ww3/ww3_shel | tee ww3_shel.out
#
# ~~~~
########################################################
