function X = Encode(obj,NestedObject)
%INITIALIZE エンコーダの初期化

switch obj.method
  case 'SingleLS'
    X = encodeSingleLS(obj,NestedObject);
  case 'MultipleLS'
    X = encodeMultipleLS(obj,NestedObject);
  case 'LogOdds'
    X = encodeLogOdds(obj,NestedObject);
end
end

function X = encodeSingleLS(obj,NestedObject)

f = NestedObject.D;

n = obj.nobj;
p = numel(f{1});

MatF = cellfun(@(x)x(:),f,'UniformOutput',false);
MatF = [MatF{:}];
[I,J] = find([Inf(p,1), MatF(:,2:n-1)] > 0 & [MatF(:,2:n-1) -Inf(p,1)] <= 0);
[I,sortInd] = sort(I);
J = J(sortInd);

idx = sub2ind([p,n],I,J);
f0 = MatF(idx);
f1 = MatF(idx+p);
t = obj.P.thr(J);
td = diff(obj.P.thr);
h = td(J);
X = (f0 + f1) ./ (f0 - f1);
% paste the line segments together
X = 0.5 * h .* (X + 1) + t;
% apply sigmoid transformation for f{1} < 0 and f{n} > 0
X(f{1}<0) = obj.P.lowerSigmoid(X(f{1}<0));
X(f{n}>0) = obj.P.upperSigmoid(X(f{n}>0));

X = X(:);
end

function X = encodeMultipleLS(obj,NestedObject)

dim = ndims(NestedObject.D{1});
X = cat(dim+1,NestedObject.D{:});
Label = cat(dim+1,NestedObject.L{:});

% apply sigmoid transformation for f{1} < 0 and f{n} > 0
X(Label) = obj.P.lowerSigmoid(X(Label));
X(~Label) = obj.P.upperSigmoid(X(~Label));

X = X(:);

end

function X = encodeLogOdds(obj,NestedObject)
tmp = [{Inf},NestedObject.D];
tmp = arrayfun(@(i)min(-tmp{i+1}(:),tmp{i}(:)),(1:obj.nobj)','UniformOutput',false);
%X = cell2mat(tmp);
X = cat(1,tmp{:});
X(X>0) = obj.P.upperSigmoid(X(X>0));
X(X<0) = obj.P.upperSigmoid(X(X<0));
end

