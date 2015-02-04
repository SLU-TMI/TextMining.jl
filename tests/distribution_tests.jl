using FactCheck


export Distribution

println("**********Testing Distribution**********")

	facts("Creating a Distribution") do
		dict1 = ["word" => 4, "another" => 3]
		fv1 = FeatureVector(dict1)
		d1 = Distribution(fv1)
		d2 = Distribution()

		for key in keys(fv1)
			@fact d1.fv[key] => fv1[key]
			@fact d1[key] => not(fv1[key])
		end
		@fact typeof(d1.fv) => typeof(fv1)
		@fact typeof(d2.fv) => typeof(FeatureVector{Any,Number}())
	end

	facts("If sent in with a FeatureVector, fv.total is set") do
		dict1 = ["word" => 4, "another" => 3]
		fv1 = FeatureVector(dict1)
		d1 = Distribution(fv1)
		d2 = Distribution()

		@fact d1.total => 7
		@fact d2.total => 0
	end

	facts("Set a value given key") do
		dict1 = ["word" => 4, "another" => 3]
		fv1 = FeatureVector(dict1)
		d1 = Distribution(fv1)

		d1["word"] = 7

		@fact d1.fv["word"] => 7
	end

	facts("Modifying FeatureVector of Distribution does not modify original FeatureVector") do
		dict1 = ["word" => 4, "another" => 3]
		fv1 = FeatureVector(dict1)
		d1 = Distribution(fv1)

		d1["word"] = 7

		@fact d1.fv["word"] => 7
		@fact fv1["word"] => 4
	end

	facts("Set a value will change total") do
		dict1 = ["word" => 4, "another" => 3]
		fv1 = FeatureVector(dict1)
		d1 = Distribution(fv1)

		@fact d1.total => 7
		d1["word"] = 7
		@fact d1.total => 10
	end





























