function print_results(obj)

x = {obj.clicked_points.x};
y = {obj.clicked_points.y};

fprintf('\n...%%[');
fprintf('%g ', x{:});
fprintf('] ... \n...%%[');
fprintf('%g ', y{:});
fprintf('] ...\n');

end
