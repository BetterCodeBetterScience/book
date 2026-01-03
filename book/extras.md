## for Intro

- discuss Naur, "Programming as theory building"

## for essentials

- discuss databases - e.g., sqlite example


## from AI-assisted coding chapter

## github spec kit

## More on MCP?

## AI-human pair programming

We often view AI coding agents as autonomous 

## Leveraging LLM coding for reproducibility

LLM-based chatbots can be very useful for solving many problems beyond coding.  For example, we recently worked on a paper with more than 100 authors, and needed to harmonize the affiliation listings across authors.  This would have been immensely tedious for a human, but working with an LLM we were able to solve the problem with only a few manual changes needed.  Other examples where we have used LLMs in the research process include data reformatting and summarization of text for meta-analyses.  However, as noted above, the use of chatbots in scientific research is challenging from the standpoint of reproducibility, since it is generally impossible to guarantee the ability to reproduce an LLM output; even if the random seed is fixed, the commercial models change regularly, without the ability to go back to a specific model version.  

The ability to LLMs to write code to solve problems provides a solution to the reproducibility challenge: instead of simply using a chatbot to solve a problem, ask the chatbot to generate code to solve the problem, which makes the result testable and reproducible.  This is also a way to solve problems with information that you don't want to submit to the LLM for privacy reasons.

For example, ...

# Project structure


## Python modules

While Python has native access to a small number of functions, much of the functionality of Python comes from *modules*, which provide access to objects defined in separate files that can be imported into a Python session.  All Python users will be familiar with importing functions from standard libraries (such as `os` or `math`) or external packages (such as `numpy` or `pytorch`). It's also possible to create one's own modules simply by putting functions into a file.

Let's say that we have a set of functions that do specific operations on text, saved to a file called `textfuncs.py` in our working directory:

```
def reverse(text):
    return text[::-1]

def capitalize(text):
    return text.capitalize()

def lowercase(text):
    return text.lower()
```

If we wish to use those functions within another script ('mytext.py'), we can simply import the module and then run them:

```
import textfuncs

def main():
    mytext = "Hello World"
    print(mytext)
    print(textfuncs.reverse(mytext))
    print(textfuncs.capitalize(mytext))
    print(textfuncs.lowercase(mytext))

if __name__ == "__main__":
    main()
```

Giving the results:

```
❯ python mytext.py
Hello World
dlroW olleH
Hello world
hello world
```

```{admonition} Antipattern
It's not uncommon to see Python programmers use *wildcard imports*, such as `from mytext import *`.  This practice is an antipattern and should be avoided, because it can make it very difficult to debug problems with imported functions, particularly if there is a wildcard import from more than one module.  It can also result in collisions if two modules have a function with the same name, and can prevent linters from properly analyzing the code.  It's better practice to explicitly import all objects from a module, or to use fully specified paths within the module.

R users might notice that this antipattern is built into the way that library functions are usually imported in R: In general, when one imports a library the functions are made available directly in the global namespace.  For example, if we load the `dplyr` library we will see several errors regarding objects being masked:

````
> library(dplyr)

Attaching package: ‘dplyr’

The following objects are masked from ‘package:stats’:

    filter, lag

The following objects are masked from ‘package:base’:

    intersect, setdiff, setequal, union
````

This means that if we call `filter()` it will now refer to `dplyr::filter()` rather than the default reference to `stats::filter()`.  This can cause major problems when one adds library imports during the development process, since those later additions can mask functions that had worked without disambiguation before.  For this reason, when coding in R it's always good to use the full disambiguated function call for any functions with generic names like "select" or "filter".

```

### Creating a Python module using uv




### Practical principles for scientific data management

This chapter will lay out a set of approaches for effective data management, which are built around a set of principles that I think are useful and practical for researchers:

- Original data should be immutable (read-only)
- Original data should be backed up on a separate system
- Data access should operate according to the principle of least privilege
- All data processing operations should be reproducible
    - Thus, manual operations should be minimized and extensively documented
- File/folder names should be machine-readable
- Open and non-proprietary file formats should be used whenever possible
- The provenance of any file should be findable
- All data should be documented so that the user can determine the identity of any variable in the dataset
- Changes to the data should be tracked
    - Either via VCS or some other strategy
- When working with secondary data, always know your rights and responsibilities
- Understand the data storage/retention/deletion requirements for your data



##### Timeseries databases

Timeseries data represent repeated measurements over time, and are ubiquitous in science, from 
Timeseries data have several features that can be leveraged to optimized storage and querying:

