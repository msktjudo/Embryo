classdef NestedObjectGPU
  %DATA ���̃N���X�̊T�v�������ɋL�q
  %   �ڍא����������ɋL�q
  
  properties
    nobj  % �I�u�W�F�N�g��
    L     % ���x���̃Z���z��iL{1}���ł������AL{nobj}���ł��O���j
    D     % D{i}��L{i}�̋����֐�
  end
  
  methods
    function obj = NestedObjectGPU(ML)
      % obj = NestedObject(ML)  N�w�̓���q�\���̑��l���x��ML��2�l���x���ɕϊ�
      obj.nobj = max(ML(:));
      obj.L = arrayfun(@(i)ML>=i,obj.nobj:-1:1,'UniformOutput',false);
      obj.D = cellfun(@obj.signed_EUDT,obj.L,'UniformOutput',false);
      obj.L = cellfun(@(L)gpuArray(L),obj.L,'UniformOutput',false);
      
    end
  end
  
  methods (Static)
    
    D = distance_transform(L)
    
    function D = signed_EUDT( L )
      % �����t�����[�N���b�h�����ϊ�
      % D = signed_EUDT( L )
      Obj = bwdist(~L);
      Bkg = bwdist(L);
      D = gpuArray(Bkg - Obj + single(L) - 0.5);
    end
  end
  
end

