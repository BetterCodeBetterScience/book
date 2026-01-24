# Optimizing performance (TBD)

The computing power available to scientists has increased in a shockingly consistent way since the first microprocessors were manufactured in the 1970's.  The left panel in [](@mooreslaw-fig) shows that the number of transistors on commercial CPU chips has doubled about every two years since the 1970s, very close to the two years predicted by Gordon Moore in 1965 [@Moore:1965] The number of transistors relates only indirectly to the computing power of the machine, and the right panel in [](@mooreslaw-fig) shows that the computer power of the world's top supercomputer (measured in the number of floating point operations per second) has increased even faster, doubling roughly every 1.2 years. 

```{figure} images/moores_law_comparison.png
:label: mooreslaw-fig
:align: center
:width: 700px

A plot of increased computing power over time.  Left panel shows log transistor count in commercially available microprocessors over time, based on data from [Wikipedia](https://en.wikipedia.org/wiki/Transistor_count).  The plot shows a consistent logarithmic increase in transistor count, with an estimated doubling time of about 2.16 years. Right panel shows performance of the world's top supercomputer (in log GigaFLOPS - million floating point operations per second), showing an even faster doubling time of about 1.2 years, based on data obtained from [Wikipedia](https://en.wikipedia.org/wiki/History_of_supercomputing).  
```

To put this into a personal perspective, I published my first paper using computer simulations in 1996 [@Poldrack:1996aa], based on simulations I had performed in 1994-5 as a graduate student.  I ran my simulations on a Power Macintosh, and I remember them taking many hours to complete, but let's say that I had access to the top supercomputer of the day back in 1994. The top supercomputer in 2005 was more than *ten million* times faster than the top machine in 1994. If simulation time scaled directly with processor speed, this would mean that a simulation that takes one minute on the latest machine would have taken over *19 years* in 1994! This kind of scaling is not generally true; as we will discuss below and in the next chapter on high-performance computing, there are many factors beyond CPU speed that can limit the speed of computing operations. 

I raise these comparisons to highlight the fact that any attempts to optimize the performance of our code will often be much less effective than simply finding a more powerful computer.  However, it's often the case that small changes in our code can have significant performance impacts. In this chapter I will highlight the ways in which one can judiciously optimize with the performance of code without significantly impacting the quality of the code.


## Avoiding premature optimization

Donald Knuth, one of the founders of the modern field of computer science, is famous for saying the following about code optimization:

> The real problem is that programmers have spent far too much time worrying about efficiency in the wrong places and at the wrong times; premature optimization is the root of all evil (or at least most of it) in programming. - Donald Knuth

I think that it's important to know how to optimize code, but also important to know when to optimize code and when not do do so.  In their book *The Elements of Programming Style*, {cite:t}`Kernighan:1978aa` proposed a set of organizing principles for optimization of existing code, which highlight the tradeoffs involved in optimization:

- "Make it right before you make it faster"
- "Make it clear before you make it faster"
- "Keep it right when you make it faster"

That is, there is a tradeoff between accuracy, clarity, and speed that one must navigate when optimizing code.  I would focus on optimization after you have code that runs on a small example problem, and any of the following occurs:

- Something simple seems like it's taking much longer than it seems like it should
- Scaling to larger problems takes exceedingly long and you don't have access to a larger computer system


## A brief introduction to computational complexity

Computational complexity refers to how the time needed by a particular algorithm to solve a particular problem increases with the size of its input. We usually describe complexity in terms of what is known as "big-O" notation, describing how the time needed to solve the problem scales with the size of the input.  More precisely, it provides an upper bound on the time scaling, ignoring constant factors.  For example, an $O(N)$ problem scales linearly in time with the input, an $O(N^2)$ problem scales quadratically, and an $O(2^N)$ scales exponentially.  It's important to keep in mind that these not meant to reflect actual performance, but rather meant to classify problems in terms of their worst-case difficulty as the input grows.  The fact that constant factors are ignored also means that complexity differences may not become evident in real performance until inputs get very large.

There are two aspects of complexity that are important to understand.  First, any particular problem has a lower bound on its complexity, such that no algorithm can perform better than this bound.  For example, finding the minimum of a list of numbers is $O(N)$, since finding the minimum requires looking at all of the numbers. Sorting a list, on the other hand, is $O(N log N)$, because it takes about $log N$ splits of a list to get to the individual elements.  Second, different algorithms will have different complexity for the same problem.  For example, merge sort (which recursively splits lists into half and then interleaves them) achieves the lower bound of $O(N log N)$ since an $O(N)$ operation is required for each merge.  On the other hand, bubble sort, which repeatedly scans the list and swaps elements that are out of order, is $O(N^2)$ since each scan is $O(N)$ and it can take up to N scans, and thus fails to achieve optimal performance.

