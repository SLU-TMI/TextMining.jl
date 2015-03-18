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

function load_featurevector(path)
  if isfile(path)
    fv = FeatureVector()
    parsed_file = parse_xml(path)
    clean_text = clean(parsed_file)
    for word in clean_text
      if word in keys(fv)
        fv[word] += 1
      else
        setindex!(fv,1,word)
      end
    end
    return fv
  else
    Base.warn("$path is not to a valid file. Please check the path and try again.")
  end
end

function load_cluster(path)
  if isdir(path)
    curdir = pwd()
    cd(path)
    files = readdir(pwd())
    cl = Cluster()
    for file in files
      if endswith(file,"xml")
        fv = load_featurevector(file)
        cl[file] = fv
      else
        Base.warn("$file is not a valid file. Please enter a path to a directory of .xml files.")
      end
    end
    cd(curdir)
    return cl
  else
    Base.warn("$path is not to a valid directory. Please check the path and try again.")
  end
end

function load_dataset(path)
  if isdir(path)
    curdir = pwd()
    cd(path)
    dirs = readdir(pwd())
    ds = DataSet()
    for dir in dirs
      cl = Cluster()
      if isdir(dir)
        cl = load_cluster(dir)
        ds[dir] = cl
      else
        Base.warn("$dir is not a valid Directory. This will not be added.")
      end
    end
    cd(curdir)
    return ds
  else
    Base.warn("$path is not to a valid directory. Please check the path and try again.")
  end
end
