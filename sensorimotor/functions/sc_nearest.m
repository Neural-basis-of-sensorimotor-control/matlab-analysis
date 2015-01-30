function [near,index] = sc_nearest(x,appr,options)
% [near,index] = sc_nearest(x,appr,options)
%   x           numeric array
%   appr        value to find nearest approximation of
%   options     'abs'   (default) nearest default value
%               'lower' nearest value <= appr
%               'upper' nearest value >= appr
if isempty(appr),   near = []; return;  end
if nargin<3,    options = 'abs';   end

switch options
    case 'lower'
        x = x(x<=appr);
    case 'upper'
        x = x(x>=appr);
end
[~,ind] = min(abs(x-appr));
near = x(ind);

if nargout>=2
    index = ind;
end

end