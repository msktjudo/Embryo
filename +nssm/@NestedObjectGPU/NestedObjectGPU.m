classdef NestedObjectGPU
  %DATA このクラスの概要をここに記述
  %   詳細説明をここに記述
  
  properties
    nobj  % オブジェクト数
    L     % ラベルのセル配列（L{1}が最も内側、L{nobj}が最も外側）
    D     % D{i}はL{i}の距離関数
  end
  
  methods
    function obj = NestedObjectGPU(ML)
      % obj = NestedObject(ML)  N層の入れ子構造の多値ラベルMLを2値ラベルに変換
      obj.nobj = max(ML(:));
      obj.L = arrayfun(@(i)ML>=i,obj.nobj:-1:1,'UniformOutput',false);
      obj.D = cellfun(@obj.signed_EUDT,obj.L,'UniformOutput',false);
      obj.L = cellfun(@(L)gpuArray(L),obj.L,'UniformOutput',false);
      
    end
  end
  
  methods (Static)
    
    D = distance_transform(L)
    
    function D = signed_EUDT( L )
      % 符号付きユークリッド距離変換
      % D = signed_EUDT( L )
      Obj = bwdist(~L);
      Bkg = bwdist(L);
      D = gpuArray(Bkg - Obj + single(L) - 0.5);
    end
  end
  
end

