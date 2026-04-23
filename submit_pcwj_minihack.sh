#!/bin/bash
#SBATCH --job-name=PCwj_Run_MiniHack
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16      # 这里要确保和 config 中的 num_actors 一致
#SBATCH --mem=24G               # 32个进程建议给到 48G 内存更稳妥，Procgen 比较吃内存
#SBATCH --time=8:00:00
#SBATCH --partition=spgpu
#SBATCH --gres=gpu:1
#SBATCH --account=ece567w26_class    # 别忘了加上你的计费账号
#SBATCH --output=logs/%x-%j.out
#SBATCH --error=logs/%x-%j.err

# 1. 激活环境 (根据你的具体路径调整)
source ~/conda/miniconda/bin/activate cora

# 2. 进入项目目录
cd $SLURM_SUBMIT_DIR

# 3. 环境变量设置 (直接写在运行命令前效果一样)
export OMP_NUM_THREADS=1
export CUDA_VISIBLE_DEVICES=0
export PYTHONUNBUFFERED=1

# 4. 创建日志目录
mkdir -p logs

# 5. 执行训练
# 建议：--output-dir 指向 Turbo 存储，防止 Home 空间不足
# 确保 configs/minihack/pcwj_minihack_run.json 中的 num_actors 确实是 32
python main.py \
    --config-file configs/minihack/pcwj_minihack_run.json \
    --output-dir /nfs/turbo/coe-mavens/wjzhang/results_pcwj_minihack
