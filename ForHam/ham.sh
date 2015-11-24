#!/bin/csh

rm *.out
rm results/*

module purge
module load intel/xe_2015.2

icc -O3 -DHAMTIME -DSIMTIME spacebodies.cpp -std=c++11 -o spacebodiesserial
icc -O3 -DHAMTIME -DSIMTIME -fopenmp -DPAR spacebodies.cpp -std=c++11 -o spacebodiesparallel

module load slurm
#sbatch test1.slurm-script
#sbatch test2.slurm-script
#sbatch test3.slurm-script
sbatch serial1000.slurm-script
sbatch parallel1000.slurm-script

