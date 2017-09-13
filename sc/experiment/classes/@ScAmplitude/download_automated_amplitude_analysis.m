function download_automated_amplitude_analysis(amplitude, filename)

if ~amplitude.is_updated
  
  fprintf('Updating amplitude ...\n');
  amplitude.update;

end

indx                       = amplitude.is_median_and_automatic;
rise                       = amplitude.height(indx);
width                      = 1e3*amplitude.width(indx);
latency                    = 1e3*amplitude.latency(indx);
is_automatically_generated = amplitude.is_pseudo(indx);

fid = fopen(filename, 'w');

fprintf(fid, 'latency-onset,width,rise-amplitude,is-automatically-generated\n');

fprintf(fid, '%.1f,%.1f,%.1f,%d\n', ...
  [rise width latency is_automatically_generated]');

fclose(fid);

disp(['File ' filename ' saved'])

end