- They are naturally ordered in time
- Operations mostly involve appending new data, rather than modifying older data
- Queries are usual defined by specific ranges of time, rather than random queries

Timeseries databases like InfluxDB are optimized to represent and query timeseries data.  By taking advantage of the unique structure of timeseries data, they can query these data much more efficiently than other databases that are not optimized. 




#### Column-family databases

A column-family database is built to effectively store and retrieve very large datasets where there are many columns for each row, and where the columns may be grouped together into *families*.  These databases are purpose-built for the processing of large datasets that may be distributed across multiple computers. An important difference from a standard data frame representation is that each row doesn't have to have any entry for every column, which allows much more efficient storage and retrieval of sparse data.  They are also very efficient for tasks that involve a large number of database writes, such as high-throughput data collection devices.  Well-known column-family databases include Apache Cassandra, Apache HBase, and Google Bigtable.

- Cassandra example



As an example, let's upload the demographic data from the Eisenberg et al. (2019) into a SQL database using SQLite, which is a very lightweight database package, and perform some example queries. We can create the database and load the data using the following code:

```python
demographics_df = pd.read_csv("https://raw.githubusercontent.com/IanEisenberg/Self_Regulation_Ontology/refs/heads/master/Data/Complete_02-16-2019/demographics.csv", index_col=0)
# recode sex based on data dictionary: {1: 'F', 0: 'M'}
demographics_df['Sex'] = demographics_df['Sex'].map({1: 'F', 0: 'M'})

# Create an SQLite database 
database_name = 'demographics.db'
with sqlite3.connect(database_name) as conn:
    # Load the DataFrame into the SQLite database
    demographics_df.to_sql('demographics', conn, 
                        if_exists='replace', index=False)

    # Verify the table was created
    cursor = conn.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    print("Tables in database:", cursor.fetchall())
```
```bash
Tables in database: [('demographics',)]
```

We can see that the demographics table was created in the database; a production-level SQL server such as MySQL or MariaDB would store this information in a separate location, possibly on a different machine where the server runs, whereas SQLite stores it in a local file.  Now let's say that we wanted to count how many records there are for each sex.  We do this by creating a SQL query that computes the count of the variable separately for each group. Here we use the pandas `read_sql_query` function, which is a handy function to convert the output of an SQL database query into a Pandas data frame:

```python
SELECT Sex, COUNT(*) as count 
FROM demographics 
GROUP BY Sex
ORDER BY count DESC
"""
with sqlite3.connect(database_name) as conn:
    result_df = pd.read_sql_query(query, conn)
print("Count by sex:")
print(result_df)
```
```bash
Count by sex:
  Sex  count
0   F    262
1   M    260
```

We can also create a query to further summarize data, in this case computing the mean height for each sex:

```python
query = """
SELECT Sex, 
       ROUND(AVG(HeightInches), 2) as avg_height
FROM demographics 
GROUP BY Sex
"""
with sqlite3.connect(database_name) as conn:
    result_df = pd.read_sql_query(query, conn)
    
print("Height statistics by sex:")
print(result_df)
```
```bash
Height statistics by sex:
  Sex  avg_height
0   F       64.48
1   M       70.01
```

This example highlights the fluidity with which one can move between data frames and relational databases, since they fundamentally have the same underlying structure.

### Pymongo example


