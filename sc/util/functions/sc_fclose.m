function result = sc_fclose(fid)

r = fclose(fid);
if r
  warning('Could not close file width fid %i',fid);
end
if nargout
  result = r;
end
end
