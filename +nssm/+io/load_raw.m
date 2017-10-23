function X = load_raw( path, classname, varargin )
% X = LOAD_RAW( PATH, TYPE )  LOAD PLAIN BINARY FORMAT DATA
%
% path: imput file path
% class: type of data
%
% X: an array size of [N 1] where N is the elements of data.
%
% (C) A. Saito, 2012

% X = load_raw(filename, classname) loads
% classname
%     double  -- Double precision floating point number array
%     single  -- Single precision floating point number array
%     logical -- Logical array
%     char    -- Character array
%     int8    -- 8-bit signed integer array
%     uint8   -- 8-bit unsigned integer array
%     int16   -- 16-bit signed integer array
%     uint16  -- 16-bit unsigned integer array
%     int32   -- 32-bit signed integer array
%     uint32  -- 32-bit unsigned integer array
%     int64   -- 64-bit signed integer array
%     uint64  -- 64-bit unsigned integer array

% fid = fopen(filename,permission,machineformat) loads numerical array from
% a binary file into a structure array, or data from an ASCII file into a double-precision array.

% 注意）この関数は将来のバージョンで削除予定です．
% 機能強化バージョンの read_raw を使用してください．

% nargin check
if nargin < 2
	error('At least, two imputs are required.');
end

% fix type-name supported in MATLAB
switch classname
	case {'char', 'MET_CHAR'}
		classname = 'int8';
	case {'uchar', 'unsigned char', 'MET_UCHAR'}
		classname = 'uint8';
	case {'short', 'MET_SHORT'}
		classname = 'int16';
	case {'ushort', 'unsigned short', 'MET_USHORT'}
		classname = 'uint16';
	case {'int', 'MET_INT'}
		classname = 'int32';
	case {'uint', 'unsigned int', 'MET_UINT'}
		classname = 'uint32';
	case {'float', 'float32', 'MET_FLOAT'}
		classname = 'single';
	case {'float64', 'MET_DOUBLE'}
		classname = 'double';
end

% 画像読み込み
fid = fopen(path, 'r');
if(fid ~= -1)
	X = fread(fid, inf, classname);
else
	error(['ファイル ' path ' が開けません．']);
end
fclose(fid);

if nargin > 2
    dim = cell2mat(varargin);
    if isscalar(dim)
        if isscalar(dim)
            X = shiftdim(X, 1-dim);
        else
            error('スカラの場合は正の整数でなければなりません．');
        end
    else
        X = reshape(X, varargin{:});
    end
end

        
        

end
