function matrices_are_equal(varargin)

dim1 = varargin{1};

for i=2:length(varargin)
  dim2 = varargin{i};
  
  if length(dim1) ~= length(dim2)
    throw_error(i);
    for j=1:length(dim1)
      if dim1(i)~=dim2(j)
        throw_error(i);
      end
    end
  end
end

end

function throw_error(input_indx)

error('Input matrix %d does not have the same dimension as first input matrix', input_indx);

end