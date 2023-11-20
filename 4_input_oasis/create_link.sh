#/bin/bash

ln -sf ../1_input_mnh/rstrt_SAVE.nc rst_A.nc
ln -sf ../3_input_croco/rstrt_SAVE.nc rst_O.nc
ln -sf ../2_input_ww3/rstrt_SAVE.nc rst_W.nc

ln -sf create_rmp_files/create_rmp_files_atmt_ocnt_bilinear/rundir_2_1_1/rmp_atmt_to_ocnt_DISTWGT.nc .
ln -sf create_rmp_files/create_rmp_files_atmt_wavt_bilinear/rundir_2_1_1/rmp_atmt_to_wavt_DISTWGT.nc .

ln -sf create_rmp_files/create_rmp_files_ocnt_atmt_bilinear/rundir_2_1_1/rmp_ocnt_to_atmt_DISTWGT.nc .
ln -sf create_rmp_files/create_rmp_files_ocnt_wavt_bilinear/rundir_2_1_1/rmp_ocnt_to_wavt_DISTWGT.nc .

ln -sf create_rmp_files/create_rmp_files_wavt_atmt_bilinear/rundir_2_1_1/rmp_wavt_to_atmt_DISTWGT.nc .
ln -sf create_rmp_files/create_rmp_files_wavt_ocnt_bilinear/rundir_2_1_1/rmp_wavt_to_ocnt_DISTWGT.nc .
