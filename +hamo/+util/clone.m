function clone(oldClone, newClone)

mco = eval(['?' class(oldClone)]);

plist  = mco.PropertyList;
for i=1:numel(plist)
  p = plist(i);
  if ~p.Dependent && ~p.Abstract && ~p.Constant
    if strcmp(p.SetAccess, 'public')
      newClone.(p.Name) = oldClone.(p.Name);
    else
      warning('Cannot copy property ''%s'': SetAccess is %s', p.Name, ...
        p.SetAccess);
    end
  end
end

end