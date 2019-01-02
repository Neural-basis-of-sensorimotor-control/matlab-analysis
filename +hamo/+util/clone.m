function clone(oldClone, newClone)

mco = eval(['?' class(oldClone)]);

plist  = mco.PropertyList;
for i=1:numel(plist)
  p = plist(i);
  if ~p.Dependent && ~p.Abstract && ~p.Constant
    newClone.(p.Name) = oldClone.(p.Name);
  end
end

end