using FactCheck


export Distribution

println("**********Testing Distribution**********")


facts("Creating a Distribution") do
	dict1 = ["word" => 4, "another" => 3]
	fv1 = FeatureVector(dict1)
	d1 = Distribution(fv1)

	for key in keys(fv1)
		@fact d1.space[key] => fv1[key]
		@fact d1[key] => not(fv1[key])
	end
	@fact typeof(d1.space) => typeof(fv1)
end

facts("If sent in with a FeatureVector, d.total is set") do
	dict1 = ["word" => 4, "another" => 3]
	fv1 = FeatureVector(dict1)
	d1 = Distribution(fv1)

	@fact d1.total => 7
end

facts("Get probability of seeing key in Distribution") do
	dict1 = ["word" => 4, "another" => 3]
	fv1 = FeatureVector(dict1)
	d1 = Distribution(fv1)

	value = d1["word"]

	@fact value => 4/7
end

facts("Get keys of Distribution") do
	dict1 = ["word" => 4, "another" => 3]
	fv1 = FeatureVector(dict1)
	d1 = Distribution(fv1)

	@fact keys(d1) => keys(d1.space)
end

facts("Check isempty on a Distribution") do
  d1 = Distribution{FeatureVector}()
  d2 = Distribution{Cluster}()
  d3 = Distribution{DataSet}()

  @fact isempty(d1) => isempty(d1.space)
  @fact isempty(d2) => isempty(d2.space)
  @fact isempty(d3) => isempty(d3.space)
end

facts("entropy(Distribution) returns 0 if empty Distribution") do
	d1 = Distribution{FeatureVector}()

	@fact entropy(d1) => 0
end

facts("entropy(Distribution) returns entropy of Distribution") do
	dict1 = ["word" => 4, "another" => 3]
	fv1 = FeatureVector(dict1)
	d1 = Distribution(fv1)

	@fact entropy(d1) => 0.9852281360342515
end


facts("info_gain(Distribution,Distribution) returns 0 if empty Distributions") do
	d1 = Distribution{FeatureVector}()
	d2 = Distribution{FeatureVector}()

	@fact info_gain(d1,d2) => 0
end

facts("info_gain(Distribution,Distribution) returns info_gain of Distribution") do
	dict1 = ["word" => 4, "another" => 3]
	fv1 = FeatureVector(dict1)
	d1 = Distribution(fv1)

	dict2 = ["∂" => .1, "happy" => .3]
	fv2 = FeatureVector(dict2)
	d2 = Distribution(fv2)

	@fact info_gain(d1,d2) => 0.17395001157511858
end
