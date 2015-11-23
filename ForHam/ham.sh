#!/bin/csh

module purge
module load intel/xe_2015.2

icc -O3 spacebodies.cpp -o spacebodies

module load slurm
sbatch my.slurm-script

