#!/bin/csh

rm *.out
rm results/*

module purge
module load intel/xe_2015.2

icc -O3 -DHAMTIME -DSIMTIME spacebodies.cpp -std=c++11 -o spacebodiesserial

module load slurm
sbatch test1.slurm-script
sbatch test2.slurm-script
sbatch test3.slurm-script
sbatch series1000.slurm-script

icc -O3 -DHAMTIME -DSIMTIME -fopenmp spacebodies.cpp -std=c++11 -o spacebodiesparallel

module load slurm
sbatch parallel1000.slurm-script

