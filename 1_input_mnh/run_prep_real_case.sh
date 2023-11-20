#!/bin/bash
#######################################################
#SBATCH -J PREP_REAL_CASE 
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
# -- PREP_REAL_CASE
# --------------------------------------------------

export YEAR='2021'
export MONTH='09'

for DAY in '15'
do
  for HOUR in '00' '06'
  do

    echo '======================================='
    echo ' Treatment of the date' $YEAR$MONTH$DAY 'at' $HOUR'h'
    echo '======================================='

    ln -sf ../../input_models/mnh/ecmwf/ecmwf.$YEAR$MONTH$DAY.$HOUR .

    cp PRE_REAL1.nam_tmpl PRE_REAL1.nam

    sed -i "s/YEAR/$YEAR/g" PRE_REAL1.nam
    sed -i "s/MONTH/$MONTH/g" PRE_REAL1.nam
    sed -i "s/DAY/$DAY/g" PRE_REAL1.nam
    sed -i "s/HOUR/$HOUR/g" PRE_REAL1.nam

    time mpirun -np 1 PREP_REAL_CASE${XYZ} | tee output_PREP_REAL_CASE_${YEAR}${MONTH}${DAY}${HOUR}.out

    mv OUTPUT_LISTING0 OUTPUT_LISTING0_${YEAR}${MONTH}${DAY}${HOUR}
    mv PRE_REAL1.nam PRE_REAL1.nam_${YEAR}${MONTH}${DAY}${HOUR}
    
  done
done
