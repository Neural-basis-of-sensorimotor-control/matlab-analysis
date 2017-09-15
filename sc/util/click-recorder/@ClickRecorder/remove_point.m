function remove_point(obj, index)

obj.clicked_points(index) = [];
obj.clicked_points(obj.n) = struct('x', [], 'y', []);

clear_objects(obj);

init_plot(obj);

end