function h = sc_square_subplot(totnbr,i)


nbrofrows = ceil(sqrt(totnbr));
nbrofcols = ceil(totnbr/nbrofrows);

if nargout
  h = subplot(nbrofrows,nbrofcols,i);
else
  subplot(nbrofrows,nbrofcols,i);
end


end
