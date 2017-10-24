% boxplot for SingleLS, MultipleLS and LogOdds
clear
opengl software

SLG_V = zeros(48,1);
MLG_V = zeros(48,1);
LLG_V = zeros(48,1);
SLS_V = zeros(1000,1);
MLS_V = zeros(1000,1);
LLS_V = zeros(1000,1);

SLG_A = zeros(48,1);
MLG_A = zeros(48,1);
LLG_A = zeros(48,1);
SLS_A = zeros(1000,1);
MLS_A = zeros(1000,1);
LLS_A = zeros(1000,1);

% input data
for cv = 1:2
	dir_s = num2str(cv,'./output/SingleLS/Result_SingleLS_cv%d.mat');
	dir_m = num2str(cv,'./output/MultipleLS/Result_MultipleLS_cv%d.mat');
	dir_l = num2str(cv,'./output/LogOdds/Result_LogOdds_cv%d.mat');
	S = load(dir_s);
    M = load(dir_m);
	L = load(dir_l);
	if cv == 1
		SG(1:24,1) = S.Result{1}.G(:);
		MG(1:24,1) = M.Result{1}.G(:);
		LG(1:24,1) = L.Result{1}.G(:);
        SS(1:1000,1) = S.Result{1}.S(:);
		MS(1:1000,1) = M.Result{1}.S(:);
		LS(1:1000,1) = L.Result{1}.S(:);
        for i = 1:24
            SLG_V(i,1) = S.Result{1}.InfoG{i}.TotalLeakageVolumeI;
            MLG_V(i,1) = M.Result{1}.InfoG{i}.TotalLeakageVolumeI;
            LLG_V(i,1) = L.Result{1}.InfoG{i}.TotalLeakageVolumeI;
        end
        for i = 1:1000
            SLS_V(i,1) = S.Result{1}.InfoS{i}.TotalLeakageVolumeI;
            MLS_V(i,1) = M.Result{1}.InfoS{i}.TotalLeakageVolumeI;
            LLS_V(i,1) = L.Result{1}.InfoS{i}.TotalLeakageVolumeI;
        end
        for i = 1:24
            SLG_A(i,1) = S.Result{1}.InfoG{i}.TotalLeakageAreaI;
            MLG_A(i,1) = M.Result{1}.InfoG{i}.TotalLeakageAreaI;
            LLG_A(i,1) = L.Result{1}.InfoG{i}.TotalLeakageAreaI;
        end
        for i = 1:1000
            SLS_A(i,1) = S.Result{1}.InfoS{i}.TotalLeakageAreaI;
            MLS_A(i,1) = M.Result{1}.InfoS{i}.TotalLeakageAreaI;
            LLS_A(i,1) = L.Result{1}.InfoS{i}.TotalLeakageAreaI;
        end
	else
		SS(25:48,1) = S.Result{1}.G(:);
		MS(25:48,1) = M.Result{1}.G(:);
		LS(25:48,1) = L.Result{1}.G(:);
        SS(1001:2000,1) = S.Result{1}.S(:);
		MS(1001:2000,1) = M.Result{1}.S(:);
		LS(1001:2000,1) = L.Result{1}.S(:);
        for i = 1:24
            SLG_V(24+i,1) = S.Result{1}.InfoG{i}.TotalLeakageVolumeI;
            MLG_V(24+i,1) = M.Result{1}.InfoG{i}.TotalLeakageVolumeI;
            LLG_V(24+i,1) = L.Result{1}.InfoG{i}.TotalLeakageVolumeI;
        end
        for i = 1:1000
            SLS_V(1000+i,1) = S.Result{1}.InfoS{i}.TotalLeakageVolumeI;
            MLS_V(1000+i,1) = M.Result{1}.InfoS{i}.TotalLeakageVolumeI;
            LLS_V(1000+i,1) = L.Result{1}.InfoS{i}.TotalLeakageVolumeI;
        end
        for i = 1:24
            SLG_A(i,1) = S.Result{1}.InfoG{i}.TotalLeakageAreaI;
            MLG_A(i,1) = M.Result{1}.InfoG{i}.TotalLeakageAreaI;
            LLG_A(i,1) = L.Result{1}.InfoG{i}.TotalLeakageAreaI;
        end
        for i = 1:1000
            SLS_A(i,1) = S.Result{1}.InfoS{i}.TotalLeakageAreaI;
            MLS_A(i,1) = M.Result{1}.InfoS{i}.TotalLeakageAreaI;
            LLS_A(i,1) = L.Result{1}.InfoS{i}.TotalLeakageAreaI;
        end
	end	
end

Gene = [SG, MG, LG];
Spe = [SS, MS, LS];
LeakGV = [mean(SLG_V), mean(MLG_V), mean(LLG_V)];
LeakSV = [mean(SLS_V), mean(MLS_V), mean(LLS_V)];
LeakGA = [mean(SLG_A), mean(MLG_A), mean(LLG_A)];
LeakSA = [mean(SLS_A), mean(MLS_A), mean(LLS_A)];


figure
boxplot(Gene);
set(gca,'XTickLabel',{'Single LSF', 'Multiple LSF', 'LogOdds'},'Fontsize',20);
ylim([1.1 2.5]);
ylabel('Generalization','Fontsize',20);
set(gcf,'color','white');

figure
boxplot(Spe);
set(gca,'XTickLabel',{'Single LSF', 'Multiple LSF', 'LogOdds'},'Fontsize',20);
ylim([1.1 2.5]);
ylabel('Specificity','Fontsize',20);
set(gcf,'color','white');

figure
bar(LeakGV,0.5);
set(gca,'XTickLabel',{'Single LSF', 'Multiple LSF', 'LogOdds'}, 'Fontsize',20);
ylabel('LeakgeV(G)','Fontsize',20);
set(gcf,'color','white');

figure
bar(LeakSV,0.5);
set(gca,'XTickLabel',{'Single LSF', 'Multiple LSF', 'LogOdds'}, 'Fontsize',20);
ylabel('LeakgeV(S)','Fontsize',20);
set(gcf,'color','white');

figure
bar(LeakGA,0.5);
set(gca,'XTickLabel',{'Single LSF', 'Multiple LSF', 'LogOdds'}, 'Fontsize',20);
ylabel('LeakgeA(G)','Fontsize',20);
set(gcf,'color','white');

figure
bar(LeakSA,0.5);
set(gca,'XTickLabel',{'Single LSF', 'Multiple LSF', 'LogOdds'}, 'Fontsize',20);
ylabel('LeakgeA(S)','Fontsize',20);
set(gcf,'color','white');

