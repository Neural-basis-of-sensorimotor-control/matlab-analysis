function close_viewer()

f = get_all_figures();

indx = find(arrayfun(@(x) strcmp(get(x, 'Tag'), SequenceViewer.figure_tag), f), 1);

f = f(indx);

if ~isempty(f)
  close(f);
end

end