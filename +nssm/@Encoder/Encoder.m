classdef Encoder
  %ENCODER �`��̃G���R�[�h�ƃf�R�[�h�̂��߂̃N���X
  
  properties
    nobj    % ����q�`��̑w��
    siz     % �`��̃T�C�Y
    method  % �G���R�[�h�E�f�R�[�h�̕��@
    P       % �G���R�[�h�E�f�R�[�h�ɕK�v�ȃp�����[�^�̍\����
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

