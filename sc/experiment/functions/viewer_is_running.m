function val = viewer_is_running()

f = get_all_figures();

val = any(arrayfun(@(x) strcmp(get(x, 'Tag'), SequenceViewer.figure_tag), f));

end