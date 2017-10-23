function Result = Evaluate(obj,M,TestData)
%Evaluate ç\ízÇµÇΩSSMÇÃï]âø

rng default

Result.G = zeros(length(TestData),1);
Result.InfoG = cell(1,length(TestData));
for i = 1:length(TestData)
    fprintf('Calculating genralization (%3d/%3d)\n',i,length(TestData))
    Data = TestData{i};
    L = obj.ShapeRep.Decode(M.reconstruction(obj.ShapeRep.Encode(Data)));
    [Result.G(i), Result.InfoG{i}] = criteria(L,Data);
    
    if obj.flagShowResult
        subplot(1,2,1);
        obj.ShowVolume(sum(cat(4,Data.L{:}),4),@(x,d)max(x,[],d));
        title 'Training Shapes'
        subplot(1,2,2);
        obj.ShowVolume(sum(cat(4,L{:}),4),@(x,d)max(x,[],d));
        title 'Reconstructed Shapes'
        drawnow
        disp(Result.InfoG{i});
    end
    
end

if obj.flagSkipSpecificity
    disp 'Calculating specificity...'
    Result.S = zeros(length(TestData),1);
    Result.InfoS = cell(1,obj.nRandomShapes);
    for i = 1:obj.nRandomShapes
        fprintf('Calculating specificity %3d/%3d\n',i,length(obj.nRandomShapes))
        Alpha = randn(M.nMode,1);
        L = obj.ShapeRep.Decode(M.backProjection(Alpha));
        
        JIs = cellfun(@(Data)criteria(L,Data),TestData);
        [~, maxIdx] = max(JIs);
        [Result.S(i), Result.InfoS{i}] = criteria(L,TestData{maxIdx});
        Result.InfoS{i}.maxIdx = maxIdx;
        
        if obj.flagShowResult
            subplot(1,1,1);
            obj.ShowVolume(sum(cat(4,L{:}),4),@(x,d)max(x,[],d));
            title 'Randomly Generated Shapes'
            drawnow
            disp(Result.InfoS{i});
        end
        
    end
end

end


function [TotalJI,Info] = criteria(L,Data)

nobj = length(L);
JI = cellfun(@(x,y)gather(sum(x(:)&y(:))/sum(x(:)|y(:))),L,Data.L);
TotalJI = sum(JI);

if nargout == 2
    Info.TotalJI = TotalJI;
    Info.JI = JI;
    
    % Leakage
    B = cellfun(@bwperimFixed,L,'UniformOutput',false);
    Interior = true(size(L{1}));
    Closure  = true(size(L{1}));
    Info.LeakageAreaI = zeros(1,nobj-1);
    Info.LeakageAreaC = zeros(1,nobj-1);
    Info.LeakageVolumeI = zeros(1,nobj-1);
    Info.LeakageVolumeC = zeros(1,nobj-1);
    for i = nobj-1:-1:1
        Interior = Interior & (L{i+1} & ~B{i+1});
        Closure  = Closure  & L{i+1};
        Info.LeakageAreaI(i) = gather(sum(B{i}(:) & ~Interior(:)));
        Info.LeakageAreaC(i) = gather(sum(B{i}(:) & ~Closure(:)));
        Info.LeakageVolumeI(i) = gather(sum(L{i}(:) & ~Interior(:)));
        Info.LeakageVolumeC(i) = gather(sum(L{i}(:) & ~Closure(:)));
    end
    Info.TotalLeakageAreaI = sum(Info.LeakageAreaI);
    Info.TotalLeakageAreaC = sum(Info.LeakageAreaC);
    Info.TotalLeakageVolumeI = sum(Info.LeakageVolumeI);
    Info.TotalLeakageVolumeC = sum(Info.LeakageVolumeC);
end

end

function p = bwperimFixed( B )
%BWPERIMFIXED bwperimÇÃèCê≥î≈
% îzóÒÇÃã´äEÇÃÉâÉxÉãÇ™åJÇËï‘ÇµÇƒÇ¢ÇÈÇ∆âºíË
% gpuArrayÇ≈Ç‡ìÆÇ≠ÇÊÇ§Ç…èCê≥

B = gpuArray(B);
if ismatrix(B)
  Bint = B([1,1:end-1],:) & B(:,[1,1:end-1]) & ...
    B([2:end,end],:) & B(:,[2:end,end]);
elseif ndims(B) == 3
  Bint = B([1,1:end-1],:,:) & B(:,[1,1:end-1],:) & B(:,:,[1,1:end-1]) & ...
    B([2:end,end],:,:) & B(:,[2:end,end],:) & B(:,:,[2:end,end]);
end
p = B & ~Bint;

end
