#/bin/bash

ln -sf ../1_input_mnh/rstrt_MNH.nc rst_A.nc
ln -sf ../3_input_croco/rstrt_CROCO.nc rst_O.nc
ln -sf ../2_input_ww3/rstrt_WW3.nc rst_W.nc

ln -sf create_rmp_files_for_oasis/create_rmp_files_for_oasis_atmt_ocnt_bilinear/rundir_2_1_1/rmp_atmt_to_ocnt_DISTWGT_4.nc .
ln -sf create_rmp_files_for_oasis/create_rmp_files_for_oasis_atmt_wavt_bilinear/rundir_2_1_1/rmp_atmt_to_wavt_DISTWGT_4.nc .

ln -sf create_rmp_files_for_oasis/create_rmp_files_for_oasis_ocnt_atmt_bilinear/rundir_2_1_1/rmp_ocnt_to_atmt_DISTWGT_4.nc .
ln -sf create_rmp_files_for_oasis/create_rmp_files_for_oasis_ocnt_wavt_bilinear/rundir_2_1_1/rmp_ocnt_to_wavt_DISTWGT_4.nc .

ln -sf create_rmp_files_for_oasis/create_rmp_files_for_oasis_wavt_atmt_bilinear/rundir_2_1_1/rmp_wavt_to_atmt_DISTWGT_4.nc .
ln -sf create_rmp_files_for_oasis/create_rmp_files_for_oasis_wavt_ocnt_bilinear/rundir_2_1_1/rmp_wavt_to_ocnt_DISTWGT_4.nc .
