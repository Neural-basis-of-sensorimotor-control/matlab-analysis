function copy_attributes(obj, newobj)

mco = ?SequenceViewer;
plist = mco.PropertyList;

for k=1:numel(plist)
  p = plist(k);
  if ~p.Dependent && ~p.Abstract && ~p.Constant
    newobj.(p.Name) = obj.(p.Name);
  end
end

end
