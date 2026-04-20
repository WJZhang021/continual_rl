#!/bin/bash
#SBATCH --job-name=PCwj_Run
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=32G
#SBATCH --time=24:00:00
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1

# Load modules (Adjust based on Great Lakes python/conda environment paths)
# module load python/3.11.4 

# Activate your conda environment where pytorch and continual_rl are installed
# source /home/$USER/miniconda3/bin/activate
# conda activate pytorch3.11

# Move to the project directory
cd $SLURM_SUBMIT_DIR

# Required for IMPALA-based multiprocessing
export OMP_NUM_THREADS=1

# Run the full experiment based on the config file
# Ensure you have configs/procgen/pcwj_procgen.json set to num_actors=32 to match cpus-per-task
python main.py --config-file configs/procgen/pcwj_procgen_run.json --output-dir results_pcwj_procgen