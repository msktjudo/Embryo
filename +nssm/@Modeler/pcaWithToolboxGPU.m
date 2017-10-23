function obj = pcaWithToolboxGPU(obj, X)
% PCA based on statistics and Machine Learning Toolbox

[coeff,score,latent,~,~,avg] = pca(X');

obj.mu = avg';
obj.lambda = latent;
obj.sigma = sqrt(latent);
obj.invSigma = 1./sqrt(latent);

obj.M = coeff;
obj.Y = score';
obj.Alpha = bsxfun(@rdivide, obj.Y, obj.sigma);
cumLambda = cumsum(latent);
obj.CR = latent./cumLambda(end);
obj.CCR = cumLambda./cumLambda(end);

switch obj.NumComponentsSelectionCriteria
  case 'CCR'
    obj.nMode = find(obj.CCR>=obj.NumComponentsSelectionParameter,1);
  case 'NumComponents'
      obj.nMode = obj.NumComponentsSelectionParameter;
end

obj.mu       = gpuArray(obj.mu);
obj.lambda   = gpuArray(obj.lambda);
obj.sigma    = gpuArray(obj.sigma);
obj.invSigma = gpuArray(obj.invSigma);
obj.M        = gpuArray(obj.M);
obj.Y        = gpuArray(obj.Y);
obj.Alpha    = gpuArray(obj.Alpha);
obj.CR       = gpuArray(obj.CR);
obj.CCR      = gpuArray(obj.CCR);

end
