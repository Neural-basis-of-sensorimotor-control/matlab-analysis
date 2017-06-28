function sc_read_wsg_templates(file, wsg_filename, template_tag)
% wsg_filename    file with template data
% template_tag    cell array of string tags
template_size_bytes = 258;

if ~exist(wsg_filename, 'file')
  error('Could not find file %s', wsg_filename)
end
[fid, errmsg] = fopen(wsg_filename);
if fid==-1
  error('Error reading wsg file: %s\n',errmsg);
end

for i=1:length(template_tag)
  fseek(fid,(i-1)*template_size_bytes,-1);
  [template, channel_index] = read_wsg_template(fid);

  if ~isempty(template)
    template.parent = file.signals.get(channel_index);
    template.tag = template_tag{i};
    signch = file.signals.get(channel_index);
    signch.waveforms.add(template);
  else
    warning('Template is empty');
  end
end
fclose(fid);

end


function [template, channel_index] = read_wsg_template(fid)
%0x00 lastp dd 3 number of data points
nbr_of_data_points = fread(fid, 1, 'uint32');
if nbr_of_data_points>=8
  error('lastp should be 1 <= lastp <= 8, is %d', nbr_of_data_points)
end
%0x04 cx0 16dd 2,35,47,70,99,129,0,0,0,0,0,0,0,0,0,0 x values
cx0 = fread(fid,16,'uint32');
x_offset = cx0(1:nbr_of_data_points);
%0x24 cy0 16dd -400,0,0,-125,-70,80,0,0,0,0,0,0,0,0,0,0 y values
cy0 = fread(fid,16,'int32');
y_offset = cy0(1:nbr_of_data_points);
%0x44 var0 16dd 16 dup (125) variance (cy0 +/- var0)
var0 = fread(fid,16,'uint32');
tol = var0(1:nbr_of_data_points);
%0x64 maxdifi dd 0 unknown
maxdifi = fread(fid,1,'uint32'); %#ok<NASGU>
%0x68 maxdifx dd 0 unknown
maxdifx = fread(fid,1,'uint32'); %#ok<NASGU>
%0x72 nottr dd 0 unknown
nottr = fread(fid,1,'uint32'); %#ok<NASGU>
%0x76 maxdifp dd 120 min rising flank
y_threshold_rising_flank = fread(fid,1,'int32');
%0x7A maxdiffn dd 120 min falling flank
y_threshold_falling_flank = fread(fid,1,'int32');
%0x7C neglat dd 2 max x displacement falling flank
x_threshold_falling_flank = fread(fid,1,'uint32');
%0x80 poslat dd 2 max x displacement rising flank
x_threshold_rising_flank = fread(fid,1,'uint32');
%0x84 editwavechannel dd 0 which channel
channel_index = fread(fid,1,'uint32') + 1;
%0x88 wavemethod dd strwaveshape "WaveShape" or "LevelTime" ?
wavemethod = fread(fid,1,'uint32'); %#ok<NASGU>
%0x8C cix1 dd 0 unknown
cix1 = fread(fid,1,'uint32'); %#ok<NASGU>
%0x90 ciy1 dd 0 unknown
ciy1 = fread(fid,1,'uint32'); %#ok<NASGU>
%0x94 cix2 dd 0 unknown
cix2 = fread(fid,1,'uint32'); %#ok<NASGU>
%0x98 ciy1 dd 0 unknown
ciy2 = fread(fid,1,'uint32'); %#ok<NASGU>
%0x9A streditwavechannel db (ASCII character) "1" -> "8"
streditwavechannel = fread(fid,1,'*char');
if streditwavechannel < '1' || streditwavechannel > '8'
  error('streditwavechannel should be an ASCII char between ''1'' and  ''8'', is %s', streditwavechannel)
end
%0x9B strbroadind db (ASCII character) "0", "1"
strbroadind = fread(fid,1,'*char');
if strbroadind < '0' || strbroadind > '1'
  error('strbroadind should be an ASCII character between ''0'' and ''1'', is %s', strbroadind)
end
%0x9C rczind db 0 0=WaveShape, 1=LevelTime
rczind = fread(fid,1,'uint8');
if rczind == 0
  is_wave_shape = true;
elseif rczind == 1
  is_wave_shape = false;
else
  error('rczind should be either 0 or 1, is %d', rczind)
end
%0x9D stimtrig db 0 unknown
stimtrig = fread(fid,1,'uint8'); %#ok<NASGU>
%0x9E trflank db 1 1=endast stigande flank, 2=endast fallande flank
trflank = fread(fid,1,'uint8');
if trflank == 1
  check_rising_flank = true;
elseif trflank == 2
  check_rising_flank = false;
else
  error('trflank should be 1 or 2, is %d', trflank)
end
%0x9F broadind db 0 unknown
broadind = fread(fid,1,'uint8'); %#ok<NASGU>
%0xA0 strtimtrig db ? unknown
strtimtrig = fread(fid,1,'uint32'); %#ok<NASGU>
%0xA4 aoff dw unknown
aoff = fread(fid,1,'uint32'); %#ok<NASGU>
%0xA8

if is_wave_shape
  template = ScWaveform([],[], []);
  template.add(ScThreshold(x_offset, y_offset, -tol, tol));
  disp('waveform')
  x_offset
  y_offset
  tol
else
  if check_rising_flank
    max_latency = x_threshold_rising_flank;
    flank_threshold = y_threshold_rising_flank;
  else
    max_latency = x_threshold_falling_flank;
    flank_threshold = y_threshold_falling_flank;
  end
  disp('AdqLevelTime')
  max_latency
  flank_threshold
  warning('Cannot implement AdqLevelTime');
  template = [];%AdqLevelTime([],[], max_latency, flank_threshold, check_rising_flank);
end

end
