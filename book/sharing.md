# Sharing Research Objects (TBD)

Science at its best is a communal enterprise, and the sociologist of science Robert Merton noted that "Secrecy is the
antithesis of this norm; full and open communication its enactment" [@Merton:1942aa].  Unfortunately scientists have not always lived up to this norm in practice.  It remains unfortanately common to hear anecdotes of researchers who refuse to share data or materials even after publishing in journals that have (largely unenforced) requirements for sharing.  The metascientific evidence is also consistent with this.  As just one example, when [@Wicherts:2006aa] requested data from authors of papers in a number of top journals in psychology, they were unable to obtain data from 73% of the authors.  More recent work by [@Tedersoo:2021aa] has shown a similar pattern of unavailability across many scientific fields.  

The open sharing of research objects writ large (which includes data, code, materials, and open access publication) has become increasingly prevalent in the 21st century, particularly with the genesis of the "open science" movement.  In fact, when [@Tedersoo:2021aa] compared data availability between 2000–2009 and 2010–2019 they found that it had significantly increased over time.  There are numerous contributors to this increase in transparency. Foremost, the reproducibility crisis across many fields of science has spurred efforts to increase the credibility of scientific research, with open sharing of data and materials being a main component of these efforts.  Major scientific institutions have also made open science central to their effort, including the United States Government (which officially named 2023 as the "Year of Open Science"), the European Union, and UNESCO.  Overall the pendulum is swinging strongly in the direction of making science more open and transparent, which many of us think is also a key to making it more reproducible.

In this chapter I will focus on how to effectively share research objects in a way that abides by the FAIR Principles that I outlined in Chapter 6. 


## Persistent identifiers

While you may never have heard the phrase "link rot", you have almost certainly encountered a URL embedded in a publication that no longer works.  *Persistent identifiers* (PIDs) are meant to address the issue of *findability* by providing a durable link to the metadata for an object along with a reference to its current location.  The presence of a persistent identifier doesn't ensure that the object will always be available, but it does provide a mechanism to find it if it does exist. 

The need for PIDs is nowhere as clear as it is for people, especially for people with common names (think "Robert Smith" or "Mei Wang").  The need to identify individual researchers was the rationale for the ORCID (Open Researcher and Contributor ID), which provides identifiers for researchers; for example, my ORCID is [0000-0001-6755-0259](https://orcid.org/0000-0001-6755-0259), and if you follow that link you will find a public record that includes information about my education, academic affilations, publications, and more.  My name is quite uncommon, but for people with common names the ability to point to a unique identifier that is not tied to an employer helps ensure that people are findable and that their metadata is accessible.  (If you are a researcher and don't have an ORCID, you should definitely register for one!)

Another commonly encountered PID is the *digital object identifier* (*DOI*), which has become the most popular PID for publications and is also commonly used for other resources such as data and code.  DOIs are issued by a publisher or archive, and they contain metadata about the object along with a current link to the object.  If the links change (for example, the web site changes their URL structure), the publisher can easily update those links so that the DOI points to the correct link.  The DOI doesn't guarantee that the resource will always exist, but it does ensure that at least the metadata will persist even if the resource disappears. Other PIDs that are commonly encountered are RORs (Research Organization Registry) for research institutions and RRIDs (Research Resource Identifiers) for research resources including antibodies, cell lines, model organisms, software tools, and databases. 

### PID versioning

It's common for a resource to change over its life; as one example, preprints posted to archives like *arXiv* or *bioRxiv* to be updated when a revised manuscript is created. Some PID providers (particularly DOIs) provide *versioned DOIs* that point to specific versions of an object, where others provide *concept DOIs* that instead point to the object in general; in addition, some providers provide both.  For example, the Zenodo archive (discussed in more detail below) allows direct sharing of software releases from a GitHub repository, which we used to share code from the NARPS project that I discussed in an earlier chapter. Zenodo provides a concept DOI ([10.5281/zenodo.3339821](https://doi.org/10.5281/zenodo.3339821)) that points to the resource (dfaulting to the latest version), and also provides version DOIs that allow specific reference to any particular version.

## Accessible data formats

File Formats: Choosing open, machine-readable formats (CSV, JSON, HDF5, Parquet).



## Legal and ethical considerations
Copyright vs. Licensing: Why you need an explicit license.
Software Licenses: Permissive (MIT, Apache) vs. Copyleft (GPL).
Data Licenses: Creative Commons (CC0 vs. CC-BY).
Data Use Agreements: Handling sensitive/clinical data.




## Sharing specific types of research objects

## Sharing code

In Chapter 7 I introduced the FAIR principles, which were originally introduced in the context of data but have since been adapted to research software by [@Katz:2021aa].  [](#fairsoftware-fig) shows a schematic of the different components required to make research software FAIR.  Here I will outline the main components of the FAIR research software framework.

```{figure} images/fair_software.jpg
:label: fairsoftware-fig
:align: center
:width: 800

A schematic figure outlining the different components of FAIR software.  Reprinted from [@Katz:2021aa], CC-BY.  
```


### Persistent identifiers

Associating software with a *persistent identifier* is essential for making the software findable.  

extrinsic vs intrinsic identifiers: https://www.softwareheritage.org/software-heritage-faq/#3_Referencing_and_identification

#### DOIs via Zenodo

#### Hash-based identifiers using SWHID

https://www.softwareheritage.org/how-to-archive-reference-code/
https://www.softwareheritage.org/2025/06/13/software-hash-identifier-swhid-tutorial/




### Software citation

https://peerj.com/articles/cs-86/
https://ieeexplore.ieee.org/abstract/document/8946737

reference vs citation - https://ieeexplore.ieee.org/abstract/document/8946737, https://ieeexplore.ieee.org/document/8887228
- citation is about giving intellectual/academic credit to authors for their work
- reference is about precisely identifying specific software artifacts for the purpose of reuse

citation.cff
CITATION.cff (github's "cite this repository"), 

### Software metadata

machine-readable metadata: codemeta.json (https://codemeta.github.io/user-guide/), pyproject.toml (keywords), package.json

### Preparing code for sharing

Missing Topic: "Sanitization". Removing config.py files with passwords, removing absolute file paths (/Users/home/john/data), and using .gitignore.
Missing Topic: Documentation Standards. A license isn't enough. You need a README and a CONTRIBUTING.md.

### Software versioning

semantic versioning,

### Publishing software packages

Scientists increasingly need to share installable software, not just scripts. Topics like pyproject.toml, publishing to PyPI or conda-forge,  and creating a proper installable package are absent. 



#### Licenses for code
Refinement on Licenses: Distinguish between Permissive (MIT/BSD) and Copyleft (GPL). Scientists often pick GPL without realizing it restricts industry collaboration, or MIT without realizing it allows proprietary forking.


### Sharing data

Missing Topic: Metadata. Sharing a CSV is useless without a data dictionary or metadata standard (e.g., schema.org or domain-specific standards like DICOM/FITS).
Missing Topic: File Formats. Engineering advice on choosing non-proprietary, long-term formats (e.g., CSV/Parquet instead of .xlsx, HDF5/NetCDF for binary).
Metadata standards.
Large file handling (Git LFS vs. external storage).


#### Data sharing and use agreements

## Sharing computational models
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
