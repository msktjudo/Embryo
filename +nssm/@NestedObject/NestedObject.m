classdef NestedObject
  %DATA ���̃N���X�̊T�v�������ɋL�q
  %   �ڍא����������ɋL�q
  
  properties
    nobj  % �I�u�W�F�N�g��
    L     % ���x���̃Z���z��iL{1}���ł������AL{nobj}���ł��O���j
    D     % D{i}��L{i}�̋����֐�
  end
  
  methods
    function obj = NestedObject(ML)
      % obj = NestedObject(ML)  N�w�̓���q�\���̑��l���x��ML��2�l���x���ɕϊ�
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
      % �����t�����[�N���b�h�����ϊ�
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

