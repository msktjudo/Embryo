clear
reset(gpuDevice(1))

DataDir = '\\tera\user\saito\from\from_tjkw\Embyro_tri\output\03_brainstem_cut_LM19';
DirTrain{1} = fullfile(DataDir,'g1','train');
DirTrain{2} = fullfile(DataDir,'g2','train');
DirTest{1} = fullfile(DataDir,'g1','test');
DirTest{2} = fullfile(DataDir,'g2','test');
FmtMhd = 'Label%04d.mhd';
CvList = 1;
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
count = 0;
% t1 range
t1_start = -9;
t1_end = 6;
t2_start = t1_start + 1;
t2_end = 7;
t3_start = t2_start + 1;
t3_end = 8;
tic
for t1 = t1_start:3:t1_end
    for t2 = t2_start:3:t2_end
        for t3 = t3_start:3:t3_end
                % t = [-1,0.7,1];
                t = [t1,t2,t3];
				disp('[t1,t2,t3] = ');
                disp(t);
				s = 1;
                nobj = 3;
                siz = cellfun(@length,TrimRange);
                nRandomShapes = 1000;
                lb = -10;
                ub = 10;

                S = nssm.Encoder(nobj,siz,'SingleLS','tanh',t,lb,ub);
                % S = nssm.Encoder(nobj,siz,'MultipleLS','tanh',s,lb,ub);
                % S = nssm.Encoder(nobj,siz,'LogOdds','tanh',s,lb,ub);
                M = nssm.Modeler('CCR',0.9);
                E = nssm.Evaluator(S,M,nRandomShapes,true,false);

                count = count + 1;
                Result{count} = E.Run(TrainData{cv},TestData{cv});

%                 write_txt(Result{count}.G(:),strcat(num2str(cv,'./output/search/Single_LS_t1_each3/cv%d/'),num2str(count,'G_%04d.txt')));
				write_txt(Result{count}.G(:),strcat(num2str(cv,'D:/mskt/output/search/Single_LS_t1_each3/cv%d/'),num2str(count,'G_%04d.txt')));
                % for i = 1:24
                %     write_map(Result{1}.InfoG{i},num2str(i,strcat('./output/LogOdds/GPU/cv',num2str(cv),'/InfoG%03d.txt')));
                % end
                % write_txt(Result{1}.S(:),num2str(cv,'./output/LogOdds/GPU/cv%d/S.txt'));
                % for i=1:1000
                %     write_map(Result{1}.InfoS{i},num2str(i,strcat('./output/LogOdds/GPU/cv',num2str(cv),'/InfoS%04d.txt')));
                % end
                % Result{2} = E.Run(TrainData{2},TestData{2});

        end
    end
end
toc;
