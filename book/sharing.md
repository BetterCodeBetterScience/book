# Sharing Research Objects (TBD)

Why share?
Reproducibility as a scientific standard.
Funder and Journal mandates (Data Management Plans).
Incentives: Gaining credit and citations for software/data.

FAIR for software: https://arxiv.org/pdf/2101.10883 - maybe reproduce figure 2?

## The FAIR principles for sharing

In the earlier chapter on data management I outlined the FAIR Principles, which form the foundation for our current understanding of how to most effectively share research objects.  In this chapter I will map those concepts onto the specific actions required for FAIR sharing.  

Brief overview of Findable, Accessible, Interoperable, Reusable.
Table mapping FAIR principles to specific engineering actions (e.g., F -> DOIs, R -> Licenses).


### Findable

machine-readable metadata: CITATION.cff (github's "cite this repository"), codemeta.json (https://codemeta.github.io/user-guide/), pyproject.toml (keywords)
persistent IDs (per release) - e.g. zenodo/github 

### Accessible
Standard protocols vs. custom download scripts
authentication - eg. oauth2

### Interoperable

open formats (avoiding proprietary formats that require paid software to open)
containerization - allows operation on any major platform

### Reusable
explicit licensing/usage agreement
sanitization - scrub secrets. .gitignore, env vars
provenance


## Preparing objects for sharing:
Sanitization: Removing secrets (API keys), hardcoded paths, and PII.
Documentation: READMEs, Data Dictionaries, and Model Cards.
File Formats: Choosing open, machine-readable formats (CSV, JSON, HDF5, Parquet).
Structuring: Directory organization for public consumption (e.g., Cookiecutter templates).


## Legal and ethical considerations
Copyright vs. Licensing: Why you need an explicit license.
Software Licenses: Permissive (MIT, Apache) vs. Copyleft (GPL).
Data Licenses: Creative Commons (CC0 vs. CC-BY).
Data Use Agreements: Handling sensitive/clinical data.


## Persistent identifiers

Suggestion: Expand this to explain the ecosystem.
DOIs (for objects) vs. ORCIDs (for people) vs. RORs (for institutions).
Explain the concept of Versioning here. If I update my dataset, does the DOI change? (Concept of "concept DOIs" vs "version DOIs").


## Sharing specific types of research objects

### Sharing code
Missing Topic: "Sanitization". Removing config.py files with passwords, removing absolute file paths (/Users/home/john/data), and using .gitignore.
Missing Topic: Documentation Standards. A license isn't enough. You need a README and a CONTRIBUTING.md.
Making code citeable (CITATION.cff files).
Dependency management.

Scientists increasingly need to share installable software, not just scripts. Topics like pyproject.toml, publishing to PyPI or conda-forge, semantic versioning, and creating a proper installable package are absent. 


#### Licenses for code
Refinement on Licenses: Distinguish between Permissive (MIT/BSD) and Copyleft (GPL). Scientists often pick GPL without realizing it restricts industry collaboration, or MIT without realizing it allows proprietary forking.


### Sharing data

Missing Topic: Metadata. Sharing a CSV is useless without a data dictionary or metadata standard (e.g., schema.org or domain-specific standards like DICOM/FITS).
Missing Topic: File Formats. Engineering advice on choosing non-proprietary, long-term formats (e.g., CSV/Parquet instead of .xlsx, HDF5/NetCDF for binary).
Metadata standards.
Large file handling (Git LFS vs. external storage).


#### Data sharing and use agreements

### Sharing models
https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1012702

The PLOS paper you linked is excellent. You should structure this section around the "Model Card" concept.
Distinguish between sharing the Architecture (code), the Weights (binary), and the Training Data.

Model architectures vs. Trained weights.
Model Registries (e.g., Hugging Face Hub).
Model Cards for reporting limitations/bias.


### Sharing platforms

Suggestion: Group this by function.
Repositories: GitHub/GitLab (living code).
Archives: Zenodo/Dryad/Figshare (frozen record).
Registries: PyPI/CRAN/Bioconductor (distribution).


### Sharing environment configurations

Configuration files (requirements.txt, environment.yml).

### Sharing containers
Containers (Docker vs. Singularity/Apptainer for HPC).
