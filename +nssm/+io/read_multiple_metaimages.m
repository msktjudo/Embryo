function L = read_multiple_metaimages( filedir, filefmt, reader )
%READ_MHDS この関数の概要をここに記述
%   詳細説明をここに記述

d = dir(fullfile(filedir,filefmt));
reader2 = @(f)reader(fullfile(filedir,f));
L = cellfun(reader2,{d.name},'UniformOutput',false);

end

