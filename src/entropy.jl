function entropy(dict)
  ent = 0
  for key in keys(dict)
    ent -= dict[key]*log2(dict[key])
  end
  return ent
end

function info_gain(dict1, dict2)
  ent1 = entropy(dict1)
  ent2 = entropy(dict2)
  if ent1 >= ent2
    return ent1 - ent2
  else
    return ent2 - ent1
  end
end