classdef Modeler
  %MODELER このクラスの概要をここに記述
  %   詳細説明をここに記述
  
  properties
    mu
    lambda
    sigma
    invSigma
    M
    Y
    Alpha
    CR
    CCR
    nMode
    NumComponentsSelectionCriteria
    NumComponentsSelectionParameter
  end
  
  methods
    
    function obj = Modeler(method,val)
      % method: number of components selection criteria
      % val: number of components selection parameter
      % Examples)
      %   Modeler('CCR',0.95): number of components will be the minimum number
      %                    of axis satisfying CCR >= 0.95.
      %   Modeler('NumComponents',3): number of components will be 3
      obj.NumComponentsSelectionCriteria = method;
      obj.NumComponentsSelectionParameter = val;
    end
    
    function Z = backProjection(obj,Alpha)
      % Back projection of the normalzed PCS
      ScaledA = bsxfun(@times,Alpha,obj.sigma(1:obj.nMode));
      Z = bsxfun(@plus, obj.M(:,1:obj.nMode) * ScaledA, obj.mu);
    end
    
    function recX = reconstruction(obj,X)
      % Projection and backprojection of the data
      projectedX = obj.M(:,1:obj.nMode)'*bsxfun(@minus,X,obj.mu);
      recX = bsxfun(@plus,obj.M(:,1:obj.nMode)*projectedX,obj.mu);
    end
    
  end
  
  methods
    obj = pcaWithToolbox(obj, X);
    obj = pcaWithoutToolbox(obj, X);
    obj = pcaWithToolboxGPU(obj, X);
  end
  
end
