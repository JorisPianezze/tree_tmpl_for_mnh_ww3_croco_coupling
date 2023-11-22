#!/bin/sh
#######################################################
#SBATCH -J ww3_prnc
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -o output_ww3_prnc.eo%j
#SBATCH -e output_ww3_prnc.eo%j
#SBATCH -t 03:00:00
#######################################################

ulimit -s unlimited
ulimit -c 0

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Executable directory
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
export dir_exe_ww3=/home/piaj/03_workdir/2J_devel_MNH_WW3_CROCO/models/WW3/model/exe_SANSOASIS

########################################################
# ~~~~
#
echo ' '
echo 'Run ww3_prnc program'
time mpirun -np 1 ${dir_exe_ww3}/ww3_prnc | tee ww3_prnc.out
#
# ~~~~
########################################################
