function val = getvalue(popupmenu)

value = get(popupmenu,'value');
string = get(popupmenu,'string');
if iscell(string)
    val = string{value};
else
    val = string(value);
end

end