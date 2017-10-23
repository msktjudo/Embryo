function obj = pcaWithoutToolbox(obj, X)
% PERFORM PCA Without Toolbox
%
% M = stat_pca(X);
%
% Warning: The behavior of stat_pca has changed on 2015.06.24.
% Use stat_pca_old to preserve previous result.

narginchk(2,2);

if isa(X,'single')
  X = double(X);
  singlePrec = true;
else
  singlePrec = false;
end

if isscalar(X)
  error('X should not be a scalar.');
end

[p,n] = size(X);

dof = n-1;
dim = min(dof,p);

mu_ = mean(X,2);
X = bsxfun(@minus,X,mu_);
[coeff,sigma_,U] = svd(X,'econ');
sigma_ = diag(sigma_);

r = sum(sigma_(1:dim) > max(p,n)*eps(sigma_(1)));
if dim > r
  dim = r;
  warning(['X is rank deficient to within machine precision. \n' ...
    'Number of principal modes was reduced to %d.'],dim);
end

coeff(:,dim+1:end) = [];
sigma_(dim+1:end)   = [];
U(:,dim+1:end)     = [];

[~,maxind] = max(abs(coeff), [], 1);
colsign = coeff(sub2ind(size(coeff),maxind,1:dim))<0;
coeff(:,colsign) = -coeff(:,colsign);
U(:,colsign) = -U(:,colsign);

U = U';
score =  bsxfun(@times,U,sigma_);
lambda_ = sigma_.^2;

cumLambda = cumsum(lambda_);

obj.mu = mu_;
obj.lambda = lambda_./dof;
obj.sigma  = sigma_./sqrt(dof);
obj.invSigma  = sqrt(dof)./sigma_;
obj.M = coeff;
obj.Y = score;
obj.Alpha = U.*sqrt(dof);
obj.CR = lambda_./cumLambda(end);
obj.CCR = cumLambda./cumLambda(end);

if singlePrec
  obj.mu       = single(obj.mu);
  obj.lambda   = single(obj.lambda);
  obj.sigma    = single(obj.sigma);
  obj.invSigma = single(obj.invSigma);
  obj.M        = single(obj.M);
  obj.Y        = single(obj.Y);
  obj.Alpha    = single(obj.Alpha);
  obj.CR       = single(obj.CR);
  obj.CCR      = single(obj.CCR);
end

switch obj.NumComponentsSelectionCriteria
  case 'CCR'
    obj.nMode = gather(find(obj.CCR>=obj.NumComponentsSelectionParameter,1));
  case 'NumComponents'
    obj.nMode = obj.NumComponentsSelectionParameter;
end

end