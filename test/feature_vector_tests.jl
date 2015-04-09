println("**********Testing FeatureVector**********")

facts("Creating a FeatureVector") do
  dict1 = ["word" => 4, "another" => 3]
  fv1 = FeatureVector(dict1)
  fv2 = FeatureVector()
  
  @fact fv1.total => 7
  @fact fv2.total => 0
  @fact fv1.map => dict1
  @fact typeof(fv1.map) => typeof(dict1)
  @fact typeof(fv2.map) => typeof(Dict{Any,Number}())
end

facts("Get value of FeatureVector given key") do
  dict1 = ["word" => 4, "another" => 3]
  fv1 = FeatureVector(dict1)
  
  @fact fv1.total => 7
  @fact fv1["word"] => fv1.map["word"]
end

facts("Sanitize Dictionary values of 0") do
  dict = ["word" => 4, "another" => 3, "help"=>0]
  fv = FeatureVector(dict)
  @fact fv.total => 7
  fv["the"] = 1
  @fact fv.total => 8
  fv["the"] = 0
  @fact fv.total => 7

  @fact fv.map => ["word"=>4,"another"=>3]
  add!(fv,(-1*fv))
  @fact isempty(fv) => true
  @fact fv.total => 0
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
  @fact fv2.total => fv1.total
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
  @fact fv3.total => (fv1.total + fv2.total)
  @fact fv4.total => (fv1.total + fv2.total)
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
  @fact fv3.total => (fv1.total - fv2.total)
  @fact fv4.total => (fv2.total - fv1.total)
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
  @fact fv1.total => 14
  @fact fv2["word"] => .8
  @fact fv2["∂"] => .6
  @fact fv2.total => 1.4
  @fact fv3 => fv4
  @fact fv3.total => 0
  @fact fv4.total => 0
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
  @fact fv1.total => 3.5
  @fact fv2["word"] => .2
  @fact fv2["∂"] => .15
  @fact fv2.total => .35
  @fact fv3 => fv4
  @fact fv3.total => 0
  @fact fv4.total => 0
end

facts("Rationalize a FeatureVector by a scalar") do
  dict1 = ["word" => 4, "another" => 3]
  fv1 = FeatureVector(dict1)
  fv2 = FeatureVector()

  fv1 = fv1 // 2
  fv3 = fv2 // 2

  @fact fv1["word"] => 2//1
  @fact fv1["another"] => 3//2
  @fact fv1.total => 7//2
  @fact fv2 => fv3
  @fact fv2.total => 0
  @fact fv3.total => 0
end


facts("Find dist_cos between two FeatureVectors") do
  fv = FeatureVector()
  fw = FeatureVector(Dict(["x"=>0, "y"=>0]))
  fv1 = FeatureVector(Dict(["x"=>1, "y"=>0]))
  fv2 = FeatureVector(Dict(["x"=>0, "y"=>1]))
  fv3 = FeatureVector(Dict(["x"=>1, "y"=>1]))
  fv4 = FeatureVector(Dict(["x"=>1.0, "y"=>sqrt(3)]))
  
  @fact dist_cos(fv3,fv3) => 0
  @fact isnan(dist_cos(fw,fv3)) => true
  @fact isnan(dist_cos(fv,fv1)) => true
  @fact 1 - cos(90*pi/180) - 1e-15 <= dist_cos(fv1,fv2) <= 1 - cos(90*pi/180) + 1e-15 => true
  @fact 1 - cos(45*pi/180) - 1e-15 <= dist_cos(fv2,fv3) <= 1 - cos(45*pi/180) + 1e-15 => true
  @fact 1 - cos(45*pi/180) - 1e-15 <= dist_cos(fv1,fv3) <= 1 - cos(45*pi/180) + 1e-15 => true
  @fact 1 - cos(60*pi/180) - 1e-15 <= dist_cos(fv1,fv4) <= 1 - cos(60*pi/180) + 1e-15 => true
  @fact 1 - cos(30*pi/180) - 1e-15 <= dist_cos(fv2,fv4) <= 1 - cos(30*pi/180) + 1e-15 => true
  @fact 1 - cos(0*pi/180) - 1e-15 <= dist_cos(fv1,fv1) <= 1 - cos(0*pi/180) + 1e-15 => true
