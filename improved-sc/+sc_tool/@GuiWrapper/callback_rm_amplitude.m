function callback_rm_amplitude(obj, ~, ~)

indx = equals(obj.amplitudes.list, obj.amplitude);
obj.amplitudes(indx) = [];
obj.update_plots();

end