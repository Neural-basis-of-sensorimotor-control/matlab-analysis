function val = get_properties()

mco   = ?ScPairedSpThPoints;
plist = mco.PropertyList;
pos   = cellfun(@(x) x == metaclass(ScPairedSpThPoints), {plist.DefiningClass});
plist = plist(pos);
val   = {plist.Name};
val(cellfun(@(x) strcmp(x, 'str_properties'), val)) = [];

end