end


facts("Find dist_zero between two FeatureVectors") do
  fv = FeatureVector()
  fv1 = FeatureVector(Dict(["x"=>2,"y"=>7]))
  fv2 = FeatureVector(Dict(["x"=>0,"y"=>4]))
  fv3 = FeatureVector(Dict(["x"=>3,"y"=>0]))
  fv4 = FeatureVector(Dict(["x"=>0,"y"=>0]))

  @fact dist_zero(fv,fv4) => 0
  @fact dist_zero(fv1,fv1) => 0
  @fact dist_zero(fv1,fv) == dist_zero(fv1,fv4) == 2 => true
  @fact dist_zero(fv2,fv) == dist_zero(fv3,fv4) == 1 => true
  @fact dist_zero(fv1,fv2) == dist_zero(fv1,fv3) == 1 => true
  @fact dist_zero(fv2,fv3) => 2
end


facts("Find dist_taxicab between two FeatureVectors") do
  fv = FeatureVector()
  fv1 = FeatureVector(Dict(["x"=>2,"y"=>2]))
  fv2 = FeatureVector(Dict(["x"=>0,"y"=>2]))
  fv3 = FeatureVector(Dict(["x"=>2,"y"=>0]))
  fv4 = FeatureVector(Dict(["x"=>0,"y"=>0]))

  @fact dist_taxicab(fv,fv4,false) => 0
  @fact dist_taxicab(fv1,fv1,false) => 0
  @fact dist_taxicab(fv1,fv,false) == dist_taxicab(fv1,fv4,false) == 4 => true
  @fact dist_taxicab(fv2,fv,false) == dist_taxicab(fv3,fv4,false) == 2 => true
  @fact dist_taxicab(fv1,fv2,false) == dist_taxicab(fv1,fv3,false) == 2 => true
  @fact dist_taxicab(fv2,fv3,false) => 4
end


facts("Find dist_euclidean between two FeatureVectors") do
  fv = FeatureVector()
  fv1 = FeatureVector(Dict(["x"=>2,"y"=>2]))
  fv2 = FeatureVector(Dict(["x"=>0,"y"=>2]))
  fv3 = FeatureVector(Dict(["x"=>2,"y"=>0]))
  fv4 = FeatureVector(Dict(["x"=>0,"y"=>0]))

  @fact dist_euclidean(fv,fv4,false) => 0
  @fact dist_euclidean(fv1,fv1,false) => 0
  @fact dist_euclidean(fv1,fv,false) == dist_euclidean(fv1,fv4,false) == sqrt(8) => true
  @fact dist_euclidean(fv2,fv,false) == dist_euclidean(fv3,fv4,false) == 2 => true
  @fact dist_euclidean(fv1,fv2,false) == dist_euclidean(fv1,fv3,false) == 2 => true
  @fact dist_euclidean(fv2,fv3,false) => sqrt(8)
end


facts("Find dist_infinite between two FeatureVectors") do
  fv = FeatureVector()
  fv1 = FeatureVector(Dict(["x"=>10,"y"=>5]))
  fv2 = FeatureVector(Dict(["x"=>0,"y"=>5]))
  fv3 = FeatureVector(Dict(["x"=>10,"y"=>0]))
  fv4 = FeatureVector(Dict(["x"=>0,"y"=>0]))

  @fact dist_infinite(fv,fv4,false) => 0
  @fact dist_infinite(fv1,fv,false) == dist_infinite(fv1,fv4,false) == 10 => true
  @fact dist_infinite(fv1,fv1,false) => 0
  @fact dist_infinite(fv2,fv,false) => 5
  @fact dist_infinite(fv3,fv4,false) => 10
  @fact dist_infinite(fv1,fv2,false) => 10
  @fact dist_infinite(fv1,fv3,false) => 5
  @fact dist_infinite(fv2,fv3,false) => 10
end