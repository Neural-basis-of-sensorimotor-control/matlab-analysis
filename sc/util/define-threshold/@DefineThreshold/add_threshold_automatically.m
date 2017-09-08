function add_threshold_automatically(obj, max_width, nbr_of_steps, lower_tol, upper_tol)

obj.btn_dwn_fcn_plots = @(src, ~) ...
  add_threshold_automatically_btn_dwn(obj, src, max_width, nbr_of_steps, lower_tol, ...
  upper_tol);

obj.btn_dwn_fcn_axes  = [];

end


