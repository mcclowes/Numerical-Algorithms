#!/bin/csh

module purge
module load intel/xe_2015.2

icc -O3 -DHAMTIME -DSIMTIME spacebodies.cpp -std=c++11 -o spacebodies

module load slurm
sbatch test1.slurm-script
sbatch test2.slurm-script
sbatch test3.slurm-script

