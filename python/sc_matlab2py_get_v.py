import matlab.engine

def sc_matlab2py_get_v(experiment_filepath, file_filepath, signal_tag):

	eng = matlab.engine.connect_matlab()
	return eng.sc_matlab2py_get_v(experiment_filepath, file_filepath, signal_tag)
