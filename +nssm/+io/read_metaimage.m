function [I, P] = read_metaimage( path )
% P = LOAD_MHD( MHD_NAME, NATIVE )  IMPORT 3D CT IMAGES WITH MHD HEADER
% MHD_NAME is a file path to '*.mhd'.
% 
% Last updated: 2015/10/16  Support for the case CompressedData is true.
% Last updated: 2016/01/10  Support for the case ElementNumberOfChannels > 2.
% Last updated: 2016/01/10  Option 'native' is no longer available.
% 
% A.Saito

[pathstr, namestr, ~] = fileparts(path);
mhd_name = [namestr '.mhd'];
if isempty(pathstr)
  pathstr = '.\';
else
  pathstr = [pathstr '\'];
end
mhd_path = [pathstr mhd_name];
P = nssm.io.read_metadata(mhd_path);
raw_path = [pathstr P.ElementDataFile];

type = ['*' type_converter(P.ElementType)];
I = nssm.io.load_raw(raw_path, type);
if isfield(P,'CompressedData') && P.CompressedData
  I = nssm.io.zlibdecode_mex(I);
  %I = zlibdecode(I);
end

if isfield(P,'ElementNumberOfChannels') && P.ElementNumberOfChannels ~= 1
  % we assume the data is complex if P.ElementNumberOfChannels == 2
  if P.ElementNumberOfChannels == 2
    I = complex(I(1:2:end-1),I(2:2:end));
    I = reshape(I, P.DimSize);
  else
    I = reshape(I,[P.ElementNumberOfChannels,P.DimSize]);
    I = permute(I,[2:P.NDims+1,1]);
  end
else
  try
    I = reshape(I, P.DimSize);
  catch e
    throw(e)
  end
end

end

function type = type_converter(metaType)

switch metaType
  case 'MET_CHAR'
    type = 'int8';
  case 'MET_UCHAR'
    type = 'uint8';
  case 'MET_SHORT'
    type = 'int16';
  case 'MET_USHORT'
    type = 'uint16';
  case 'MET_INT'
    type = 'int32';
  case 'MET_UINT'
    type = 'uint32';
  case 'MET_FLOAT'
    type = 'single';
  case 'MET_DOUBLE'
    type = 'double';
  otherwise
    error('Unknown data type');
end

end

function output = zlibdecode(input)
%ZLIBDECODE Decompress input bytes using ZLIB.
%
%    output = zlibdecode(input)
%
% The function takes a compressed byte array INPUT and returns inflated
% bytes OUTPUT. The INPUT is a result of GZIPENCODE function. The OUTPUT
% is always an 1-by-N uint8 array. JAVA must be enabled to use the function.
%
% See also zlibencode typecast

error(nargchk(1, 1, nargin));
error(javachk('jvm'));
if ischar(input)
  warning('zlibdecode:inputTypeMismatch', ...
    'Input is char, but treated as uint8.');
  input = uint8(input);
end
if ~isa(input, 'int8') && ~isa(input, 'uint8')
  error('Input must be either int8 or uint8.');
end

buffer = java.io.ByteArrayOutputStream();
zlib = java.io.zip.InflaterOutputStream(buffer);
zlib.write(input, 0, numel(input));
zlib.close();
output = typecast(buffer.toByteArray(), 'uint8')';

end
