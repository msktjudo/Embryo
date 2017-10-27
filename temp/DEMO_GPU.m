clear
reset(gpuDevice(1))

DataDir = '\\tera\user\saito\from\from_tjkw\Embyro_tri\output\03_brainstem_cut_LM19';
DirTrain{1} = fullfile(DataDir,'g1','train');
DirTrain{2} = fullfile(DataDir,'g2','train');
DirTest{1} = fullfile(DataDir,'g1','test');
DirTest{2} = fullfile(DataDir,'g2','test');
FmtMhd = 'Label%04d.mhd';
CvList = 2;
IdList = 21:44;
NumCases = length(IdList);

TrainData = cell(size(CvList));
TestData = cell(size(CvList));

TrimRange = {1:200,51:300,151:350};
%TrimRange = {1:4:200,51:4:300,151:4:350};
for cv = CvList
  TrainData{cv} = cell(size(IdList));
  for i = 1:NumCases
    disp([int2str(i),' / ',int2str(NumCases)])
    filename = fullfile(DirTrain{cv},sprintf(FmtMhd,IdList(i)));
    Label = nssm.io.read_metaimage(filename);
    TrainData{cv}{i} = nssm.NestedObjectGPU(Label(TrimRange{:}));
  end
  TestData{cv} = cell(size(IdList));
  for i = 1:NumCases
    disp([int2str(i),' / ',int2str(NumCases)])
    filename = fullfile(DirTest{cv},sprintf(FmtMhd,IdList(i)));
    Label = nssm.io.read_metaimage(filename);
    TestData{cv}{i} = nssm.NestedObjectGPU(Label(TrimRange{:}));
  end
end

%%
tic
t = [-1,0.7,1];
s = 1;
nobj = 3;
siz = cellfun(@length,TrimRange);
nRandomShapes = 1000;
lb = -10;
ub = 10;

% S = nssm.Encoder(nobj,siz,'SingleLS','tanh',t,lb,ub);
% S = nssm.Encoder(nobj,siz,'MultipleLS','tanh',s,lb,ub);
S = nssm.Encoder(nobj,siz,'LogOdds','tanh',s,lb,ub);
M = nssm.Modeler('CCR',0.9);
E = nssm.Evaluator(S,M,nRandomShapes,true);

Result{1} = E.Run(TrainData{cv},TestData{cv});

write_txt(Result{1}.G(:),num2str(cv,'./output/LogOdds/GPU/cv%d/G.txt'));
for i = 1:24
    write_map(Result{1}.InfoG{i},num2str(i,strcat('./output/LogOdds/GPU/cv',num2str(cv),'/InfoG%03d.txt')));
end
write_txt(Result{1}.S(:),num2str(cv,'./output/LogOdds/GPU/cv%d/S.txt'));
for i=1:1000
    write_map(Result{1}.InfoS{i},num2str(i,strcat('./output/LogOdds/GPU/cv',num2str(cv),'/InfoS%04d.txt')));
end

% Result{2} = E.Run(TrainData{2},TestData{2});
toc;

%% Debug SingleLS
t = [3,6.5,7];
S = nssm.Encoder(nobj,siz,'SingleLS','tanh',t,0,10);
data = TrainData{1}{1};
X = S.Encode(data);
X = reshape(X,siz);

surf(X(:,:,120)','EdgeColor','k','FaceColor','r');
hold on
fill3([1,siz(1),siz(1),1,1],[1,1,siz(2),siz(2),1],ones(1,5)*t(1),'k','FaceAlpha',0.3);
fill3([1,siz(1),siz(1),1,1],[1,1,siz(2),siz(2),1],ones(1,5)*t(2),'k','FaceAlpha',0.3);
fill3([1,siz(1),siz(1),1,1],[1,1,siz(2),siz(2),1],ones(1,5)*t(3),'k','FaceAlpha',0.3);
hold off

%% Debug LogOdds
S = nssm.Encoder(nobj,siz,'LogOdds','linear',1,-Inf,Inf);
data = TrainData{1}{1};
X = S.Encode(data);
X = reshape(X,[siz,3]);

surf(X(:,:,120,1)','EdgeColor','k','FaceColor','r');
hold on
surf(X(:,:,120,2)','EdgeColor','k','FaceColor','g');
surf(X(:,:,120,3)','EdgeColor','k','FaceColor','b');
hold off

%%
t = [-1,0.7,1];
s = 1;
nobj = 3;
siz = cellfun(@length,TrimRange);
nRandomShapes = 1000;
lb = -10;
ub = 10;

Result = cell(1,2);
parfor i = 1:2
    S = nssm.Encoder(nobj,siz,'LogOdds','tanh',s,lb,ub);
    M = nssm.Modeler('CCR',0.9);
    E = nssm.Evaluator(S,M,nRandomShapes,true);
    Result{i} = E.Run(TrainData{i},TestData{i});
end

