using FactCheck


export FeatureVector

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

		@fact isempty(fv1) => Base.isempty(fv1.map)
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

	#=
	facts("Find cos_similarity distance between two FeatureVectors") do
	end

	facts("Find zero distance between two FeatureVectors") do
	end

	facts("Find manhattan distance between two FeatureVectors") do
	end

	facts("Find euclidean distance between two FeatureVectors") do
	end

	facts("Find infinite distance between two FeatureVectors") do
	end

	#may need this/may not
	function runTests()
		reload("tests/feature_vector_tests.jl")
	end
	=#