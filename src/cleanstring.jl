punctuation = ['!','"','#','$','%','&','\'','(',')','*','+',',',
'-','.','/',':',';','<','=','>','?','@','[','\\',']','^','_','`',
'{','|','}','~']

function clean(string)
	string = Base.lowercase(string)
	sarray = Base.split(string)
	x = 1 
	while x <= length(sarray)
		sarray[x] = Base.strip(sarray[x], punctuation)
		x += 1
	end
	return sarray
end
