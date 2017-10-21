function [ i j ] = pos_in_maze(state,nrows,ncolums)
  i = ceil(state/ncolums);
  j = mod(state,ncolums);
  if j==0
    j = ncolums;
  end
end

