classdef NestedObject
  %DATA このクラスの概要をここに記述
  %   詳細説明をここに記述
  
  properties
    nobj  % オブジェクト数
    L     % ラベルのセル配列（L{1}が最も内側、L{nobj}が最も外側）
    D     % D{i}はL{i}の距離関数
  end
  
  methods
    function obj = NestedObject(ML)
      % obj = NestedObject(ML)  N層の入れ子構造の多値ラベルMLを2値ラベルに変換
      obj.nobj = max(ML(:));
      obj.L = arrayfun(@(i)ML>=i,obj.nobj:-1:1,'UniformOutput',false);
      obj.D = cellfun(@obj.signed_EUDT,obj.L,'UniformOutput',false);
      
      % Check whether signed distance function is monotonic, i.e. f{i} > f{i+1}.
      if any(cellfun(@(f1,f2)any(f1(:)<=f2(:)),obj.D(1:end-1),obj.D(2:end)))
        error('Signed distance function should be f{i}>f{i+1} for all i');
      end
      
    end
  end
  
  methods (Static)
    
    D = distance_transform(L)
    
    function D = signed_EUDT( L )
      % 符号付きユークリッド距離変換
      % D = signed_EUDT( L )
      if ~islogical(L)
        L = logical(L);
      end
      Obj = single(sqrt(nssm.ip.distance_transform(L)));
      Bkg = single(sqrt(nssm.ip.distance_transform(~L)));
      D = Bkg - Obj + double(L) - 0.5;
    end
  end
  
end

