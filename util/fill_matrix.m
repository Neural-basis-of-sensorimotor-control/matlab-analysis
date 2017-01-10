function fill_matrix(z)

hold_mode = ishold;

[nbr_of_rows, nbr_of_cols] = size(z);

hold on
for row=1:nbr_of_rows
  for col=1:nbr_of_cols
    x = row + [-.5 -.5 .5 .5 -.5];
    y = col + [-.5 .5 .5 -.5 -.5];
    fill(x, y, z(row,col));
  end
end

if ~hold_mode
  hold('off')
end

end