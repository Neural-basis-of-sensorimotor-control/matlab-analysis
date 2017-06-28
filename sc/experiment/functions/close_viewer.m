function close_viewer()

f = get_all_figures();

indx = arrayfun(@(x) strcmp(get(x, 'Tag'), SequenceViewer.figure_tag), f);

f = f(indx);

for i=1:length(f)
  close(f(i));
end

end