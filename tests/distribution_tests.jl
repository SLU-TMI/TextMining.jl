using FactCheck


export Distribution

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