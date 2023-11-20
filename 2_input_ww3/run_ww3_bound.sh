#!/bin/sh
#######################################################
#SBATCH -J ww3_bound
#SBATCH -N 1               # nodes number
#SBATCH -n 1               # CPUs number (on all nodes)
#SBATCH -o output_ww3_bound.eo%j
#SBATCH -e output_ww3_bound.eo%j
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
export dir_input_ww3=../../input_models/ww3/spec

ln -sf ${dir_input_ww3}/spectre .
ln -sf ${dir_input_ww3}/ww3_bound.inp .

########################################################
# ~~~~
#
echo ' '
echo 'Lancement de ww3_bound'
time mpirun -np 1 ${dir_exe_ww3}/ww3_bound | tee ww3_bound.out
#
# ~~~~
########################################################
