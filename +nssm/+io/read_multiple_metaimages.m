function L = read_multiple_metaimages( filedir, filefmt, reader )
%READ_MHDS ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q

d = dir(fullfile(filedir,filefmt));
reader2 = @(f)reader(fullfile(filedir,f));
L = cellfun(reader2,{d.name},'UniformOutput',false);

end

