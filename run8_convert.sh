#!/bin/bash

#SBATCH -p nica
#SBATCH -t 3:00:00
#SBATCH -J Converter
#SBATCH -a 1-999
#SBATCH -o /eos/nica/mpd/users/demanov/bmn/convert_run8_25.09/log/%A_%a.log

digi_directory=/eos/nica/bmn/exp/digi/run8/25.09.0
dst_directory=/eos/nica/bmn/exp/dst/run8/25.09.0

plp_directory=/eos/nica/mpd/users/demanov/bmn/convert_run8_25.09
calib_file1=/eos/nica/mpd/users/demanov/bmn/convert_run8_25.09/run8_dedx_calibR_coeff.root
calib_file2=/eos/nica/mpd/users/demanov/bmn/convert_run8_25.09/run8_dedx_calibS_coeff.root

CONVERTER_MACRO=/eos/nica/mpd/users/demanov/bmn/convert_run8_25.09/convertBmn_run8.C

TASK_ID=$SLURM_ARRAY_TASK_ID

file_list=$1
out_dir=$2

mkdir -p $out_dir
mkdir -p "${out_dir}/log"
cd $out_dir

name_file_root=$(basename $(head -n $TASK_ID $file_list | tail -n 1 ))
name_file=${name_file_root%.root*}
input_file_dst=${dst_directory}/${name_file}.root
input_file_digi=${digi_directory}/${name_file}.root
#input_file_plp=${plp_directory}/${name_file}.hitInfo.root
input_file_plp=""
output_file=${out_dir}/${name_file}.tree.root
output_log=${out_dir}/log/${SLURM_ARRAY_JOB_ID}_${TASK_ID}_${name_file}.log

source /cvmfs/nica.jinr.ru/sw/os/login.sh legacy
source /cvmfs/bmn.jinr.ru/config/x86_64-centos7/cluster_config.sh
source /cvmfs/bmn.jinr.ru/bmnroot/25.09.0/x86_64-centos7/bmnroot_config.sh

echo "Node name: ${SLURMD_NODENAME}" &>> $output_log
echo "Job ID: ${SLURM_ARRAY_JOB_ID}" &>> $output_log
echo "Task ID: ${TASK_ID}" &>> $output_log
echo "line: ${TASK_ID}" &>> $output_log
echo "name: ${name_file}" &>> $output_log
echo "input digi: ${input_file_digi}" &>> $output_log
echo "input dst: ${input_file_dst}" &>> $output_log
echo "output tree: ${output_file}" &>> $output_log
echo "calib file 1: ${calib_file1}" &>> $output_log
echo "calib file 2: ${calib_file2}" &>> $output_log
echo "output log: ${output_log}" &>> $output_log

time root -l -b -q ${CONVERTER_MACRO}"(\"${input_file_dst}\", \"${input_file_digi}\",\"${calib_file1}\",\"${calib_file2}\",\"${output_file}\")" &>> $output_log
#root -l -q -b convertBmn_run8.C'("/eos/nica/bmn/exp/dst/run8/25.09.0/mpd_run_Top_8000_ev0_p17.root","/eos/nica/bmn/exp/digi/run8/25.09.0/mpd_run_Top_8000_ev0_p17.root","/eos/nica/mpd/users/demanov/bmn/convert_run8_25.09/run8_dedx_calibR_coeff.root","/eos/nica/mpd/users/demanov/bmn/convert_run8_25.09/run8_dedx_calibS_coeff.root","/path_to_oFile/oFile.tree.root")

echo "Done!" &>> $output_log
