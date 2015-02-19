println("**********Testing FeatureVector**********")

facts("Creating a FeatureVector") do
  dict1 = ["word" => 4, "another" => 3]
  fv1 = FeatureVector(dict1)
  fv2 = FeatureVector()

  @fact fv1.map => dict1
  @fact typeof(fv1.map) => typeof(dict1)
  @fact typeof(fv2.map) => typeof(Dict{Any,Number}())
end

facts("Get value of FeatureVector given key") do
  dict1 = ["word" => 4, "another" => 3]
  fv1 = FeatureVector(dict1)

  @fact fv1["word"] => fv1.map["word"]
end

facts("Set value of FeatureVector given key") do
  dict1 = ["word" => 4, "another" => 3]
  fv1 = FeatureVector(dict1)
  value = fv1["word"]

  fv1["word"] = 7

  @fact (fv1["word"] != dict1["word"]) => true
  @fact fv1["word"] => 7
  @fact dict1["word"] => 4
end

facts("Check to see if a key exists in a FeatureVector") do
  dict1 = ["word" => 4, "another" => 3]
  fv1 = FeatureVector(dict1)

  @fact haskey(fv1, "word") => true
  @fact haskey(fv1, "another") => true
  @fact haskey(fv1, "nope") => false
end

facts("Get keys of FeatureVector") do
  dict1 = ["word" => 4, "another" => 3]
  fv1 = FeatureVector(dict1)

  @fact keys(fv1) => Base.keys(fv1.map)
end

facts("Get values of FeatureVector") do
  dict1 = ["word" => 4, "another" => 3]
  fv1 = FeatureVector(dict1)

  @fact values(fv1) => Base.values(fv1.map)
end

facts("Check isempty on a FeatureVector") do
  fv1 = FeatureVector()

  @fact isempty(fv1) => true

  fv1["the"] = 3

  @fact isempty(fv1) => false

end

facts("Make copy of a FeatureVector") do
  dict1 = ["word" => 4, "another" => 3]
  fv1 = FeatureVector(dict1)
  fv2 = copy(fv1)

  for key in keys(fv1)
          @fact fv1[key] => fv2[key]
  end
  @fact fv2 == fv1 => false
  @fact typeof(fv1) => typeof(fv2)
end

facts("Find common type of a FeatureVector and an empty FeatureVector") do
  dict1 = ["word" => 4, "∂" => 3]
  fv1 = FeatureVector(dict1)
  fv2 = FeatureVector()

  @fact find_common_type(fv1,fv2) => (UTF8String,Int64)
  @fact find_common_type(fv2,fv1) => (UTF8String,Int64)
end

facts("Find common type of two FeatureVector") do
  dict1 = ["word" => 4, "another" => 3]
  dict2 = ["word" => .2, "∂" => .8]
  fv1 = FeatureVector(dict1)
  fv2 = FeatureVector(dict2)

  @fact find_common_type(fv1,fv2) => (UTF8String,Float64)
end

facts("Adding two FeatureVectors") do
  dict1 = ["word" => 4, "another" => 3]
  dict2 = ["word" => 2, "∂" => 3]
  fv1 = FeatureVector(dict1)
  fv2 = FeatureVector(dict2)
  dict3 = ["word"=>6,"∂"=>3,"another"=>3]
  fv3 = (fv1 + fv2)
  fv4 = (fv2 + fv1)
  for key in Base.keys(dict3)
    @fact fv3[key] => dict3[key]
  end
  for key in Base.keys(dict3)
    @fact fv4[key] => dict3[key]
  end
end

facts("Subtracting two FeatureVectors") do
  dict1 = ["word" => 4, "another" => 3]
  dict2 = ["word" => 2, "∂" => 3]
  fv1 = FeatureVector(dict1)
  fv2 = FeatureVector(dict2)
  dict3 = ["word"=>2,"∂"=>-3,"another"=>3]
  fv3 = (fv1 - fv2)
  dict4 = ["word"=>-2,"∂"=>3,"another"=>-3]
  fv4 = (fv2 - fv1)
  for key in Base.keys(dict3)
    @fact fv3[key] => dict3[key]
  end
  for key in Base.keys(dict4)
    @fact fv4[key] => dict4[key]
  end
end

facts("Multiply a FeatureVector by a scalar") do
  dict1 = ["word" => 4, "another" => 3]
  dict2 = ["word" => .4, "∂" => .3]
  fv1 = FeatureVector(dict1)
  fv2 = FeatureVector(dict2)
  fv3 = FeatureVector()

  fv1 = fv1 * 2
  fv2 = fv2 * 2
  fv4 = fv3 * 2

  @fact fv1["word"] => 8
  @fact fv1["another"] => 6
  @fact fv2["word"] => .8
  @fact fv2["∂"] => .6
  @fact fv3 => fv4
end

facts("Divide a FeatureVector by a scalar") do
  dict1 = ["word" => 4, "another" => 3]
  dict2 = ["word" => .4, "∂" => .3]
  fv1 = FeatureVector(dict1)
  fv2 = FeatureVector(dict2)
  fv3 = FeatureVector()

  fv1 = fv1 / 2
  fv2 = fv2 / 2
  fv4 = fv3 / 2

  @fact fv1["word"] => 2
  @fact fv1["another"] => 1.5
  @fact fv2["word"] => .2
  @fact fv2["∂"] => .15
  @fact fv3 => fv4
end

facts("Rationalize a FeatureVector by a scalar") do
  dict1 = ["word" => 4, "another" => 3]
  fv1 = FeatureVector(dict1)
  fv2 = FeatureVector()

  fv1 = fv1 // 2
  fv3 = fv2 // 2

  @fact fv1["word"] => 2//1
  @fact fv1["another"] => 3//2
  @fact fv2 => fv3
