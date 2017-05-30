function save_vars(save_name)

% Get a list of all variables
evalin('base', 'allvars = whos;');

% Identify the variables that ARE NOT graphics handles. This uses a regular
% expression on the class of each variable to check if it's a graphics object
evalin('base', 'tosave = cellfun(@isempty, regexp({allvars.class}, ''^matlab\.(ui|graphics)\.''));');

% Pass these variable names to save
evalin('base', sprintf('save(''%s'', allvars(tosave).name)', save_name));

end