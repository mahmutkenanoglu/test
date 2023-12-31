# Sparse representation for machine learning the properties of defects in 2D materials

*This Readme file should provide you with a better understanding of how this project is organized. When switching between files in My Desk, Workflow Manager and other components of the platform, you can find this Readme by clicking on the question mark icon in the bottom right corner of the page.*

## Table of content

- [Introduction](#introduction)
- [General pipeline](#general-pipeline)
  - [Data preprocessing: VASP -\> csv/cif -\> pickle \& matminer](#data-preprocessing-vasp---csvcif---pickle--matminer)
    - [1. Low density index](#1-low-density-index)
    - [2. VASP -\> csv/cif](#2-vasp---csvcif)
    - [3a. csv/cif -\> dataframe](#3a-csvcif---dataframe)
    - [3b. csv/cif -\> matminer](#3b-csvcif---matminer)
  - [Computational experiments](#computational-experiments)
  - [Results analysis](#results-analysis)
  - [Data](#data)
- [Constructor Research Platform user guide](#constructor-research-platform-user-guide)
  - [Using terminal](#using-terminal)
  - [WanDB](#wandb)
  - [Using workflows](#using-workflows)

# Reproducing the paper

> **Demo project**
> 
> This project uses lightweight workflows to demonstrate the functionality of a larger, more computationally intensive project. Certain computationally intensive steps have been omitted and replaced with pre-calculated data to reduce the computational requirements of this demo.
> 
>  The full version of the project, with all computationally intensive steps included, can be found [here](https://my.rolos.com/public/project/6c2567e07ce64037b6b6edd2895b27ee). Please note that the full version requires approximately 16 GPU days to run, and is not feasible to execute on a free trial account. To unlock the full power of full version of the project, upgrade your account by contacting support via our Live Chat by clicking on the question mark icon in the bottom right corner of the page.

## Introduction

In the paper we propose sparse representation as a way to reduce the computational cost and improve the accuracy of machine learning the properties of defects in 2D materials. The code in the project implements the method, and a rigorous comparison of its performance to the a set of baselines.

Two-dimensional materials offer a promising platform for the next generation of (opto-) electronic devices and other high technology applications. One of the most exciting characteristics of 2D crystals is the ability to tune their properties via controllable introduction of defects. However, the search space for such structures is enormous, and ab-initio computations prohibitively expensive. We propose a machine learning approach for rapid estimation of the properties of 2D material given the lattice structure and defect configuration. The method suggests a way to represent  configuration of 2D materials with defects that allows a neural network to train quickly and accurately. We compare our methodology with the state-of-the-art approaches and demonstrate at least 3.7 times energy prediction error drop. Also, our approach is an order of magnitude more resource-efficient than its contenders both for the training and inference part.

The main idea of our method is using a point cloud of defects as an input to the predictive model, as opposed to the usual point cloud of atoms, or expertly created feature vector.
![Sparse representation construction](ai4material_design/docs/constructor_pics/sparse.png)

We compare our approach to state-of-the-art generic structure-property prediction algorithms: [GemNet](https://arxiv.org/abs/2106.08903), [SchNet](https://arxiv.org/abs/1706.08566), [MegNet](https://arxiv.org/abs/1812.05055), [matminer+CatBoost](https://github.com/hackingmaterials/matminer).

For dataset, we use [2DMD](https://www.nature.com/articles/s41699-023-00369-1). It consists of the most popular 2D materials: MoS2, WSe2, h-BN, GaSe, InSe, and black phosphorous (BP) with point defect density in the range of 2.5% to 12.5%. We use DFT to relax the structures and compute the defect formation energy and HOMO-LUMO gap. ML algorithms predict those quantities, taking unrelaxed structures as input.

# General pipeline 

The calculations in the paper occur in two stages:
1. Firstly, we extract the relevant information about the structures and their properties from the VASP outputs, and prepare the sparse and vectorized representation of the structures.
2. Secondly, we train the models and evaluate them on the test dataset.

![pipeline_pic](ai4material_design/docs/constructor_pics/pipeline.png)

Finally, we analyze the results and produce the tables and plots.

Run the workflows in the following order. Same number means the workflows can be run concurrently.

## Data preprocessing: VASP -> csv/cif -> pickle & matminer

### 1. Low density index

This step creates technical files needed to preserve the historical structure indexing for low density structures. Location: [`ai4material_design/datasets/csv_cif/low_density_defects_Innopolis-v1/{MoS2,WSe2}`](../datasets/csv_cif/low_density_defects_Innopolis-v1).

### 2. VASP -> csv/cif

This step extracts the computed energy and HOMO-LUMO gap values from the raw VASP output, and saves the unrelaxed structures in a uniform way. Location: [`ai4material_design/datasets/csv_cif/{high,low}_density_defects/*`](../datasets/csv_cif).

To reduce the repository size, raw VASP files are not stored on the platform, you need to download them from DVC. Prior to that, you need to increase the project size, 100 Gb should be sufficient.
To increase the project size, make sure you have a full, and not a trial account, then left-click on the environment name, "Material design environment (PyTorch)" in our case.
![opening environment settings](ai4material_design/docs/constructor_pics/env_settings.png)

Use the following commands to download the data from DVC:
```bash
cd ai4material_design
dvc pull datasets/raw_vasp/high_density_defects/{BP,GaSe,hBN,InSe}_spin*.dvc
dvc pull datasets/raw_vasp/high_density_defects/{MoS,WSe}2_500.dvc
dvc pull datasets/raw_vasp/dichalcogenides8x8_vasp_nus_202110/*.tar.gz.dvc

git add datasets/raw_vasp/high_density_defects/{BP,GaSe,hBN,InSe}_spin*
git add datasets/raw_vasp/high_density_defects/{MoS,WSe}2_500
git add datasets/raw_vasp/dichalcogenides8x8_vasp_nus_202110/*.tar.gz
git commit -m "Add raw VASP files"
git push
```

### 3a. csv/cif -> dataframe

This step converts the structures from standard [CIF](https://www.iucr.org/resources/cif) format to a fast platform-specific pickle storage. It also preprocesses the target values, e. g. computes the formation energy per atom. Finally, it produces the sparse defect-only representations.

Location: [`ai4material_design/datasets/processed/{high,low}_density_defects/*/{targets.csv,data.pickle}.gz`](../datasets/processed).

### 3b. csv/cif -> matminer

This step computes [matminer](https://github.com/hackingmaterials/matminer) descriptors, to be used with [CatBoost](https://catboost.ai/).

You can skip this step if don't plan on running CatBoost. Location: [`ai4material_design/datasets/processed/{high,low}_density_defects/*/matminer.csv.gz`](../datasets/processed).

## Computational experiments

We have prepared the the workflows that reproduce the tuned models evaluation. They train the models and produce predictions on the test dataset. Training is done 12 times with different random seeds and initializations to estimate the uncertainty. Run them concurrently:
* `4a Combined test SchNet`
* `4c Combined test CatBoost`
* `4d Combined test MegNet full`
* `4e Combined test MegNet sparse`
* `4b Combined test GemNet`

Location: [`ai4material_design/datasets/predictions/combined_mixed_weighted_test/**`](../datasets/predictions/combined_mixed_weighted_test).

For the rest of computations in the paper, you need to create the corresponding workflows.

## Results analysis
The notebooks are used as a source for Rolos publications, to update go to the "Publications" tab, click "Synchronize" and "Publish"
* Aggregate performance tables [`ai4material_design/notebooks/Results tables.ipynb`](../notebooks/Results%20tables.ipynb)
* Quantum oscillation predictions [`ai4material_design/notebooks/MoS2_V2_plot.ipynb`](../notebooks/MoS2_V2_plot.ipynb)

Additionally, the aggregate tables can be produced in CSV format with
```bash
cd ai4material_design
python scripts/summary_table_lean.py --experiment combined_mixed_weighted_test --targets formation_energy_per_site --stability-trials stability/schnet/25-11-2022_16-52-31/71debf15 stability/catboost/29-11-2022_13-16-01/02e5eda9 stability/gemnet/16-11-2022_20-05-04/b5723f85 stability/megnet_pytorch/sparse/05-12-2022_19-50-53/d6b7ce45 stability/megnet_pytorch/25-11-2022_11-38-18/1baefba7 --separate-by target --column-format-re stability\/\(?P\<name\>.+\)\/.+/\.+ --paper-results --multiple 1000 --format pandas_separate_std
python scripts/summary_table_lean.py --experiment combined_mixed_weighted_test --targets homo_lumo_gap_min --stability-trials stability/schnet/25-11-2022_16-52-31/2a52dbe8 stability/catboost/29-11-2022_13-16-01/1b1af67c stability/gemnet/16-11-2022_20-05-04/c366c47e stability/megnet_pytorch/sparse/05-12-2022_19-50-53/831cc496 stability/megnet_pytorch/25-11-2022_11-38-18/1baefba7 --separate-by target --column-format-re stability\/\(?P\<name\>.+\)\/.+/\.+ --paper-results --multiple 1000 --format pandas_separate_std
```

## Data
The data are already here. The results of all the steps are already available in the repository, you can selectively reproduce the parts you want.

# Constructor Research Platform user guide

## Using terminal
Open a terminal using the Desk menu

![terminal menu](ai4material_design/docs/constructor_pics/terminal.png)

The commands in this guide assume the starting working directory to be `/home/coder/project` .

## WanDB
[WanDB](https://wandb.ai/) is a service for monitoring and recording machine learning experiments we use in the project. By default, WanDB integration is disabled. To optionally enable it, set you WanDB API key in [`scripts/Rolos/wandb_config.sh`](../scripts/Rolos/wandb_config.sh), commit and push. Note that if you add collaborators to your project, they will have access to your API key.

## Using workflows
Open the Workflow interface by clicking on the Workflow link in the top-right. You might want to open it in a new browser tab.

![Workflow panel location](ai4material_design/docs/constructor_pics/workflow.png)

After running a workflow, you need to grab the outputs from the workflow and add them to git:
```bash
export WORKFLOW="<workflow name>"
# Example:
# export WORKFLOW="4 Combined test MegNet sparse"
cp -r "rolos_workflow_data/${WORKFLOW}/current/data/datasets" ai4material_design/
git add ai4material_design/datasets
git commit -m "Workflow ${WORKFLOW} results"
git push
```
