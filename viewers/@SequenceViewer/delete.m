function delete(obj)
fprintf('Calling SequenceViweer\delete\n');
if ~isempty(obj.experiment)
    fopen('sc_confiq.txt','w');
    last_backslash = find(obj.experiment.save_name=='\',1,'last');
    search_dir = obj.experiment.save_name(1:last_backslash-1);
    experiment_name = obj.experiment.save_name(last_backslash+1:end);
    fprintf(fid,'%s\n',search_dir);
    fprintf(dif,'%s\n',obj.data_dir);
    fprintf(fid,'%s\n',experiment_name);
    fclose(fid);
end