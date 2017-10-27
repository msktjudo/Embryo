clear
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
for cv = CvList
  TrainData{cv} = cell(size(IdList));
  for i = 1:NumCases
    disp([int2str(i),' / ',int2str(NumCases)])
    filename = fullfile(DirTrain{cv},sprintf(FmtMhd,IdList(i)));
    Label = nssm.io.read_metaimage(filename);
    TrainData{cv}{i} = nssm.NestedObject(Label(TrimRange{:}));
  end
  TestData{cv} = cell(size(IdList));
  for i = 1:NumCases
    disp([int2str(i),' / ',int2str(NumCases)])
    filename = fullfile(DirTest{cv},sprintf(FmtMhd,IdList(i)));
    Label = nssm.io.read_metaimage(filename);
    TestData{cv}{i} = nssm.NestedObject(Label(TrimRange{:}));
  end
end

%%
tic;
count = 0;
t1_start = -9;
t1_end = 6;
for t1 = t1_start:3:t1_end
	t2_start = t1 + 1;
	t2_end = 7;
	for t2 = t2_start:3:t2_end
		t3_start = t2 + 1;
		t3_end = 8;
		for t3 = t3_start:3:t3_end
			t = [t1,t2,t3];
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
			Result{count}.t = t;
			Result{count} = E.Run(TrainData{cv},TestData{cv});
			
		end
	end
end

save(num2str(cv,'D:/mskt/output/search/Single_LS_t1_each3/cv%d/Result.mat'),'Result');

toc;

