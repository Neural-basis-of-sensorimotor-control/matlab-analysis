function final_tag = intra_final_stim_tag(original_tag)

str_pattern   = get_pattern(original_tag);
str_pattern   = sprintf('pa#%d', find(cellfun(@(x) strcmp(x, str_pattern), get_patterns())));
str_electrode = get_electrode(original_tag);
str_electrode = ['ch#'  str_electrode(2)];
str_index     = ['pu#' intra_get_index(original_tag)];

final_tag = [str_pattern ', ' str_electrode ', ' str_index];

end