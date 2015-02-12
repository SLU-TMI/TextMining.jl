using LightXML

punctuation = ['!','"','#','$','%','&','\'','(',')','*','+',',',
'-','.','/',':',';','<','=','>','?','@','[','\\',']','^','_','`',
'{','|','}','~']

function clean(string)
  string = Base.lowercase(string)
  sarray = convert(Array{typeof(string)}, Base.split(string))
  x = 1 

  while x <= length(sarray)
    sarray[x] = Base.strip(sarray[x], punctuation)
    x += 1
  end

  return sarray
end

function parse_xml(doc)
  xdoc = parse_file(doc)
  xroot = root(xdoc)
  ces = get_elements_by_tagname(xroot, "text")
  body = content(ces[1])
  text = string(body)

  return text
end

function load_dir(files)
  x = 1

  for file in files
    files[x] = parse_xml(file)
     x+=1
  end

  return files
end