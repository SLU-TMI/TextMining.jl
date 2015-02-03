using FactCheck


export Distribution

	facts("Creating a Distribution") do
		dict1 = ["word" => 4, "another" => 3]
		fv1 = FeatureVector(dict1)
		d1 = Distribution(fv1)
		d2 = Distribution()

		@fact d1.fv => fv1
		@fact typeof(d1.fv) => typeof(fv1)
		@fact typeof(d1.fv) => typeof(Dict{Any,Rational}())
	end

#=
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
=#