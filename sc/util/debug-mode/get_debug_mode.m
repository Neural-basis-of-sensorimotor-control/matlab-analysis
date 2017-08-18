function val = get_debug_mode()

global DEBUG

val = ~isempty(DEBUG) && DEBUG;