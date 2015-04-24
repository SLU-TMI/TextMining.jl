
println("**********Testing Naive Bayes**********")

facts("Get percentages of fvs in each cluster") do
  fv1 = FeatureVector(["the"=>5, "c1"=>5])
  fv2 = FeatureVector(["the"=>5, "c1"=>5])
  fv3 = FeatureVector(["the"=>5, "c1"=>5])
  fv4 = FeatureVector(["the"=>5, "c1"=>5])
  fv5 = FeatureVector(["the"=>5, "c2"=>5])
  fv6 = FeatureVector(["the"=>5, "c2"=>5])
  fv7 = FeatureVector(["the"=>5, "c2"=>5])
  fv8 = FeatureVector(["the"=>5, "c2"=>5])
  fv9 = FeatureVector(["the"=>5, "c3"=>5])
  fv10 = FeatureVector(["the"=>5, "c3"=>5])
  fv11 = FeatureVector(["the"=>5, "c3"=>5])
  fv12 = FeatureVector(["the"=>5, "c3"=>5])
  fv13 = FeatureVector(["the"=>5, "c4"=>5])
  fv14 = FeatureVector(["the"=>5, "c4"=>5])
  fv15 = FeatureVector(["the"=>5, "c4"=>5])
  fv16 = FeatureVector(["the"=>5, "c4"=>5])

  c1 = Cluster()
  c2 = Cluster()
  c3 = Cluster()
  c4 = Cluster()

  c1["fv1"] = fv1
  c1["fv2"] = fv2
  c1["fv3"] = fv3
  c1["fv4"] = fv4
  c2["fv5"] = fv5
  c2["fv6"] = fv6
  c2["fv7"] = fv7
  c2["fv8"] = fv8
  c3["fv9"] = fv9
  c3["fv10"] = fv10
  c3["fv11"] = fv11
  c3["fv12"] = fv12
  c4["fv13"] = fv13
  c4["fv14"] = fv14
  c4["fv15"] = fv15
  c4["fv16"] = fv16

  ds = DataSet()

  ds["c1"] = c1
  ds["c2"] = c2
  ds["c3"] = c3
  ds["c4"] = c4

  d = Distribution(ds)

  dict = get_probs_fv_in_clust(d)
  for prob in values(dict)
    @fact prob => 4/16
  end
end

facts("Get all class names") do
  fv1 = FeatureVector(["the"=>5, "c1"=>5])
  fv2 = FeatureVector(["the"=>5, "c1"=>5])
  fv3 = FeatureVector(["the"=>5, "c1"=>5])
  fv4 = FeatureVector(["the"=>5, "c1"=>5])
  fv5 = FeatureVector(["the"=>5, "c2"=>5])
  fv6 = FeatureVector(["the"=>5, "c2"=>5])
  fv7 = FeatureVector(["the"=>5, "c2"=>5])
  fv8 = FeatureVector(["the"=>5, "c2"=>5])
  fv9 = FeatureVector(["the"=>5, "c3"=>5])
  fv10 = FeatureVector(["the"=>5, "c3"=>5])
  fv11 = FeatureVector(["the"=>5, "c3"=>5])
  fv12 = FeatureVector(["the"=>5, "c3"=>5])
  fv13 = FeatureVector(["the"=>5, "c4"=>5])
  fv14 = FeatureVector(["the"=>5, "c4"=>5])
  fv15 = FeatureVector(["the"=>5, "c4"=>5])
  fv16 = FeatureVector(["the"=>5, "c4"=>5])

  c1 = Cluster()
  c2 = Cluster()
  c3 = Cluster()
  c4 = Cluster()

  c1["fv1"] = fv1
  c1["fv2"] = fv2
  c1["fv3"] = fv3
  c1["fv4"] = fv4
  c2["fv5"] = fv5
  c2["fv6"] = fv6
  c2["fv7"] = fv7
  c2["fv8"] = fv8
  c3["fv9"] = fv9
  c3["fv10"] = fv10
  c3["fv11"] = fv11
  c3["fv12"] = fv12
  c4["fv13"] = fv13
  c4["fv14"] = fv14
  c4["fv15"] = fv15
  c4["fv16"] = fv16

  ds = DataSet()

  ds["c1"] = c1
  ds["c2"] = c2
  ds["c3"] = c3
  ds["c4"] = c4

  d = Distribution(ds)

  array = separate_by_class(d)

  for class in keys(d.space.clusters)
    @fact class in array => true
  end
end