One important place where complexity is useful, and a bit tricky, is in thinking about loops. It's generally not possible to tell the complexity implications from the looping structure itself, since it depends on what is being done within each loop. For example, take the following function:

```python
def find_duplicates(items):
    duplicates = []
    for item in items:
        if items.count(item) > 1 and item not in duplicates:
            duplicates.append(item)
    return duplicates
```

This might seem like it would be $O(N)$ since it simply loops through the items.  However, if we look at the operations that are being performed, we see that the `.count()` operation is $O(N)$ (since it needs to look at all items) and the `item not in duplicates` needs to traverse an unknown portion of the list depending on the number of duplicates. Thus, this procedure is $O(N^2)$, since the count operation alone is $O(N)$ and must be performed N times.  On the other hand, take the following code:

```python
def validate_records(records):
    for record in records:
        for field in ['name', 'email', 'phone']:
            validate_field(record, field)
```

This has two levels of looping, but only one of the levels scales with the number of records, so it is still $O(N)$. 

## Code profiling

Complexity analysis tells us about the worst case performance of our code, but there are many reasons for slow code that are unrelated to complexity.  *Profiling* is the activity of empirically analyzing the performance of our code in order to identify specific parts of the code that might cause poor performance.  It's often the case that slow performance arises from specific portions of the code, which we refer to as *bottlenecks*.  These bottlenecks can be difficult to intuit, which is why it's important to empirically analyze performance in order to identify the location of those bottlenecks,  which can then help us focus our efforts.  However, it's also important to keep complexity in mind when we analyze code; in particular, we should always profile the code using realistic input sizes, so that we will see any complexity-related slowdowns if they exist.

There are a couple of important points to know when profiling code. First, it's important to remember that profiling has overhead and can sometimes distort results. In particular, when code involves many repetitions of a very fast operation, the overhead due to profiling the operation can add up, making it seem worse than it is.  The profiler can also compete with your code for memory and CPU time, potentially distorting results (e.g. for processes involving lots of memory).  Second, it's important to keep in mind the distinction between *CPU time*, which refers to the time actually spent by the CPU doing processing, and *wall time*, which includes CPU time as well as time due to other sources such as input/output. If the wall time is much greater than the CPU time, then this suggests that optimizing the computations may not have much impact on the overall execution time.  

### Function profiling

Function profiling looks at the execution time taken by each function.  Let's say that we have two different implementations of a function, in this case using functions to find duplicates in an array of numbers, where one is efficient and one is inefficient:

```python
def find_duplicates_inefficient(data):
    duplicates = []
    seen = []
    
    for item in data:
        if item in seen:  
            if item not in duplicates:  
                duplicates.append(item)
        else:
            seen.append(item)
    
    return duplicates


def find_duplicates_efficient(data):
    duplicates = set()
    seen = set()
    
    for item in data:
        if item in seen:
            duplicates.add(item)
        else:
            seen.add(item)
    
    return list(duplicates)

```

These functions look remarkably similar, so it wouldn't be obvious that one is much slower than the other unless we know the details of Python data structures.  We can use the `cProfile` package to profile these two functions (with some additional printing statements removed):

```python
import cProfile
import pstats
import io
import numpy as np

def compare_duplicate_finding(data_size=10000):
    data = list(range(data_size)) + list(range(data_size // 2))
    np.random.shuffle(data)
    
    profiler = cProfile.Profile()
    profiler.enable()
    result = find_duplicates_inefficient(data)
    profiler.disable()

    s = io.StringIO()
    ps = pstats.Stats(profiler, stream=s).sort_stats("cumulative")
    ps.print_stats(10)

    # Profile efficient version with set
    profiler = cProfile.Profile()
    profiler.enable()
    result = find_duplicates_efficient(data)
    profiler.disable()

    s = io.StringIO()
    ps = pstats.Stats(profiler, stream=s).sort_stats("cumulative")
    ps.print_stats(10)
```

The output shows the relative timing of each of the functions:

