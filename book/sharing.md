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

It's common for a resource to change over its life; as one example, preprints posted to archives like *arXiv* or *bioRxiv* to be updated when a revised manuscript is created. Some PID providers (particularly DOIs) provide *versioned DOIs* that point to specific versions of an object, where others provide *concept DOIs* that instead point to the object in general; in addition, some providers provide both.  For example, the Zenodo archive (discussed in more detail below) allows direct sharing of software releases from a GitHub repository, which we used to share code from the NARPS project that I discussed in an earlier chapter. Zenodo provides a concept DOI ([10.5281/zenodo.3339821](https://doi.org/10.5281/zenodo.3339821)) that points to the resource (dfaulting to the latest version), and also provides version DOIs that allow specific reference to any particular version.  When citing a versioned resource such as code, it's important to cite the specific version that was used in the work.

## Resource accessibility

The *accessible* portion of the FAIR principles states that data should be accessible by a well-specified and standard protocol.  This means that "data available from the authors upon reasonable request* is a decidedly unFAIR way to share data.  Accessible does not, however, mean that the data must be openly available to the world.  There are many cases when data cannot be shared openly, particuarly in the context of human subjects data where the sharing of identifiable information could put the subjects at risk of harm.  It is almost never the case, however, that data cannot be shared at all.  Instead, it is common that sensitive datasets must be shared under a *data usage agreement* (DUA), as I will discuss in more detail in the later section on data sharing.  FAIR sharing of controlled-access data requires that the process for accessing the data is made clear in the metadata.  

Accessibility generally implies that the data are available online, potentially requiring some kind of authentication. In general it's best to share objects via a standard archive, which will ensure that the metadata are findable and the data are broadly accessible.  The use of a standard archive also helps ensure that the data will remain accessible in the long term, which is much less likely if they are shared from a lab server or private web site.


## Interoperable data formats

Once the objects are findable and accessible, it's important that others are able to work with them, which is the *interoperable* portion of the FAIR principles.  The most important aspect of interoperability is the use of open, non-proprietary, and machine-readable file formats. I've already discussed a number of these that span many different types of data, including CSV/TSV, JSON, HDF5, Zarr, and Parquet.  Interoperability also requires that the data are documented and annotated in a way that makes them usable by other researchers. For example, a TSV file with no column labels and no data dictionary is not particularly useful to anyone.  

I also believe that interoperability requires the use of open-source software platforms such as Python or R.  It is common in the social sciences (particularly economics) for researchers to use the *Stata* software package for statistical analysis.  Sharing Stata code (`.do` files) allows me to read the code and potentially see what was done (though Stata's syntax is notoriously unreadable by non-experts), but I have no way to actually run the code unless I purchase a Stata license or have access to a site license. It's also very common for researchers in engineering and natural sciences to use the commercial package MATLAB; fortunately there is an open source alternative (*Octave*) that can run some MATLAB programs, but it will fail if the commonly used MATLAB Toolboxes are used. In my opinion, research using these closed-source commercial platforms is non-reproducible, which is why I moved from MATLAB to Python as my primary computing platform in 2009.

## Explicit licensing for reuse

It's quite common for individuals to post material online (such as pushing code to a public GitHub repository) without any information regarding the terms of release and then refer to the material as "open source", but this is a misnomer.  Without an explicit license granting usage rights to users, the creator holds the copyright (assuming that the material is eligible for copyright) and "all rights are reserved", meaning that the downloader has no right to use, modify, or redistribute the material.  This is why one should always include an explicit license or use agreement with shared materials, and one should *never* use materials for research without an explicit license or use agreement. Otherwise there is the potential that the owner might disallow your usage of the materials.  Because the nature of these license/agreements differ between different types of research objects, I will discuss them in detail below in the context of specific types of objects.


## Sharing code

Ten years ago I would have started this section with an explainer about why it's so important to share one's research code, but today there is relatively little opposition to sharing research code; in fact, in many areas of science it has become largely expected that code will be shared (often via GitHub or some other distributed version control platform).  This does not, however, mean that it's shared in a way that is effective in affording reuse and reproducibility. Here I will focus on the most important issues around making shared code useful.

### Licensing for shared code

In the context of software, the owner holds the copyright unless an explicit *license* is provided.  Without a license, someone downloading the code does not have the legal right to use, modify, or redistribute the code.  This is why one should *never* rely upon code that has been shared without a license, as it can put an entire project in legal peril.  You also protect yourself, since licenses generally include conditions that explicitly limit your liability and provide no warranty for the code.

There are many different licenses available for software, but they largely fall into two categories.  *Permissive* licenses are those that place very few restrictions on the reuse, modification, or redistribution of the code; some of these allow commercial reuse and/or closed source redistribution, while others do not.  The least prohibitive license, known as an *Unlicense*, places no conditions at all on use of the code, and only limits liability and warranty. *Copyleft* licenses (best known from the *GNU Public License*, or *GPL*) are more restrictive, requiring full disclosure of any modifications.  They are also sometimes referred to as *viral* licenses, since they also generally require that any modifications be released under the same license as the original.  I tend to strongly favor permissive licenses like the *MIT License*, because they maximize the potential reuse of the code while still maintaining credit for the original authors.

When using open source code, it is essential to abide by the conditions of the license of the original code.  In particular, if you are reusing code licensed under the GPL then you are required to release your modifications under the GPL as well. If you don't wish to license your entire codebase as GPL, then you might consider encapsulating the GPL code as a library which you can then call from your own code (licensed however you wish since it doesn't include any GPL code).

