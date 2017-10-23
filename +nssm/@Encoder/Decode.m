function Labels = Decode(obj,X)
%INITIALIZE エンコーダの初期化

switch obj.method
  case 'SingleLS'
    Labels = decodeSingleLS(obj,X);
  case 'MultipleLS'
    Labels = decodeMultipleLS(obj,X);
  case 'LogOdds'
    Labels = decodeLogOdds(obj,X);
end
end

function Labels = decodeSingleLS(obj,X)
X = reshape(X,obj.siz);
Labels = arrayfun(@(t)X<t,obj.P.thr','UniformOutput',false);
end

function Labels = decodeMultipleLS(obj,X)
Labels = num2cell(reshape(X<0,[],obj.nobj),1);
Labels = cellfun(@(x)reshape(x,obj.siz),Labels,'UniformOutput',false);
end

function Labels = decodeLogOdds(obj,X)
m = numel(X)/obj.nobj;
P = [exp(reshape(X,m,obj.nobj)),ones(m,1)];
P = bsxfun(@rdivide,P,sum(P,2));
[~,MapIdx] = max(P,[],2);
MapIdx = reshape(MapIdx,obj.siz);
Labels = arrayfun(@(i)MapIdx<=i,1:obj.nobj,'UniformOutput',false);
end