```bash

Profiling duplicate finding with list (data_size=10000):
(Using 'if item in seen_list' is O(n) each time)
--------------------------------------------------------------------------------
         15002 function calls in 0.310 seconds

   Ordered by: cumulative time

   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
        1    0.308    0.308    0.310    0.310 /Users/poldrack/Dropbox/code/BetterCodeBetterScience/bettercode/src/bettercode/profiling_example.py:72(find_duplicates_inefficient)
    15000    0.001    0.000    0.001    0.000 {method 'append' of 'list' objects}
        1    0.000    0.000    0.000    0.000 {method 'disable' of '_lsprof.Profiler' objects}


Profiling duplicate finding with set (data_size=10000):
(Using 'if item in seen_set' is O(1) each time)
--------------------------------------------------------------------------------
         15002 function calls in 0.002 seconds

   Ordered by: cumulative time

   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
        1    0.001    0.001    0.002    0.002 /Users/poldrack/Dropbox/code/BetterCodeBetterScience/bettercode/src/bettercode/profiling_example.py:92(find_duplicates_efficient)
    15000    0.001    0.000    0.001    0.000 {method 'add' of 'set' objects}
        1    0.000    0.000    0.000    0.000 {method 'disable' of '_lsprof.Profiler' objects}
```

Here we can see that there is a huge difference in the time taken by the two functions (0.31 seconds versus 0.002 seconds). This is due to the fact that membership (`in`) operations on sets are $O(1)$ whereas membership operations on lists are $O(N)$.  Once they are put into a loop this becomes $O(N)$ versus $O(N^2)$, which can make a huge difference as the number of inputs increases.  

I also learned something quite interesting in the process of writing this example. I worked with Claude Code to generate code for examples of problems where there might be a subtle issue that could cause a bottleneck.  In several cases, Claude generated code that was meant to demonstrate major performance bottlenecks, but the bottlenecks didn't actually occur.  The reason was that those particular issues were once problematic, but the latest version of the CPython interpreter (the standard implementation of Python) is now optimized to eliminate the bottlenecks!  This highlights the importance of verifying claims made by coding agents rather than blindly trusting them.

### Line profiling

Line profiling digs even more deeply to measure the time taken to execute each line in the code.  We can do this with the same code as above, simply by adding a `@profile` decorator to each of the functions:

```python
@profile
def find_duplicates_inefficient(data):
    ...
```

We can then run line profiling using the `kernprof` tool that is part of the `line_profiler` module (in this case using the command `kernprof -lv ine_profiling_example.py`), which gives the following output:

```bash
Total time: 0.31827 s
File: line_profiling_example.py
Function: find_duplicates_inefficient at line 34

Line #      Hits         Time  Per Hit   % Time  Line Contents
==============================================================
    34                                           @profile
    35                                           def find_duplicates_inefficient(data):
    36         1          0.0      0.0      0.0      duplicates = []
    37         1          0.0      0.0      0.0      seen = []
    38                                               
    39     15001       3715.0      0.2      1.2      for item in data:
    40     15000     262284.0     17.5     82.4          if item in seen: 
    41      5000      48610.0      9.7     15.3              if item not in duplicates:  
    42      5000       1246.0      0.2      0.4                  duplicates.append(item)
    43                                                   else:
    44     10000       2413.0      0.2      0.8              seen.append(item)
    45                                               
    46         1          2.0      2.0      0.0      return duplicates

Total time: 0.010041 s
File: line_profiling_example.py
Function: find_duplicates_efficient at line 49

Line #      Hits         Time  Per Hit   % Time  Line Contents
==============================================================
    49                                           @profile
    50                                           def find_duplicates_efficient(data):
    51         1          2.0      2.0      0.0      duplicates = set()
    52         1          0.0      0.0      0.0      seen = set()
    53                                               
    54     15001       3930.0      0.3     39.1      for item in data:
    55     15000       2831.0      0.2     28.2          if item in seen:
    56      5000        968.0      0.2      9.6              duplicates.add(item)
    57                                                   else:
    58     10000       2290.0      0.2     22.8              seen.add(item)
    59                                               
    60         1         20.0     20.0      0.2      return list(duplicates)

```

This confirms that the slowdown comes specifically from the lines in which `in` is used with a list rather than a set.  Even if we didn't know about the optimization of membership testing for Python sets, this would make it clear that those two lines are the place to look to learn more about the slowdown, due to the fact that they are so much longer than the first `in` usage.

### Memory profiling

Memory usage is another potential issue that we can investigate using profiling.  This becomes a particularly important issue when we start thinking about implementation of many jobs on a high-performance computing system, as we will discuss in the next chapter; these systems often require that one specifies not only how many CPU cores one requires for the job, but also how much memory.  



#### Memory profiling in Pandas

