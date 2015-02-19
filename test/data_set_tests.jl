println("**********Testing DataSet**********")

facts("Creating a DataSet") do
  ds = DataSet()
  @fact typeof(ds) => DataSet
  @fact isempty(ds) => true
end

facts("Indexing a DataSet") do
  cl1 = Cluster()
  cl2 = Cluster()
  cl3 = Cluster()
  
  fv1 = FeatureVector(["word1" => 4, "word2" => 3])
  fv2 = FeatureVector(["word1" => 1, "word2" => 6])
  fv3 = FeatureVector(["word1" => 3, "word2" => 2]) 
  
  cl1["fv1"] = fv1
  cl1["fv2"] = fv2
  cl1["fv3"] = fv3

  cl2["fv1"] = fv1*2
  cl2["fv2"] = fv2*2
  cl2["fv3"] = fv3*2

  ds = DataSet()
  ds["cl1"] = cl1
  ds["cl2"] = cl2
  ds["cl3"] = cl3

  @fact ds["cl1"] => cl1
  @fact ds["cl2"] => cl2
  @fact ds["cl3"] => cl3
end

facts("Getting Keys and Values") do
  ds = DataSet()
  
  @fact isempty(ds) => true

  cl1 = Cluster()
  cl2 = Cluster()
  cl3 = Cluster()
  cl4 = Cluster()
  
  fv1 = FeatureVector(["word1" => 4, "word2" => 3])
  fv2 = FeatureVector(["word1" => 1, "word2" => 6])
  fv3 = FeatureVector(["word1" => 3, "word2" => 2]) 
  
  cl1["fv1"] = fv1
  cl1["fv2"] = fv2
  cl1["fv3"] = fv3

  cl2["fv1"] = fv1*2
  cl2["fv2"] = fv2*2
  cl2["fv3"] = fv3*2

  ds["cl1"] = cl1
  ds["cl2"] = cl2
  ds["cl3"] = cl3

  k = collect(keys(ds))
  v = collect(values(ds))
  
  @fact isempty(ds) => false
  @fact "cl1" in k => true
  @fact "cl2" in k => true
  @fact "cl3" in k => true
  @fact "cl4" in k => false

  @fact cl1 in v => true
  @fact cl2 in v => true
  @fact cl3 in v => true
  @fact cl4 in v => false
end 
