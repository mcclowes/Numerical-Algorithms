#!/bin/csh

rm *.out
rm results/*

module purge
module load intel/xe_2015.2

icc -O3 -DHAMTIME -DSIMTIME spacebodies.cpp -std=c++11 -o spacebodiesserial
icc -O3 -DHAMTIME -DSIMTIME -openmp -DPAR spacebodies.cpp -std=c++11 -o spacebodiesparallel

module load slurm
#sbatch serial10.slurm-script
#sbatch serial25.slurm-script
#sbatch serial50.slurm-script
#sbatch serial100.slurm-script
#sbatch serial150.slurm-script
#sbatch serial200.slurm-script
#sbatch serial250.slurm-script
#sbatch serial500.slurm-script
#sbatch serial625.slurm-script
#sbatch serial750.slurm-script
#sbatch serial1000.slurm-script

#sbatch parallel10.slurm-script
#sbatch parallel25.slurm-script
#sbatch parallel50.slurm-script
#sbatch parallel100.slurm-script
#sbatch parallel150.slurm-script
#sbatch parallel200.slurm-script
sbatch parallel250.slurm-script
#sbatch parallel500.slurm-script
#sbatch parallel625.slurm-script
#sbatch parallel750.slurm-script
#sbatch parallel1000.slurm-script

