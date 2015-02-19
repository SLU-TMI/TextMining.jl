println("**********Testing Cluster**********")

facts("Creating a Cluster") do
  cl1 = Cluster()
  @fact typeof(cl1) => Cluster
  @fact isempty(cl1) => true
end

facts("Indexing Feature Vectors") do
  cl1 = Cluster()
  fv1 = FeatureVector(["word1" => 4, "word2" => 3])
  fv2 = FeatureVector()
  cl1["fv1"] = fv1
  cl1["fv2"] = fv2
 
  @fact cl1["fv1"] => fv1
  @fact cl1["fv2"] => fv2
  @fact cl1.vector_sum.map => (fv1+fv2).map
  @fact centroid(cl1).map => ((fv1+fv2)/2).map
end

facts("Getting Keys and Values") do
  cl1 = Cluster()
  fv1 = FeatureVector()
  fv2 = FeatureVector()
  cl1["fv1"] = fv1
  cl1["fv2"] = fv2
 
  @fact [key for key in  keys(cl1)] => ["fv1","fv2"]
  @fact [value for value in  values(cl1)] => [fv1, fv2]
end