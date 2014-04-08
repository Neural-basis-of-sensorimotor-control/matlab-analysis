function near = sc_nearest(x,appr,options)

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
   

end