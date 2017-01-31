function update_fig_name(figs)

if ~nargin
  figs = gcf;
end

for i=1:length(figs)
  f = figs(i);
  [~, filename] = fileparts(tempname);
  
  if ~isempty(f.FileName)
    continue;
  
  elseif ~isempty(f.Name)
    filename = f.Name;
  
  else
    ch = get_axes(f);
    
    for j=1:length(ch)
      a = ch(j);
      
      if ~isempty(a.Title.String)
        filename = a.Title.String;
        filename = strrep(filename, ':', '_');
        break
      end
    end
  end
  
  f.FileName = [filename '.png'];
end
