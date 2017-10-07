function val = get_properties(indx)

mco   = ?ScPairedSpThPoints;
plist = mco.PropertyList;
pos   = cellfun(@(x) x == metaclass(ScPairedSpThPoints), {plist.DefiningClass});
plist = plist(pos);
val   = {plist.Name};
val(cellfun(@(x) strcmp(x, 'str_properties'), val)) = [];

if nargin
  val = val(indx);
end

end