### Persistent identifiers for code

The most common way for researchers to cite code today is through a link to a github repository.  This is better than not sharing at all, but it fails to acheive a couple of improtant goals.  First, repositories change over time, and a link to a repository does not specify which particular version of the code was used for the research.  This can be addressed by using a link to a specific commit or release, but these are vulnerable to deletion, since any user can delete the repositories that they own at any time.  Second, it makes the assumption that GitHub will always exist and continue to provide unfettered access to all current repositories.  While there is no reason to think that GitHub will go away anytime soon, we can't trust a commercial platform to have our best interests at heart.  For this reason, I believe that research code associated with a publication should be shared using a persistent identifier (such as a DOI) on an archival platform.  

At present, the easiest way to achieve this is to use the direct connection from Github to the nonprofit data archive Zenodo, which is operated by the high-energy physics lab CERN in Switzerland. Generating a archival code package with a DOI can be acheived in just a few steps:

- Create an account on [Zenodo.org](https://zenodo.org/), logging in using your GitHub credentials
- Navigate to the GitHub Repositories page for the new account, and enable the preservation of the relevant repository by clicking the "ON" button next to the repository
- Go to the repository page on GitHub, and create a release for the software package, which is a frozen version of the current state of the repository.  This should be done immediately after completing the analyses for the project, so that the code in the release exactly matches the code used for the project.
- Zenodo will then automatically generate a version DOI that can be used to cite the specific version of software in a publication, along with a concept DOI for the package that resolves to the latest version.

There is another emerging standard PID for code known as the Software Hash Identifier (SWHID), which is being developed by the [Software Heritage](https://www.softwareheritage.org) organization that also runs an archive for software preservation. Unlike most PIDs, which are *extrinsic* in the sense that they have no direct relation to the content of the objects that they refer to, the SWHID is an *intrinsic* identifier that is based on a hash of the content (similar to the hashes that are used for commits in *git*).  This has the benefit that one can directly validate whether code matches the SWHID, and may become more prevalent in the future.  Saving code to the Software Heritage archive is as easy as submitting a [Save Code Now](https://archive.softwareheritage.org/save/) request.

### Software citation

As software resources are increasingly recognized as legitimate scientific contributions, it is increasingly common for them to be cited in research papers and included on *curricula vitae* for academic advancement and hiring.  [@Smith:2016aa] laid out a set of principles for the citation of software:

1. *Importance*: Software should be considered an important intellectual product that is worthy of citation.
2. *Credit and attribution*: Software citation should give proper attribution and credit to its creators and maintainers.
3. *Unique identification*: Software to be cited should have a unique PID.
4. *Persistence*: Software to be cited should be available in a persistent manner; if the software is not available then at least the metadata should be persistent.
5. *Accessibility*: Software citations should make clear how to obtain the software.
6. *Specificity*: Software citations should refer to the specific version of the software that was used in the research.

The GitHub-Zenodo and Software Heritage mechanisms described above can help fulfill these principles.  Code citation can be further supported by providing citation metadata via the `CITATION.cff` file.  Here is an example of the `CITATION.cff` file for the [bettercode](https://github.com/BetterCodeBetterScience/bettercode) package associated with this book:

```yaml
cff-version: 1.2.0
title: 'Better Code, Better Science'
message: Code for examples in the book
type: software
authors:
  - given-names: Russell
    family-names: Poldrack
    email: russpold@stanford.edu
    affiliation: Stanford University
    orcid: 'https://orcid.org/0000-0001-6755-0259'
repository-code: 'https://github.com/BetterCodeBetterScience/bettercode'
url: 'https://bettercodebetterscience.github.io/book/'
abstract: >-
  This is code used to generate examples for the book Better
  Code, Better Science.
keywords:
  - software engineering
  - AI
  - scientific software
license: MIT
identifiers:
  - type: doi
    value: 10.5281/zenodo.18603014
```

This file is used by both GitHub and Zenodo to populate citation information; see [](#citationcff-fig) for an example of how GitHub displays this information in the "Cite this repository" section. Including this file is a great way to help encourage proper citation of your code, and there are tools (such as [CFFinit](https://citation-file-format.github.io/cff-initializer-javascript/#/)) that can help create a citation file for any project.

```{figure} images/github_citation.jpg
:label: citationcff-fig
:align: center
:width: 500

An example of the citation information generated automatically by GitHub on the basis of the CITATION.cff file.
```


### Software metadata

In addition to citation information there are a number of other metadata that are important in order to make the code FAIR.  A set of guidelines regarding software metadata have been laid in the [RSMD](https://fair-impact.github.io/RSMD-guidelines/)(Research Software MetaData Guidelines for End-Users) project [@Gruenpeter:2024aa].  An emerging standard for the specification of software metadata is the `codemeta.json` file, which provides a standard vocabulary for the specification of software metadata.  This file uses the *JSON-LD* format that I mentioned in a previous chapter, which links the terms in the dictionary to a format vocabulary.  There [codemeta-generator](https://codemeta.github.io/codemeta-generator/) tool provides an easy interface for generating of thsee files.  GitHub itself doesn't do anything special with the `codemeta.json` contents, but if the software is archived in Software Heritage then the project will searchable by the specified metadata. Because this is becoming the standard, generating metadata now will also help ensure that your project remains findable in the future.

Because many systems (e.g. the *PyPI* package archive) do not use `codemeta.json`, it's also improtant to put relevant information in other files that may be used.  For Python code, the `pyproject.toml` file allows specification of a number of metadata elements; in particular, it's important to specify the name, version, description, license, authors, and keywords under the `[project]` section, and project URLs under the `[project.urls]` section, since these are used by PyPI for searching packages in the index.

### Software versioning

It is essential to clearly version the software used in a research project to ensure reproducibilty of the results, since it is common for the behavior of software to change between versions.  There are two standards for software versioning.  The approach recommended for most projects is *semantic versioning*, which uses a numeric format with a specific structure: *<MAJOR>.<MINOR>.<PATCH>*.  These different levels are meant to imply different degrees of backwards-compatibility:

- *Major* version changes (e.g. 1.1.3 -> 2.0.0) are meant to imply changes that are likely to break previously working code, such as changes in the API
- *Minor* version changes (e.g., 1.2.4 -> 1.3.0) are meant to imply the backwards-compatible addition of features
- *Patch* version changes (e.g. 1.2.4 -> 1.2.5) are meant to imply backwards-compatible bug fixes

Because the line between different kind of changes can be fuzzy, it's always good to be clear about the exact nature of changes in a change log.  Also note that "0.x.x" generally implies that the code is unstable, so things can break between any of the version types; in other cases, researchers will use tags to further delineate versions:

- *alpha* versions (e.g. 1.0.0a1) are meant to imply that the code is too early for general use
- *beta* versions (e.g. 1.2.1b1) are meant to imply that the software is in beta-testing mode
- *release candidate* versions (e.g. 1.5.3rc1) are meant imply an early release of the code for final testing by users before the official release

Another approach that is sometimes used in large projects is *calendar versioning*, where the version of based on the year and date (e.g. 25.2 for the second release of 2025).  For most projects the semantic versioning approach is preferred since it more clearly signals the nature of the change, but in some cases users may want to be able to tie the software to specific points in time.  

### Preparing code for sharing

Before sharing code, it's important to make sure that it is ready to share, which involves three important steps: sanitization, portability, and documentation.  It's useful before releasing code to do an audit using an AI coding tool to ensure that each of these has been addressed prior to release.

#### Sanitization

The goal of sanitization is to make sure that no private or sensitive information is shared along with the code.  This includes:

- passwords or other credentials
- API keys or tokens
- Protected Health Information (PHI) or Personally Identifiable Information (PII)

The most powerful tool for santization is the `.gitignore` file, which helps prevent files from being checked into a *git* repository by preventing them from appearing in the status or from being added (unless the `-f` flag is used to force an add).  Any files containing private or sensitive information (such as environment files or config files) should be added to the `.gitignore` file as soon as they are created.  If you are sharing a package that requires configuring these files, then it can be useful to include an example version (e.g. `.env.example`) that shows the structure of the file without including any private information.  

#### Ensuring portability

We have already discussed coding portably in Chapter 3, by which I mean ensuring that there are no configuration details in the code that would prevent the code from running on another machine. By far the most common portability issue is the inclusion of absolute file paths, which are unlikely to resolve properly on a different computer.  

#### Documentation

I have already discussed documentation in Chapter 7.  If you didn't generate documentation during the creation of the code, it's definitely important to create at least minimal documentation prior to release.  See the previous section for more details on how to create good documentation.

### Publishing software packages

If your code involves a module that others might want to reuse, then it's worth considering publishing it to a package repository. This makes it easy for anyone to install your software with a single command, rather than requiring a download of the code followed by installation.  The most widely used package index in the Python ecosystem is the [Python Package Index](https://pypi.org/) (known as *PyPI*); if you have ever used the *pip* package installer to install a Python package, then you have used PyPI as it is the default package index for *pip*.  In the *Conda* ecosystem, another popular package index is [*conda-forge*](https://conda-forge.org/), which can be used with the `conda install` command. Both of these systems allow versioning, so that users can install a specific version of the package to facilitate reproducibility.  Here I will focus on PyPI and *uv* as an example.

#### Making a package installable

To make a package installable, the first step is to create a `pyproject.toml` which is now the standard configuration file for Python projects (replacing the older `setup.py` and `setup.cfg`).  One important setting is the choice of *build backend*, which is the system that is used to generate the Python package files. For this example I will use the *uv_build* backend that is now the default for *uv* projects.  There are two types of files generated when the package is built.  One, known as an *sdist* (for "source distribution"), is basically a tar archive containing the code and metadata.  This allows the building of the package across different platforms, and serves as a transparent view of the code in the package.  The other, known as a *wheel*, is a pre-built version of the package; if the package is pure Python then this will be a platform-independent package, whereas if there is any compiled code (such as C code) then this will be specific to the platform where it was compiled.  Using the wheel can save time for large projects where building the package can take significant time.

To build the [bettercode](https://github.com/BetterCodeBetterScience/bettercode) package using *uv*, we simply run the build command:

```bash
$  uv build
Building source distribution...
Building wheel from source distribution...
Successfully built dist/bettercode-0.1.0.tar.gz
Successfully built dist/bettercode-0.1.0-py3-none-any.whl
```
Note that the wheel file has `-none-` in its name, which refers to the fact that it is platform-independent.  Once the package is built it is ready to push to PyPI.

#### Publishing packages to PyPI

Once the package is built, then we can upload it to PyPI for distribution.  We first need to ensure that the version information is correct.  This matters less for the first upload, but once you have uploaded a release to PyPI then you will need update the version for future uploads to work.  *uv* has a useful `version` option that that allows easily *bumping* the version according to the kind of change that is being made. For example, if we wanted to make a minor version change, we could do this:

```bash
$ uv version
bettercode 0.1.0
$ uv version --bump minor
bettercode 0.1.0 => 0.2.0
```

This changes the metadata in `pyproject.toml` to match the new version, though we would need to rerun the `uv build` command to create the build files for the new version.  Next we need to create and/or log into our account on [PyPI](https://pypi.org/), and then make sure that the project name (specified as the "name" variable in `pyproject.toml`) is not already in use (by searching the index for that name); if it is then we will have to change the name of the project. Assuming it isn't then we need to set up our PyPI authentication credentials and download a token, which can be provided at the command line with the `publish` command:

```bash
$  uv publish --token <your token here>
Publishing 2 files to https://upload.pypi.org/legacy/
Uploading bettercode-0.2.0.tar.gz (15.7MiB)
Uploading bettercode-0.2.0-py3-none-any.whl (15.7MiB)
```

If the publish command is successful, then the project should be visible on PyPI, as this one is at [https://pypi.org/project/bettercode/](https://pypi.org/project/bettercode/).  It's also possible to automate the generation of new PyPI releases using GitHub Actions; see the *uv* documentation for more details.

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

### Sharing containers
Containers (Docker vs. Singularity/Apptainer for HPC).
