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
#    Load Meso-NH/SurfEx environment variables
# --------------------------------------------------

. /path/to/your/profile_mesonh

if [ -z ${XYZ} ] ; then
   echo '      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~           '
   echo ' XYZ is not define, please load profile_mesonh'
   echo '      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~           '
   exit
fi

# --------------------------------------------------
#    Link to the data and run PREP_PGD
# --------------------------------------------------

export PREP_PGD_FILES=${PREP_PGD_FILES:-"$HOME/PREP_PGD_FILES_WWW"}

if [ ! -d ${PREP_PGD_FILES} ]
then

   echo 'Your directory PREP_PGD_FILES=$PREP_PGD_FILES doesnt exist.'
   echo 'Please define the location of your PREP_PGD_FILES through'
   echo 'the environment variable PREP_PGD_FILES.'
   exit

else

   ln -sf $PREP_PGD_FILES/CLAY_HWSD_MOY.??? .
   ln -sf $PREP_PGD_FILES/SAND_HWSD_MOY.??? .
   ln -sf $PREP_PGD_FILES/ECOCLIMAP_v2.0.??? .
   ln -sf $PREP_PGD_FILES/gtopo30.??? .
   ln -sf $PREP_PGD_FILES/etopo2.nc .

   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   #--
   time mpirun -np 1 PREP_PGD${XYZ} | tee output_PREP_PGD.out
   #--
   #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fi