Pandas data frames can exhibit some surprising memory usage features, and memory profiling can often be useful to optimize pandas workflows.  `pandas` has a built-in memory profiling function for data frames, called `.memory_usage()`.  Here we will use this to see an example of a surprising memory usage feature.  We first create functions to generate a data frame with a number of string variables, and to analyze the memory footprint of the data frame:

```python
def create_sample_data(n_rows=100000):
    data = {
        'subject_id': range(n_rows),
        'condition': np.random.choice(['Control', 'Treatment_A', 'Treatment_B'], n_rows),
        'gender': np.random.choice(['Male', 'Female'], n_rows),
        'site': np.random.choice(['Site_Boston', 'Site_London', 'Site_Tokyo', 'Site_Sydney'], n_rows),
        'diagnosis': np.random.choice(['Healthy', 'Patient'], n_rows)
    }
    
    return pd.DataFrame(data)

def analyze_memory(df):

    print("\nMemory usage per column:")
    memory_usage = df.memory_usage(deep=True)
    for col, mem in memory_usage.items():
        print(f"  {col:15s}: {mem / 1024**2:8.2f} MB")
    
    total_memory = memory_usage.sum()
    print(f"\nTotal memory usage: {total_memory / 1024**2:.2f} MB")
    print("=" * 80)
    
    return total_memory

df = create_sample_data(n_rows=100000)

# Analyze with default string columns
string_memory = analyze_memory(df)
 
```
```
Memory usage per column:
  Index          :     0.00 MB
  subject_id     :     0.76 MB
  condition      :     5.59 MB
  gender         :     5.15 MB
  site           :     5.70 MB
  diagnosis      :     5.34 MB

Total memory usage: 22.55 MB
```

Now we convert the string columns to Categorical data types, which are represented in a much more compact way by `pandas`:

```python
categorical_cols = ['condition', 'gender', 'site', 'diagnosis']
df_categorical = df.copy()
for col in categorical_cols:
    df_categorical[col] = df_categorical[col].astype('category')

categorical_memory = analyze_memory(df_categorical)
```
```
Memory usage per column:
  Index          :     0.00 MB
  subject_id     :     0.76 MB
  condition      :     0.10 MB
  gender         :     0.10 MB
  site           :     0.10 MB
  diagnosis      :     0.10 MB

Total memory usage: 1.15 MB
```
This simple change led to almost 95% in reduction in the memory footprint of the data frame, providing an example of how memory profiling, combined with knowledge of how the relevant packages work with the data, can lead to massive improvements in memory footprint.


## Common sources of slow code execution

### Slow algorithm

A common source of slow execution is use of an inefficient algorithm.  Let's say that we want to find duplicate elements within a list.  A simple way to implement this could be perform nested loops to compare each item to each other.  This has computational complexity of *O(n^2)*.  

```python
import random
def create_random_list(n):
    return [random.randint(1, n) for i in range(n)]

def find_duplicates_slow(lst):
    duplicates = []
    for i in range(len(lst)):
        for j in range(i+1, len(lst)):
            if lst[i] == lst[j] and lst[i] not in duplicates:
                duplicates.append(lst[i])
    return duplicates

lst = create_random_list(10000)

%timeit find_duplicates_slow(lst)

833 ms ± 5.85 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)
```

We can speed this up substantially by using a dictionary and keeping track of how many times each item appears.  This only requires a single loop, giving it a time complexity of O(n).

```python
def find_duplicates_fast(lst):
    seen = {}
    duplicates = []
    for item in lst:
        if item in seen:
            if seen[item] == 1:
                duplicates.append(item)
            seen[item] += 1
        else:
            seen[item] = 1
    return duplicates

%timeit find_duplicates_fast(lst)

446 μs ± 1.06 μs per loop (mean ± std. dev. of 7 runs, 1,000 loops each)
```

Notice that the first results are reported in milliseconds and the second in microseconds: That's a speedup of almost 1900X for our better algorithm!  We could do even better by using the built-in Python `Counter` object:

```python
from collections import Counter

def find_duplicates_counter(lst):
    duplicates = [item for item, count in Counter(lst).items() if count > 1]
    return duplicates

%timeit find_duplicates_counter(lst)

327 μs ± 2 μs per loop (mean ± std. dev. of 7 runs, 1,000 loops each)

```

That's about a 36% speedup, which is much less than we got moving from our poor algorithm to the better one, but it could be significant if working with big data, and it also makes for cleaner code.  In general, built-in functions will be faster than hand-written ones as well as being better-tested, so it's always a good idea to use an existing solution if it exists.  Fortunately AI assistants are quite good at recommending optimized versions of code.


### Slow operations in Pandas

