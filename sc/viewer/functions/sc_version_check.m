function success = sc_version_check

desired_version = '8.4';
v = ver('Matlab');
success = str2double(v.Version)>=str2double(desired_version);

if ~success
  msgbox(sprintf(...
    'You are using Matlab version %s. You need to update to version %s.\n',...
    v.Version,desired_version));
end
