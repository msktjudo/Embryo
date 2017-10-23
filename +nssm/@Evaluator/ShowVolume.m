function p = ShowVolume(V,f)
% 3次元画像の3面表示
% fはリダクション関数（@mean,@sum,@max,@min,@median,@std,@var,etc）

maxA = gather(max(V(:)));
V = {squeeze(f(V,3))',squeeze(f(V,1));squeeze(f(V,2))',zeros(size(V,3),'like',maxA)};
V = cellfun(@gather,V,'UniformOutput',false);
V = cellfun(@(a)padarray(a,[1,1],maxA,'both'),V,'UniformOutput',false);
p = imagesc(cell2mat(V));
axis equal tight off
end