Many researchers use Pandas because of its powerful data manipulation methods, but some of its operations are notoriously slow.  Here we show an example of how incrementally inserting data into an existing data frame can be remarkably slower than using standard python objects and then converting them to a Pandas data frame in a single step:

```python
import pandas as pd 
import numpy as np
import timeit

# generate some random data
nrows, ncolumns = 1000, 100
rng = np.random.default_rng(seed=42)
random_data = rng.random((nrows, ncolumns))

# slow way to fill the data frame
def fill_df_slow(random_data):
    nrows, ncolumns = random_data.shape
    columns = ['column_' + str(i) for i in range(ncolumns)]
    df = pd.DataFrame(columns=columns)

    for i in range(nrows):
        df.loc[i] = random_data[i, :]
    return df

%timeit fill_df_slow(random_data)

121 ms ± 418 μs per loop (mean ± std. dev. of 7 runs, 10 loops each)
```

We can compare this to a function that also loops through each row of data, but instead of adding the data to a data frame it adds them to a dictionary, and then converts the dictionary to a data frame:

```python
# fill df by creating a dictionary using a dict comprehension and then converting it to a data frame
def fill_df_fast(random_data):
    nrows, ncolumns = random_data.shape
    columns = ['column_' + str(i) for i in range(ncolumns)]
    df = pd.DataFrame({columns[j]: random_data[:, j] for j in range(ncolumns)})
    return df

%timeit fill_df_fast(random_data)

255 μs ± 885 ns per loop (mean ± std. dev. of 7 runs, 1,000 loops each)
```

Again notice the difference in units between the two measurement.  This method gives us an almost 500X speedup!  We can make it even faster by directly passing the numpy array into pandas:

```python
# fill df by creating a dictionary and then converting it to a data frame
def fill_df_superfast(random_data):
    nrows, ncolumns = random_data.shape
    columns = ['column_' + str(i) for i in range(ncolumns)]
    df = pd.DataFrame(random_data, columns=columns)
    return df

%timeit fill_df_superfast(random_data)

18.7 μs ± 279 ns per loop (mean ± std. dev. of 7 runs, 100,000 loops each)
```

This gives more than 10X speedup compared to the previous solution. In general, one should avoid any operations with data frames that involve looping, and also avoid building data frames incrementally, preferring instead to generate a dict or Numpy array and then convert it into a data frame in one step.

### Use of suboptimal object types

Different types of objects in Python may perform better or worse for different types of operation.  For example, while we saw that some operations using Pandas data frames may be slow, it can be quite fast for other operations.  As an example we can look at searching for an item within a list of items. We can compare four different ways of doing this, using the `in` operator with a Python dict, Python list, Pandas Series, or numpy array.  Here are the average execution times for each of these searching over 100,000 values computed using `timeit`:

| Object Type    | Execution Time (µs) |
|----------------|---------------------|
| dict           | 0.0282              |
| Pandas series  | 0.845               |
| Numpy array    | 10.0                |
| list           | 287.0               |
|----------------|---------------------|

Here we see that dictionaries are by far the fastest objects for searching, with lists being the absolute worst.  When timing matters, it's usually useful to do some prototype testing across different types of objects to find the most performant.

### Unnecessary looping

Any time one is working with numpy or Pandas objects, the presence of a loop in the code should count as a bad smell.  These packages have highly optimized vectorized operations, so the use of loops will almost always be orders of magnitude slower.  For example, we can compute the dot product of two arrays using a list comprehension (whicih is effectively a loop):

```python
def dotprod_by_hand(a, b):
    return sum([a[i]*b[i] for i in range(len(a))])

npts = 1000
a = np.random.rand(npts)
b = np.random.rand(npts)

%timeit dotprod_by_hand(a, b)

109 μs ± 610 ns per loop (mean ± std. dev. of 7 runs, 10,000 loops each)
```

Compare this to the result using the built-in dot product operator in Numpy, which gives a speedup of more than 150X compared to our hand-built code:

```python
%timeit np.dot(a, b)

614 ns ± 1.61 ns per loop (mean ± std. dev. of 7 runs, 1,000,000 loops each)
```

### Suboptimal API usage

- e.g., individual vs batch fetching with pubmed API

### Slow I/O

For data-intensive workflows, especially when the data are too large to fit completely in memory, a substantial amount of execution time may be spent waiting for data to be read and/or written to a filesystem or database.


### Caching/lazy loading
- functools cache decorator



## Just-in-time compilation with Numba


## Using Einstein operators


## A brief introduction to parallelism and multithreading

## preloading data using threads

## Writing parallelized code

