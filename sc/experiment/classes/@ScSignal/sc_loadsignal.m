function v_raw = sc_loadsignal(obj)
%Load transient properties (only)

if ~obj.parent.prompt_for_raw_data_dir()
  error('Could not find file');
end

if obj.is_adq_file
  
  fid = fopen(obj.parent.filepath);
  fread(fid,obj.channelname,'uint16');
  v_raw = fread(fid,obj.N,'bit12',4);
  fclose(fid);
  
else
  
  d = load(obj.parent.filepath,obj.channelname);
  
  obj.dt = d.(obj.channelname).interval;
  obj.N = d.(obj.channelname).length;
  v_raw = d.(obj.channelname).values;
  
end

end