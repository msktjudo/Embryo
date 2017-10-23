classdef Evaluator
  %EVALUATOR このクラスの概要をここに記述
  %   詳細説明をここに記述
  
  properties
    ShapeRep
    Modeler
    Dataset
    nRandomShapes
    flagShowResult
    flagSkipSpecificity
  end
  
  methods
    
    function obj = Evaluator(ShapeRepresentation,Modeler,nRandomShapes,flagShowResult,flagSkipSpecificity)
      obj.ShapeRep = ShapeRepresentation;
      obj.Modeler = Modeler;
      obj.nRandomShapes = nRandomShapes;
      obj.flagShowResult = flagShowResult;
      if exist('flagSkipSpecificity','var')
          obj.flagSkipSpecificity = flagSkipSpecificity;
      else
          obj.flagSkipSpecificity = true;
      end
    end
    
    function Result = Run(obj,TrainData,TestData)
      
      if isa(TrainData{1}.D{1},'single')
          gpuFlag = false;
      else
          if existsOnGPU(TrainData{1}.D{1})
              gpuFlag = true;
          else
              gpuFlag = false;
          end
      end
      
      
      disp 'Encoding shapes...'
      if gpuFlag
          TrainDataMat = cellfun(@(x)gather(obj.ShapeRep.Encode(x)),TrainData,'UniformOutput',false);
      else
          TrainDataMat = cellfun(@(x)obj.ShapeRep.Encode(x),TrainData,'UniformOutput',false);
      end
      TrainDataMat = cat(2,TrainDataMat{:});
      
      disp 'Constructing SSM...'
      if gpuFlag
          M = obj.Modeler.pcaWithToolboxGPU(TrainDataMat);
      else
          M = obj.Modeler.pcaWithToolbox(TrainDataMat);
      end
      
      disp 'Evaluating SSM...'
      Result = obj.Evaluate(M,TestData);
      
    end
  end
  
  methods
    Result = Evaluate(obj,M,TestData)
  end
  
  methods (Static)
    h = ShowVolume(V,f);
    [TotalJI,Info] = criteria(L,Data)
    p = bwperimFixed(B)
  end
  
  
end
