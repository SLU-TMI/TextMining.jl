punctuation = ['!','"','#','$','%','&','\'','(',')','*','+',',',
'-','.','/',':',';','<','=','>','?','@','[','\\',']','^','_','`',
'{','|','}','~']

function clean(string)
	string = lowercase(string)
	sarray = split(string)
	x = 1 
	while x <= length(sarray)
		sarray[x] = strip(sarray[x], punctuation)
		x += 1
	end
	string = join(sarray, ' ')
	return string
end
