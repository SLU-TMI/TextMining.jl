# TextMining.jl 



[![Build Status](https://travis-ci.org/SLU-TMI/TextMining.jl.svg?branch=master)](https://travis-ci.org/SLU-TMI/TextMining.jl)

This package is a set of tools being used by **Saint Louis University** to facilitate interdisciplinary research using data mining, machine learning, and natural language processing techniques of how time passage affects language.

### Setup

Like other Julia packages, you will be able to checkout *TextMining* from METADATA repo, as

```julia
Pkg.add("TextMining")
```

---
## Code Base



<div align="center">
<a href="http://julialang.org/" target="_blank">
<img src="http://julialang.org/images/logo_hires.png" alt="Julia Logo" width="105" height="71"></img>
</a>
</div>

These tools are being developed in **Julia** with the goal of making them fast, generic, and easily usable in Julia's REPL. The tools can be broken down into the following catagories.

1. Feature Space Model
------

These tools will utilize the [bag-of-words model](http://en.wikipedia.org/wiki/Bag-of-words_model) and the [hashing trick](http://en.wikipedia.org/wiki/Feature_hashing) to vectorize texts into [feature vectors](http://en.wikipedia.org/wiki/Feature_vector). Feature vectors exist in an infinite dimensional vector space which is refered to as the **feature space**. In order to optimize calculations, dimensions where the feature vector has value 0 are removed from the feature vectors hashtable. We are defining **FeatureSpace** to be an abstract type which has 3 subtypes: FeatureVector, Cluster, and DataSet.


#### Feature Vectors

The **FeatureVector** type is container for a **Dictionary (hashtable)** that restricts **key => value** mappings to **Any => Number** mappings, where *Any* and *Number* are Julia types, or their Julia subtypes. 

An empty *FeatureVector* can be constructed as so:
```julia
julia> fv = FeatureVector()
```
A *FeatureVector* can also be constructed using an existing *Dictionary*: 
```julia
julia> d = Dict(["my"=>2, "example"=>4])
julia> fv = FeatureVector(d)
```
Modifying elements of a *FeatureVector*:
```julia
julia> fv["word"] = 4
```
Accessing elements of a *FeatureVector*:
```julia
julia> fv["word"]
4
```

#### Clusters

The **Cluster** type is also a wrapper around a **Dictionary**. However, it restricts mappings to **Any => FeatureVector** types and subtypes. This allows users to meaningfully label groups of *FeatureVectors* for Classification. The *Cluster* type also computes the centroid of the set.

An empty *Cluster* can be constructed as so:
```julia
cl = Cluster()
```

#### DataSet

The **DataSet** type is also a wrapper around a **Dictionary**. However, it restricts mappings to **Any => Cluster** types and subtypes.

An empty *DataSet* can be constructed as so:
```julia
ds = DataSet()
```
---
2. Clustering (developing)
------

#### Hierarchical Clustering

#### K-Means Clustering
---
3. Classification
------

### Distance Based Classifiers
---

#### k Nearest Neighbors

---
### Probability Based Classifiers
---

#### Distribution

The **Distribution** type is a container which ensures the [axioms of probability](http://en.wikipedia.org/wiki/Probability_axioms).

An empty *Distribution* can be constructed as so:
```julia
ds = Distribution()
```

#### Naive Bayes (uncommenced)
---
4. Text Processing (uncommenced)
------

#### Processing XML Files (uncommenced)
---