One of the most popular document stores is [MongoDB](https://www.mongodb.com/). The MongoDB software can be installed locally on one's own computer, but for this example I will take advantage of the free *Atlas* hosting service that MongoDB offers.  After logging into [MongoDB](https://www.mongodb.com/) (which I did using my Github credentials), I was asked to select the kind of cluster that I wanted to create, for which I chose the *Free* tier, and I named it "testcluster".  The site then provides information on how to connect, along with a username and password, which I saved to my `.env` file as `MONGO_USERNAME` and `MONGO_PASSWORD`.  After creating the database user, the database is now running, and the site provides us with a full code snippet showing how to connect to the database within Python:

```python
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
import dotenv
import os

dotenv.load_dotenv()
assert 'MONGO_USERNAME' in os.environ and 'MONGO_PASSWORD' in os.environ, 'MongoDB username and password should be set in .env'

uri = f"mongodb+srv://{os.environ['MONGO_USERNAME']}:{os.environ['MONGO_PASSWORD']}@testcluster.n3ilcua.mongodb.net/?appName=testcluster"

# Create a new client and connect to the server
client = MongoClient(uri, server_api=ServerApi('1'))
# Send a ping to confirm a successful connection
try:
    client.admin.command('ping')
    print("Pinged your deployment. You successfully connected to MongoDB!")
except Exception as e:
    print(e)
```
```bash
Pinged your deployment. You successfully connected to MongoDB!
```

Now we can create a new database table. In this example we will store bibliographic data obtained from the PubMed database for a particular search query, using a set of functions defined the `pubmed` module.

```python
import pubmed

results = pubmed.get_processed_query_results('"fMRI"', retmax=10000, verbose=True)
print(f'found {len(results)} results')
```
```bash
searching for "fMRI"
found 9999 matches
found 9941 results
```

The results are returned as a dictionary that is keyed by the DOI for the publication and includes a set of elements representing the various parts of the PubMed record, as in this example record:

```python
{'DOI': '10.1093/cercor/bhaf238',
 'Abstract': 'The SPM software package played a major role in the establishment of open source software practices within the field of neuroimaging. I outline its role in my career development and the impact it has had within our field.',
 'PMC': None,
 'PMID': 40928748,
 'type': 'journal-article',
 'journal': 'Cereb Cortex',
 'year': 2025,
 'volume': '35',
 'title': 'SPM as a cornerstone of an open source software ecosystem for neuroimaging.',
 'page': None,
 'authors': 'Poldrack RA'}
```

The Python interface to MongoDB take dictionaries as input, so we can convert the dictionary into a list of separate dictionaries for each publication and then add these to the collection:

```python
from pymongo import UpdateOne

# In MongoDB, databases and collections are created lazily (when first document is inserted)
db = client['research_database']
publications_collection = db['publications'] 

# Clear existing data in the collection (optional, for clean start)
publications_collection.delete_many({})

# Convert results dictionary to list of documents
documents = [document for document in results.values()]

# Insert all documents into the collection
# Create a unique index on PMID to prevent duplicates
publications_collection.create_index("PMID", unique=True)

if documents:
    # Use bulk_write with upsert operations to update existing or insert new documents
    operations = [
        UpdateOne(
            {"PMID": doc["PMID"]},  # Filter by PMID
            {"$set": doc},  # Update the document
            upsert=True  # Insert if it doesn't exist
        )
        for doc in documents
    ]
    
    result = publications_collection.bulk_write(operations)
    print(f"Successfully upserted {result.upserted_count} new publications")
    print(f"Modified {result.modified_count} existing publications")
    print(f"Total operations: {len(operations)}")
else:
    print("No documents to insert")

# Verify insertion by counting documents
count = publications_collection.count_documents({})
print(f"Total publications in collection: {count}")
```
```bash
Successfully upserted 9941 new publications
Modified 0 existing publications
Total operations: 9941
Total publications in collection: 9941
```

Now that the documents are in the database, we can search for documents that match a specific query.  For example, let's say that we want to find all papers that include the term "Memory" (in a case-insensitive manner) in the title:

```python
query = {"title": {"$regex": "Memory", "$options": "i"}}  # Case-insensitive search for "Memory"
memory_pubs = list(publications_collection.find(query))
print(f"Found {len(memory_pubs)} publications containing {query['title']['$regex']} in the title")
```
```bash
Found 422 publications containing Memory in the title
```

One very nice feature of the document store is that not all records have to have the same keys; this provides a great deal of flexibility at data ingestion.  However, too much heterogeneity between documents can make the database hard to work with.  One benefit of homogeneity in the document structure is that it allows indexing, which can greatly increase the speed of queries in large document stores.  For example, if we know that we will often want to search by the `year` field, then we can add an index for this field:

*MORE HERE*


### NARPS

The example comes from a paper that we published in 2020 {cite:p}`Botvinik-Nezer:2020aa`, which involved analysis of data from a large study called the Neuroimaging Analysis Replication and Prediction Study (hereafter *NARPS* for short).  The goal of this study was to identify how the results of data analysis varied between different research groups when given the same data.  A relatively large neuroimaging dataset was collected and distributed to groups of researchers, who were asked to test a set of nine hypotheses about brain activity in relation to a monetary gambling task that the participants performed during MRI scanning.  Seventy teams submitted results, which included their answers to the 9 yes/no hypotheses along with a detailed description of their analysis workflow and a number of outputs from intermediate stages of the analysis. The main finding was that there was a striking amount of variability in the results between teams, even though the raw data were identical.

The workflow that I will use here starts with the results that the teams submitted, and ends with preprocessed data that are ready for further statistical analysis.  I wrote much of the original analysis code for the project, which can be found [here](https://github.com/poldrack/narps).  This code was written at the point when I was just becoming interested in software engineering practices for science, and while it represents a first step in that direction, it has *a lot* of problems. In particular, it uses the problematic *God object* anti-pattern that I mentioned in an earlier chapter.  For the purposes of this chapter I have first rewritten the analysis into a monolithic mega-script, which I will then incrementally refactor into a well-structured workflow.  I chose this example because it is relatively complex yet runs quickly on any modern laptop.  


## Workflows chapter


I asked Claude Code to help with this:

> I would like to modify the workflow described in src/bettercode/rnaseq/modular_workflow/run_workflow.py to make it execute in a stateless way through the use of checkpointing.  Please analyze the code and suggest the best way to accomplish this.

After analyzing the codebase Claude came up with three proposed solutions to the problem:

- 1. Use a "registry pattern" in which we define each step in terms of its inputs, outputs, and checkpoint file, and then assemble these into a workflow that can be executed in a stateless way, automatically skipping completed steps.  This was its recommended approach.
- 2. Use simple "wrapper" approach in which each module in the workflow is executed via a wrapper function that checks for cached checkpoint values.
- 3. Use a well-established existing workflow engine such as [Prefect](https://www.prefect.io/) or [Luigi](https://github.com/spotify/luigi). While these are powerful, they incur additional dependencies and complexity and may be too heavyweight for our problem.

Here we will examine the first (recommended) option and the third solution; while the second option is easy to implement, it's not as clean as the registry approach.

### A workflow registry with checkpointing

We start with a custom approach in order to get a better view of the details of workflow orchestration. It's important to note that I generally would not recommend building one's one custom workflow manager, at least not before trying a general-purpose workflow engine, but I will show an example of a custom workflow engine in order to provide a better understanding of the detailed process of workflow management.  We start with a prompt:

> let's implement the recommended Stateless Workflow with Checkpointing.  Please generate new code within src/bettercode/rnaseq/stateless_workflow.

The resulting code worked straight out of the box, but it didn't maintain any sort of log of its processing, which can be very useful.  In particular, I wanted to log the time required to execute each step in the workflow, for use in optimization that I will discuss further below.  I asked Claude to add this:

> I would like to log information about execution, including the time required to execute each step along with the details about execution such as parameters passed for each step.  please record these during execution and save to a date-stamped json file within the workflows directory.

After Claude's implementation of this feature, a fresh run of the workflow gives the following summary:

```bash
============================================================
EXECUTION SUMMARY
============================================================
Workflow: immune_aging_scrnaseq
Run ID: 20251221_114458
Status: completed
Total Duration: 7094.5 seconds

Step Details:
------------------------------------------------------------
  ✓ Step 1: data_download                 0.0s [cached]
  ✓ Step 2: filtering                    74.7s
  ✓ Step 3: quality_control             263.3s
  ✓ Step 4: preprocessing                35.9s
  ✓ Step 5: dimensionality_reduction   6565.4s
  ✓ Step 6: clustering                   69.6s
  ✓ Step 7: pseudobulking                11.6s
  ✓ Step 8: differential_expression      19.0s
  ✓ Step 9: gsea                          1.7s
  ✓ Step 10: overrepresentation           13.3s
  ✓ Step 11: predictive_modeling          39.8s
------------------------------------------------------------
```

The associated JSON file contains much more detail regarding each workflow step.  If we run the workflow again, we see that it now uses cached results at each step:

```bash
============================================================
EXECUTION SUMMARY
============================================================
Workflow: immune_aging_scrnaseq
Run ID: 20251221_142225
Status: completed
Total Duration: 17.4 seconds

Step Details:
------------------------------------------------------------
  ✓ Step 1: data_download                 0.0s [cached]
  ✓ Step 2: filtering                     1.9s [cached]
  ✓ Step 3: quality_control               3.0s [cached]
  ✓ Step 4: preprocessing                 3.1s [cached]
  ✓ Step 5: dimensionality_reduction      3.4s [cached]
  ✓ Step 6: clustering                    4.3s [cached]
  ✓ Step 7: pseudobulking                 0.1s [cached]
  ✓ Step 8: differential_expression       1.4s [cached]
  ✓ Step 9: gsea                          0.0s [cached]
  ✓ Step 10: overrepresentation            0.0s [cached]
  ✓ Step 11: predictive_modeling           0.0s [cached]
------------------------------------------------------------
```

Checkpointing thus solved our problem, by allowing each step to be skipped over once it's been completed.

#### Checkpointing and disk usage

One potential drawback of checkpointing is that it can result in substantial disk usage when working with large datasets. In the example above, the checkpoint directory after workflow completion weighs in at a whopping 64 Gigabytes, with numerous very large files:

```bash
➤  du -sh *

7.3G    step02_filtered.h5ad
 13G    step03_qc.h5ad
 13G    step04_preprocessed.h5ad
 14G    step05_dimreduced.h5ad
 14G    step06_clustered.h5ad
380M    step07_pseudobulk.h5ad
 28M    step08_counts.parquet
1.6M    step08_de_results.parquet
1.8G    step08_stat_res.pkl
 13M    step09_gsea.pkl
 44K    step10_enr_down.pkl
 28K    step10_enr_up.pkl
 36K    step11_prediction.pkl
 ```

In particular, in step 3 a copy of the original data was added for reuse in a later step (in a separate variable within the dataset) alongside the results of processing at that step, leading to files that were roughly doubled in size.  However, those raw data were not needed again until step 7.  By changing the workflow to avoid saving those data in the checkpoints and instead loading them directly at step 7, we were able to halve the size of those intermediate checkpoints.

In this implementation a checkpoint file was stored for each step in the workflow.  However, if the goal of checkpointing is primarily to avoid having to rerun expensive computations, then we don't need to checkpoint every step given that some of them take relatively little time.  In this case, we can checkpoint only after a subset of steps.  In this case I chose to checkpoint after steps 2, 3, and 5 since those each take well over a minute to run (with step 5 taking well over an hour).  Another goal of checkpointing is to store files that might be useful for later analyses or QA by the researcher.  In this example workflow, steps 1-7 can be classified as "preprocessing" in the sense that they are preparing the data for analysis, whereas steps 8-11 reflect actual analyses of the data, such that the results could be reported in a publication.  It is thus important to save those outputs for later analyses and for sharing with the final results.

#### Compressing checkpoint files

Another potentially helpful solution is to compress the checkpoint data if they are not already being compressed by default.  In this example, the default in the AnnData package for saving `h5ad` files is to use no compression, so there are substantial savings in disk space to be had by compressing the data: whereas the raw data file was 7.3 GB, a version of the same data saved using compression took up only 2.9 GB.  The tradeoff is that working with compressed files takes longer.  This is particularly the case for saving of files; whereas it took about 3 seconds to save an uncompressed version of the data, it took about 105 seconds to store the compressed version.  Given that the saving of the compressed file will happen in the context of an already long workflow, that doesn't seem like such a concern.  We are more concerned about how the use of compression increases loading times, and here the difference is not quite so dramatic, at 1.3 seconds versus 19.8 seconds.  The decision about whether or not to compress will ultimately come down to the relative cost of time versus disk space, but in this case I decided to go ahead and compress the checkpoint files.

Combining these strategies of reducing data duplication, eliminating some intermediate checkpoints, and compressing the stored data, our final pipeline generates about 13 GB worth of checkpoint data, substantially smaller than the initial 64 GB.  With all checkpoints generated, the entire workflow completes in less than four minutes, with only three time-consuming steps being rerun each time.   The initial execution of the workflow is a few minutes longer due to the extra time needed to read and write compressed checkpoint files, but these few minutes are hardly noticeable for a workflow that takes more than two hours to complete.

The use of a modular architecture for our stateless workflow helps to separate the actual workflow components from the execution logic of the workflow.  One important benefit of this is that it allows us to plug those modules into any other workflow system, and as long as the inputs are correct it should work. We will see that next when we create new versions of this workflow using two common workflow engines.


#### Logging


- talk about logging issues that arose - see changes in commit 1cdbc54b159bf677

```

⏺ I see the problem. The scripts use print() which outputs to stdout, but Snakemake's log: directive only captures stderr by default. The stdout output is lost.

  There are two approaches to fix this:

  1. Quick fix: Redirect stdout to stderr in scripts
  2. Better fix: Use Python's logging module to write to the log file

  Would you like me to update the scripts to properly log to the log files? The cleanest approach is to configure Python's logging module to write to snakemake.log[0] at the start of each script.

  Here's what a fixed script would look like:

  import sys
  import logging

  # Configure logging to write to snakemake log file
  logging.basicConfig(
      level=logging.INFO,
      format="%(asctime)s - %(levelname)s - %(message)s",
      handlers=[
          logging.FileHandler(snakemake.log[0]),
          logging.StreamHandler(sys.stderr),  # Also show in terminal
      ],
  )
  logger = logging.getLogger(__name__)

  # Then use logger.info() instead of print()

  This would write to both the log file and stderr (visible in terminal).

```

