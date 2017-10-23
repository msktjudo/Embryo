function P = create_metadata( varargin )
%SAVE_MHD_AND_RAW この関数の概要をここに記述
%   詳細説明をここに記述

P.ObjectType = 'Image';
P.NDims = 3;
P.BinaryData = true;
P.BinaryDataByteOrderMSB = false;
P.CompressedData = false;
P.CompressedDataSize = 0;
P.TransformMatrix = [1  0  0  0  1  0  0  0  1];
P.Offset = [0. 0. 0.];
P.CenterOfRotation = [0. 0. 0.];
P.AnatomicalOrientation = '???';
P.ElementSpacing = [1. 1. 1.];
P.DimSize = [1 1 1];
P.ElementNumberOfChannels = 1;
P.ElementType = 'MET_UNKNOWN';

dim = P.NDims;
dimfixed = false;
issetAnatomicalOrientation = false;
isMultiChannel = false;

if mod(nargin,2)==0
  Tag = varargin(1:2:end);
  Val = varargin(2:2:end);
else
  X = varargin{1};
  Tag = varargin(2:2:end);
  Val = varargin(3:2:end);
  dim = ndims(X);
  dimfixed = true;
  P = UpdateDimensions(P, dim);
  P.DimSize = size(X);
  P.ElementType = type_converter(class(X));
end

elementDataFile = '';
for t = 1:length(Tag)
  switch(Tag{t})
    case 'ObjectType'
      P.ObjectType = Val{t};
    case 'NDims'
      cur_dim = Val{t};
      if ~isequal(cur_dim, dim)
        if dimfixed
          error('Incompatible number of dimensions.')
        else
          P = UpdateDimensions(P, cur_dim);
          dim = cur_dim;
        end
      end
      dimfixed = true;
    case 'BinaryData'
      P.BinaryData = Val{t};
    case 'BinaryDataByteOrderMSB'
      P.BinaryDataByteOrderMSB = Val{t};
    case 'CompressedData'
      P.CompressedData = Val{t};
    case 'TransformMatrix'
      P.TransformMatrix = Val{t};
    case 'Offset'
      if isempty(Val{t})
        warning('Field "Offset" was found but null.');
      else
        cur_dim = length(Val{t});
        if ~isequal(cur_dim, dim)
          if dimfixed
            error('Incompatible number of dimensions.')
          else
            P = UpdateDimensions(P, cur_dim);
            dim = cur_dim;
          end
        end
        dimfixed = true;
        P.Offset = Val{t};
      end
    case 'CenterOfRotation'
      cur_dim = length(Val{t});
      if ~isequal(cur_dim, dim)
        if dimfixed
          error('Incompatible number of dimensions.')
        else
          P = UpdateDimensions(P, cur_dim);
          dim = cur_dim;
        end
      end
      dimfixed = true;
      P.CenterOfRotation = Val{t};
    case 'AnatomicalOrientation'
      P.AnatomicalOrientation = Val{t};
      if any(uint8(P.AnatomicalOrientation)~='?')
        issetAnatomicalOrientation = true;
      end
    case 'ElementSpacing'
      cur_dim = length(Val{t});
      if ~isequal(cur_dim, dim)
        if dimfixed
          error('Incompatible number of dimensions.')
        else
          P = UpdateDimensions(P, cur_dim);
          dim = cur_dim;
        end
      end
      dimfixed = true;
      P.ElementSpacing = Val{t};
    case 'DimSize'
      cur_dim = length(Val{t});
      if ~isequal(cur_dim, dim)
        if dimfixed
          
          error('Incompatible number of dimensions.')
        else
          P = UpdateDimensions(P, cur_dim);
          dim = cur_dim;
        end
      end
      dimfixed = true;
      P.DimSize = Val{t};
    case 'ElementNumberOfChannels'
      P.ElementNumberOfChannels = Val{t};
      if P.ElementNumberOfChannels > 1
        isMultiChannel = true;
      end
    case 'ElementType'
      P.ElementType = Val{t};
    case 'ElementDataFile'
      elementDataFile = Val{t};
    otherwise
      P.(Tag{t}) = Val{t};
  end
end

if ~issetAnatomicalOrientation
  P.AnatomicalOrientation = char(repmat('?',1,dim));
  P = orderfields(P,[1:9,11:12,10,13:length(fieldnames(P))]);
end

if ~P.CompressedData
  P = rmfield(P,'CompressedDataSize');
end
if ~isMultiChannel
  P = rmfield(P,'ElementNumberOfChannels');
end
if isfield(P,'ITK_InputFilterName')
  P = rmfield(P,'ITK_InputFilterName');
end
P.ElementDataFile = elementDataFile;

end


function P = UpdateDimensions(P, new_dim)
last_dim = P.NDims;
d = new_dim - last_dim;
if d > 0
  P.NDims = new_dim;
  tmp = reshape(P.TransformMatrix, last_dim, last_dim);
  P.TransformMatrix = eye(new_dim);
  P.TransformMatrix(1:last_dim, 1:last_dim) = tmp;
  P.TransformMatrix = reshape(P.TransformMatrix, 1, new_dim*new_dim);
  P.Offset = [P.Offset zeros(1,new_dim)];
  P.CenterOfRotation = [P.CenterOfRotation zeros(1,d)];
  P.ElementSpacing = [P.ElementSpacing ones(1,d)];
  P.DimSize = [P.DimSize ones(1,d)];
elseif d < 0
  P.NDims = new_dim;
  P.TransformMatrix = reshape(P.TransformMatrix, last_dim, last_dim);
  P.TransformMatrix = P.TransformMatrix(1:new_dim, 1:new_dim);
  P.TransformMatrix = reshape(P.TransformMatrix, 1, new_dim*new_dim);
  P.Offset = P.Offset(1,1:new_dim);
  P.CenterOfRotation = P.CenterOfRotation(1,1:new_dim);
  P.ElementSpacing = P.ElementSpacing(1,1:new_dim);
  P.DimSize(new_dim) = prod(P.DimSize(1,new_dim:end));
  P.DimSize = P.DimSize(1,1:new_dim);
end
end

function type = type_converter(matlabType)

switch matlabType
  case 'int8'
    type = 'MET_CHAR';
  case 'uint8'
    type = 'MET_UCHAR';
  case 'int16'
    type = 'MET_SHORT';
  case 'uint16'
    type = 'MET_USHORT';
  case 'int32'
    type = 'MET_INT';
  case 'uint32'
    type = 'MET_UINT';
  case 'single'
    type = 'MET_FLOAT';
  case 'double'
    type = 'MET_DOUBLE';
  otherwise
    error('Unknown data type');
end

end