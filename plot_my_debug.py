import os
import argparse
import numpy as np

# Reusing the plotting infrastructure
from continual_rl.utils.cora_metrics import TASKS_PROCGEN
from continual_rl.utils.metrics import Metrics
import plotly.io as pio
pio.defaults.mathjax = None

# 1. Define where your downloaded test data lives
# We'll mock a "model" out of your downloaded debug folder
MODELS_DEBUG = {
    "PCwj": dict(
        name='pcwj',
        # Instead of 20 runs, you point to exactly the folder(s) you have.
        # "results_pcwj_procgen/tmp/pcwj_procgen_debug/0"
        runs=['results_pcwj_procgen/tmp/pcwj_procgen_debug/0'], 
        color='rgba(152, 67, 63, 1)', # Plot color (Red-ish)
        color_alpha=0.3,
    ),
    # If you later download the baseline P&C result, you can add it here:
    # "Original P&C": dict(
    #     name='pnc',
    #     runs=['results_pnc_procgen/tmp/pnc_procgen_debug/0'],
    #     color='rgba(77, 102, 133, 1)', # Blue
    #     color_alpha=0.3,
    # )
}

# 2. Configure the metrics runner
DEBUG_PROCGEN = dict(
    models=MODELS_DEBUG,
    tasks=TASKS_PROCGEN,
    rolling_mean_count=1, # Since this is debug data with very few steps, we don't want a huge smoothing window
    filter='ma',
    num_cycles=5,
    num_cycles_for_forgetting=1,
    num_task_steps=5e6, # This is the scale of the real tasks, the script might compute against this
    grid_size=[2, 3],
    which_exp='debug_procgen', # prefix for outputs
    xaxis_tickvals=list(np.arange(0, 150e6 + 1, 30e6)),
    cache_dir='.', # Where to put the cache parsing pkl
)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    # It expects you to provide the base directory containing the run folder.
    # Because your 'runs' paths above are relative to where you run the script, '.' is fine.
    parser.add_argument('-d', '--exp-dir', type=str, default='.')
    args = parser.parse_args()

    # Pass the 'exp_dir' into our dictionary
    DEBUG_PROCGEN['exp_dir'] = args.exp_dir

    metrics = Metrics(DEBUG_PROCGEN)

    # 3. Generate tables and graphs!
    
    # 3.1 Continual Evaluation (The main learning curves)
    print("Generating continual evaluation plots...")
    metrics.visualize()
    
    print("Done! Check your current folder for the generated .pdf files.")