end


facts("Find cos_dist between two FeatureVectors") do
  fv = FeatureVector()
  fw = FeatureVector(Dict(["x"=>0, "y"=>0]))
  fv1 = FeatureVector(Dict(["x"=>1, "y"=>0]))
  fv2 = FeatureVector(Dict(["x"=>0, "y"=>1]))
  fv3 = FeatureVector(Dict(["x"=>1, "y"=>1]))
  fv4 = FeatureVector(Dict(["x"=>1.0, "y"=>sqrt(3)]))
  
  @fact cos_dist(fv3,fv3) => 0
  @fact isnan(cos_dist(fw,fv3)) => true
  @fact isnan(cos_dist(fv,fv1)) => true
  @fact 1 - cos(90*pi/180) - 1e-15 <= cos_dist(fv1,fv2) <= 1 - cos(90*pi/180) + 1e-15 => true
  @fact 1 - cos(45*pi/180) - 1e-15 <= cos_dist(fv2,fv3) <= 1 - cos(45*pi/180) + 1e-15 => true
  @fact 1 - cos(45*pi/180) - 1e-15 <= cos_dist(fv1,fv3) <= 1 - cos(45*pi/180) + 1e-15 => true
  @fact 1 - cos(60*pi/180) - 1e-15 <= cos_dist(fv1,fv4) <= 1 - cos(60*pi/180) + 1e-15 => true
  @fact 1 - cos(30*pi/180) - 1e-15 <= cos_dist(fv2,fv4) <= 1 - cos(30*pi/180) + 1e-15 => true
  @fact 1 - cos(0*pi/180) - 1e-15 <= cos_dist(fv1,fv1) <= 1 - cos(0*pi/180) + 1e-15 => true
end


facts("Find zero_dist between two FeatureVectors") do
  fv = FeatureVector()
  fv1 = FeatureVector(Dict(["x"=>2,"y"=>7]))
  fv2 = FeatureVector(Dict(["x"=>0,"y"=>4]))
  fv3 = FeatureVector(Dict(["x"=>3,"y"=>0]))
  fv4 = FeatureVector(Dict(["x"=>0,"y"=>0]))

  @fact zero_dist(fv,fv4) => 0
  @fact zero_dist(fv1,fv1) => 0
  @fact zero_dist(fv1,fv) == zero_dist(fv1,fv4) == 2 => true
  @fact zero_dist(fv2,fv) == zero_dist(fv3,fv4) == 1 => true
  @fact zero_dist(fv1,fv2) == zero_dist(fv1,fv3) == 1 => true
  @fact zero_dist(fv2,fv3) => 2
end


facts("Find taxicab_dist between two FeatureVectors") do
  fv = FeatureVector()
  fv1 = FeatureVector(Dict(["x"=>2,"y"=>2]))
  fv2 = FeatureVector(Dict(["x"=>0,"y"=>2]))
  fv3 = FeatureVector(Dict(["x"=>2,"y"=>0]))
  fv4 = FeatureVector(Dict(["x"=>0,"y"=>0]))

  @fact taxicab_dist(fv,fv4) => 0
  @fact taxicab_dist(fv1,fv1) => 0
  @fact taxicab_dist(fv1,fv) == taxicab_dist(fv1,fv4) == 4 => true
  @fact taxicab_dist(fv2,fv) == taxicab_dist(fv3,fv4) == 2 => true
  @fact taxicab_dist(fv1,fv2) == taxicab_dist(fv1,fv3) == 2 => true
  @fact taxicab_dist(fv2,fv3) => 4
end


facts("Find euclidean_dist between two FeatureVectors") do
  fv = FeatureVector()
  fv1 = FeatureVector(Dict(["x"=>2,"y"=>2]))
  fv2 = FeatureVector(Dict(["x"=>0,"y"=>2]))
  fv3 = FeatureVector(Dict(["x"=>2,"y"=>0]))
  fv4 = FeatureVector(Dict(["x"=>0,"y"=>0]))

  @fact euclidean_dist(fv,fv4) => 0
  @fact euclidean_dist(fv1,fv1) => 0
  @fact euclidean_dist(fv1,fv) == euclidean_dist(fv1,fv4) == sqrt(8) => true
  @fact euclidean_dist(fv2,fv) == euclidean_dist(fv3,fv4) == 2 => true
  @fact euclidean_dist(fv1,fv2) == euclidean_dist(fv1,fv3) == 2 => true
  @fact euclidean_dist(fv2,fv3) => sqrt(8)
end


facts("Find infinite_dist between two FeatureVectors") do
  fv = FeatureVector()
  fv1 = FeatureVector(Dict(["x"=>10,"y"=>5]))
  fv2 = FeatureVector(Dict(["x"=>0,"y"=>5]))
  fv3 = FeatureVector(Dict(["x"=>10,"y"=>0]))
  fv4 = FeatureVector(Dict(["x"=>0,"y"=>0]))

  @fact infinite_dist(fv,fv4) => 0
  @fact infinite_dist(fv1,fv) == infinite_dist(fv1,fv4) == 10 => true
  @fact infinite_dist(fv1,fv1) => 0
  @fact infinite_dist(fv2,fv) => 5
  @fact infinite_dist(fv3,fv4) => 10
  @fact infinite_dist(fv1,fv2) => 10
  @fact infinite_dist(fv1,fv3) => 5
  @fact infinite_dist(fv2,fv3) => 10
end