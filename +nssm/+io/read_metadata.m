function P = read_metadata( mhd_path )
% [I P] = READ_MHD_TAG( MHD_PATH, MODE )
% HEADER
%
% [I P] = load_raw_with_mhd( mhd_path, mode );
%

fid = fopen(mhd_path,'rt');
if fid == -1
  error(['Cannot open file: ' mhd_path]);
end

C = textscan(fid, '%[^ \t=]%*[=]%[^\r\n]');
N = C{1};
V = C{2};
for i = 1:length(V)
  if(~isempty(V{i}))
    switch N{i}
      case {'NDims' 'TransformMatrix' 'Offset' 'CenterOfRotation' 'ElementSpacing' 'DimSize' 'CompressedDataSize', 'ElementNumberOfChannels'}
        V{i} = cell2mat(textscan(V{i}, '%f'))';
      case {'BinaryData' 'BinaryDataByteOrderMSB' 'CompressedData'}
        V{i} = strcmp(V{i}, 'True');
    end
  end
end
%P = cell2struct(V,N,1)
M = [N'; V'];
P = nssm.io.create_metadata(M{:});

fclose(fid);
