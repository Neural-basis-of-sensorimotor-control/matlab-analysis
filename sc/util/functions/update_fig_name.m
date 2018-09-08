function update_fig_name(figs, ending)

if ~nargin
  figs = gcf;
end

if nargin == 1
  ending = '.png';
end

if ~any(ending == '.')
  ending = ['.' ending];
end

for i=1:length(figs)
  f = figs(i);
  [~, filename] = fileparts(tempname);
  
  if ~isempty(f.FileName)
    filename = f.FileName;
  elseif ~isempty(f.Name)
    filename = f.Name;
    
  else
    ch = get_axes(f);
    
    for j=1:length(ch)
      a = ch(j);
      
      if ~isempty(a.Title.String)
        filename = a.Title.String;
        break
      end
    end
  end
end

filename = strrep(filename, ':', '_');
filename = strrep(filename, '''', '_');
filename = strrep(filename, '*', '_');

while endswith(filename, ending)
  filename = filename(1:end-length(ending));
end

if isfile([filename ending])
  indx = 1;
  
  while isfile([filename '_' num2str(indx) ending])
    indx = indx + 1;
  end
  
  filename = [filename '_' num2str(indx)]
end

f.FileName = [filename ending];
end
