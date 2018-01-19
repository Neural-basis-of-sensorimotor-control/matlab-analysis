import matlab.engine

def sc_matlab2py_get_v(experiment_filename, file_tag, signal_tag):

	eng = matlab.engine.start_matlab()
	return eng.sc_matlab2py_get_v(experiment_filename, file_tag, signal_tag)
