#!/bin/sh
#######################################################
#SBATCH -J ww3_ounf
#SBATCH -N 1
#SBATCH -n 4
#SBATCH -o output_ww3_ounf.eo%j
#SBATCH -e output_ww3_ounf.eo%j
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
ln -sf ../2_input_ww3/ww3_ounf.nml_A2_frc_ww3_spinup ww3_ounf.nml

########################################################
# ~~~~
#
echo ' '
echo 'Run ww3_ounf program'
time mpirun -np 1 $dir_exe_ww3/ww3_ounf | tee ww3_ounf.out
#
# ~~~~
########################################################