facts("Naive Bayes correctly predicts the class") do
  fv1 = FeatureVector(["the"=>5, "c1"=>5])
  fv2 = FeatureVector(["the"=>5, "c1"=>5, "romeo"=>100])
  fv3 = FeatureVector(["the"=>5, "c1"=>5])
  fv4 = FeatureVector(["the"=>5, "c1"=>5])
  fv5 = FeatureVector(["the"=>5, "c2"=>5])
  fv6 = FeatureVector(["the"=>5, "c2"=>5])
  fv7 = FeatureVector(["the"=>5, "c2"=>5])
  fv8 = FeatureVector(["the"=>5, "c2"=>5])
  fv9 = FeatureVector(["the"=>5, "c3"=>5])
  fv10 = FeatureVector(["the"=>5, "c3"=>5])
  fv11 = FeatureVector(["the"=>5, "c3"=>5])
  fv12 = FeatureVector(["the"=>5, "c3"=>5])
  fv13 = FeatureVector(["the"=>5, "c4"=>5])
  fv14 = FeatureVector(["the"=>5, "c4"=>5])
  fv15 = FeatureVector(["the"=>5, "c4"=>5])
  fv16 = FeatureVector(["the"=>5, "c4"=>5])

  c1 = Cluster()
  c2 = Cluster()
  c3 = Cluster()
  c4 = Cluster()

  c1["fv1"] = fv1
  c1["fv2"] = fv2
  c1["fv3"] = fv3
  c1["fv4"] = fv4
  c2["fv5"] = fv5
  c2["fv6"] = fv6
  c2["fv7"] = fv7
  c2["fv8"] = fv8
  c3["fv9"] = fv9
  c3["fv10"] = fv10
  c3["fv11"] = fv11
  c3["fv12"] = fv12
  c4["fv13"] = fv13
  c4["fv14"] = fv14
  c4["fv15"] = fv15
  c4["fv16"] = fv16

  ds = DataSet()

  ds["c1"] = c1
  ds["c2"] = c2
  ds["c3"] = c3
  ds["c4"] = c4

  d = Distribution(ds)
  un_class_fv = FeatureVector(["now"=>4,"c2"=>1])
  un_class_fv2 = FeatureVector(["romeo"=>4,"c2"=>1])
  class = naive_bayes(d,un_class_fv)
  class2 = naive_bayes(d,un_class_fv2)
  @fact class => "c2"
  @fact class2 => "c1"
end

facts("Make sure test data gets rid of words not in ig_list") do
  fv1 = FeatureVector(["the"=>5, "c1"=>5])
  fv2 = FeatureVector(["the"=>5, "c1"=>5, "romeo"=>100])
  fv3 = FeatureVector(["the"=>5, "c1"=>5])
  fv4 = FeatureVector(["the"=>5, "c1"=>5])
  fv5 = FeatureVector(["the"=>5, "c2"=>5])
  fv6 = FeatureVector(["the"=>5, "c2"=>5])
  fv7 = FeatureVector(["the"=>5, "c2"=>5])
  fv8 = FeatureVector(["the"=>5, "c2"=>5])
  fv9 = FeatureVector(["the"=>5, "c3"=>5])
  fv10 = FeatureVector(["the"=>5, "c3"=>5])
  fv11 = FeatureVector(["the"=>5, "c3"=>5])
  fv12 = FeatureVector(["the"=>5, "c3"=>5])
  fv13 = FeatureVector(["the"=>5, "c4"=>5])
  fv14 = FeatureVector(["the"=>5, "c4"=>5])
  fv15 = FeatureVector(["the"=>5, "c4"=>5])
  fv16 = FeatureVector(["the"=>5, "c4"=>5])

  c1 = Cluster()
  c2 = Cluster()
  c3 = Cluster()
  c4 = Cluster()

  c1["fv1"] = fv1
  c1["fv2"] = fv2
  c1["fv3"] = fv3
  c1["fv4"] = fv4
  c2["fv5"] = fv5
  c2["fv6"] = fv6
  c2["fv7"] = fv7
  c2["fv8"] = fv8
  c3["fv9"] = fv9
  c3["fv10"] = fv10
  c3["fv11"] = fv11
  c3["fv12"] = fv12
  c4["fv13"] = fv13
  c4["fv14"] = fv14
  c4["fv15"] = fv15
  c4["fv16"] = fv16

  ds = DataSet()

  ds["c1"] = c1
  ds["c2"] = c2
  ds["c3"] = c3
  ds["c4"] = c4

  new_ds = train_data(ds,["c1","c2","c3","c4"])
  @fact length(new_ds.vector_sum) => 4
end

facts("Percentages returns number of correctly guessed.") do
  fv1 = FeatureVector(["the"=>5, "c1"=>5])
  fv2 = FeatureVector(["the"=>5, "c1"=>5, "romeo"=>100])
  fv3 = FeatureVector(["the"=>5, "c1"=>5])
  fv4 = FeatureVector(["the"=>5, "c1"=>5])
  fv5 = FeatureVector(["the"=>5, "c2"=>5])
  fv6 = FeatureVector(["the"=>5, "c2"=>5])
  fv7 = FeatureVector(["the"=>5, "c2"=>5])
  fv8 = FeatureVector(["the"=>5, "c2"=>5])
  fv9 = FeatureVector(["the"=>5, "c3"=>5])
  fv10 = FeatureVector(["the"=>5, "c3"=>5])
  fv11 = FeatureVector(["the"=>5, "c3"=>5])
  fv12 = FeatureVector(["the"=>5, "c3"=>5])
  fv13 = FeatureVector(["the"=>5, "c4"=>5])
  fv14 = FeatureVector(["the"=>5, "c4"=>5])
  fv15 = FeatureVector(["the"=>5, "c4"=>5])
  fv16 = FeatureVector(["the"=>5, "c4"=>5])

  c1 = Cluster()
  c2 = Cluster()
  c3 = Cluster()
  c4 = Cluster()

  c1["fv1"] = fv1
  c1["fv2"] = fv2
  c1["fv3"] = fv3
  c1["fv4"] = fv4
  c2["fv5"] = fv5
  c2["fv6"] = fv6
  c2["fv7"] = fv7
  c2["fv8"] = fv8
  c3["fv9"] = fv9
  c3["fv10"] = fv10
  c3["fv11"] = fv11
  c3["fv12"] = fv12
  c4["fv13"] = fv13
  c4["fv14"] = fv14
  c4["fv15"] = fv15
  c4["fv16"] = fv16

  ds = DataSet()

  ds["c1"] = c1
  ds["c2"] = c2
  ds["c3"] = c3
  ds["c4"] = c4

  d = Distribution(ds)
  dict = Dict(["fv1"=>"c1","fv11"=>"c3"])
  percent_right = percentages(d,dict)
  @fact percent_right => 1.0
end

