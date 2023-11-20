#!/bin/sh
#######################################################
#SBATCH -J ww3_ounf
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

ln -sf ../2_input_ww3/ww3_ounf.nml_A2_frc_ww3_spinup ww3_ounf.nml

########################################################
# ~~~~
#
time mpirun -np 1 $dir_exe_ww3/ww3_ounf | tee ww3_ounf.out
#
# ~~~~
########################################################

