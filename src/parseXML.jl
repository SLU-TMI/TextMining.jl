using LightXML

function parseXML(doc)
	xdoc = parse_file(doc)
	xroot = root(xdoc)
	ces = get_elements_by_tagname(xroot, "text")
	body = content(ces[1])
	text = string(body)
	return text
end

function parseXMLDir(files)
	x = 1
	for file in files
		files[x] = parseXML(file)
		x+=1
	end
	return files
end