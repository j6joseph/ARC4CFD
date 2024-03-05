## For all Clusters

# Generate Mesh
module load CCEnv StdEnv/2023 gcc/12.3 gmsh/4.12.2  # CCEnv needed only in Niagara
gmsh Backstep_str_mesh.geo -0    # Avoid -0 to open in GUI and then close GUI to continue.
#confirm Backstep_str_mesh.su2

#Test job in StdEnv
module load CCEnv StdEnv/2020 gcc/9.3.0 openmpi/4.0.3 su2/7.5.1  # CCEnv needed only in Niagara
salloc --nodes 1 -n 20 --time=00:30:00
#wait for nodes to be allocated
mpirun -n 20 SU2_CFD Backstep_str_config.cfg

#Main Job in StdEnv
vim '+set ff=unix' '+x' su2job_StdEnv.sh   # Setting file format to Unix
sbatch su2job_StdEnv.sh   # Remove CCEnv from line 9 for clusters other than Niagara




## Exclusive in Niagara

#Download pre-compiled SU2 v8  (to be performed only once)
cd $SCRATCH
mkdir SU2_executable
cd SU2_executable
wget https://github.com/su2code/SU2/releases/download/v8.0.0/SU2-v8.0.0-linux64-mpi.zip
unzip SU2-v8.0.0-linux64-mpi.zip

#Test job in NiaEnv  (requires download of pre-compiled SU2 v8)
cd <working_folder_path>
module load NiaEnv/2019b gcc/8.3.0 intelmpi/2019u5 python/3.6.8
export SU2_RUN="/scratch/SU2_executable/bin"
export PATH=$PATH:$SU2_RUN
which SU2_CFD   # confirm the path "/scratch/SU2_executable/bin"
salloc --nodes 1 -n 20 --time=00:30:00
#wait for nodes to be allocated
mpirun -n 20 SU2_CFD Backstep_str_config.cfg

#Main Job in NiaEnv (requires download of pre-compiled SU2 v8. Check path in line 10 of su2job_NiaEnv.sh)
vim '+set ff=unix' '+x' su2job_NiaEnv.sh
sbatch su2job_NiaEnv.sh