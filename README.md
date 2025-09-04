# DEKOIS2.0 Converted Dataset (PDBQT format)

This directory contains the **converted PDBQT files** from the DEKOIS2.0 dataset for docking experiments.  
The dataset has been uploaded to Zenodo:  
- **Converted dataset**: [https://doi.org/10.5281/zenodo.17050764](https://doi.org/10.5281/zenodo.17050764)  
- **Original dataset**: [https://zenodo.org/record/8131256/files/DEKOIS2.zip?download=1](https://zenodo.org/record/8131256/files/DEKOIS2.zip?download=1)  
- **Additional ligands/decoys**: [University of Tübingen DEKOIS website](https://uni-tuebingen.de/fakultaeten/mathematisch-naturwissenschaftliche-fakultaet/fachbereiche/pharmaziebiochemie/teilbereich-pharmazie-pharmazeutisches-institut/pharmazeutische-chemie/prof-dr-f-boeckler/dekois/)

---

## Directory Structure

- **1_pdbqt/**  
  Converted `.pdbqt` files (main set).  
  These files are archived on Zenodo [here](https://doi.org/10.5281/zenodo.17050764).

- **2_rec/**  
  Protein structures converted from `protein/*_protein.pdb` in `DEKOIS2.zip` → `.pdbqt`.

- **3_lig/**  
  Ligand structures converted from `protein/*_ligand.mol2` in `DEKOIS2.zip` → `.pdbqt`.

- **4_glide_pos/**  
  Docking poses converted from `glide_pos/*.sdf` in `DEKOIS2.zip` → `.pdbqt`.

- **5_activate/**  
  Active ligands converted to `.pdbqt`.

- **6_decoy/**  
  Decoys converted to `.pdbqt` (from `decoys_part_1.zip`, `decoys_part_2.zip`, `decoys_part_3.zip`, `ligands.zip`).

---

## Software Installation

Two environments are required:  

### 1. ADT environment (Python 2.7 + MGLTools)
Used for ligand/protein preparation.  
```bash
conda create -n adt_py27 python=2.7 -y
conda activate adt_py27
conda install -c bioconda mgltools -y
conda deactivate
```

### 2. Open Babel environment (Python 3.10)
Used for batch scripts and metal charge patching.  
```bash
conda create -n obabel_py310 python=3.10 -y
conda activate obabel_py310
conda install -c conda-forge openbabel -y
conda deactivate
```

---

## Conversion Scripts

This repository also contains the **actual conversion scripts** used to generate the `.pdbqt` files from the DEKOIS2.0 dataset.  
They can be found under this directory, enabling full reproducibility of the dataset preparation.

---

## Author

- **Author**: Pei-Kun Yang  
- **E-Mail**: peikun@isu.edu.tw, peikun6416@gmail.com  

---

## Citation

If you use this dataset, please cite the Zenodo record:  
[https://doi.org/10.5281/zenodo.17050764](https://doi.org/10.5281/zenodo.17050764)
