<div align="center">

<a href="http://www.slu.edu/" target="_blank">
<img src="http://www.slu.edu/Images/marketing_communications/logos/Higher%20Purpose.%20Greater%20Good/HPGG_horizontal/HPGG_Horz_blue.jpg" alt="SLU Logo" width="640" height="247.5"></img>
</a>

</div>

## SLU-TextMining.jl



This package is a set of tools being used by **Saint Louis University** to facilitate interdisciplinary research using data mining, machine learning, and natural language processing techniques of how time passage affects language.

### Setup

Like other Julia packages, you will be able to checkout *SLU-TextMining* from METADATA repo, as

```julia
Pkg.add("SLU-TextMining")
```

**Note:** This package relies on *LightXML.jl* to parse xml files. Please ensure you have installed the *LightXML.jl* package

```julia
Pkg.add("LightXML")
```

---
## Code Base



<div align="center">
<a href="http://julialang.org/" target="_blank">
<img src="http://julialang.org/images/logo_hires.png" alt="Julia Logo" width="105" height="71"></img>
</a>
</div>

These tools are being developed in **Julia** with the goal of making them fast, generic, and easily usable in Julia's REPL. The tools can be broken down into the following catagories.

### * Vector Space Model

These tools will utilize the [bag-of-words model](http://en.wikipedia.org/wiki/Bag-of-words_model) and the [hashing trick](http://en.wikipedia.org/wiki/Feature_hashing) to vectorize texts into [feature vectors](http://en.wikipedia.org/wiki/Feature_vector). 

##### Feature Vectors

The **FeatureVector** type is a wrapper around a **Dictionary (hashtable)** that restricts **key => value** mappings to **Any => Number** types and subtypes.

An empty *FeatureVector* can be constructed as so:
```julia
fv = FeatureVector()
```

A *FeatureVector* can also be constructed using an existing *Dictionary*: 
```julia
d = Dict(["my"=>2, "example"=>4])
fv = FeatureVector(d)
```

##### Clusters

##### DataSet
---
### * Text Processing

##### Processing XML Files
---
### * Clustering

##### Hierarchical Clustering

##### K-Means Clustering
---
### * Classification

##### Naive Bayes
---
## Examples



The following examples show how you may use this package to accomplish common tasks.

### * Read an XML file