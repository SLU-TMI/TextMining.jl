using LightXML

function parseXML(doc::ASCIIString)
	xdoc = parse_file(doc)
	xroot = root(xdoc)
	ces = collect(child_elements(xroot))
	body = collect(child_elements(ces[2]))
	text = content(body[2])
	return text
end