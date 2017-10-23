classdef Encoder
  %ENCODER 形状のエンコードとデコードのためのクラス
  
  properties
    nobj    % 入れ子形状の層数
    siz     % 形状のサイズ
    method  % エンコード・デコードの方法
    P       % エンコード・デコードに必要なパラメータの構造体
  end
  
  methods
    
    function obj = Encoder(nobj,siz,method,varargin)
      obj.nobj = nobj;
      obj.siz = siz;
      obj.method = method;
      obj = obj.Initialize(varargin{:});
    end
    
    obj = Initialize(obj,varargin)
    obj = Encode(obj,NestedObj)
    obj = Decode(obj,NestedObj)
    
  end
  
end

