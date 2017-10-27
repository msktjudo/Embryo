clear
cv = 2;
dir = num2str(cv,'./output/SingleLS/Result_bitan_cv%d.mat');
% dir = num2str(cv,'./output/SingleLS/Result_detail_cv%d.mat');
% dir = './msk_xf/Result_cv2.mat';
load(dir);

count = 0;
A = zeros(79,5);
t1_start = -0.7;
t1_end = -0.5;
for t1 = t1_start:0.1:t1_end
	t2_start = 6.5;
	t2_end = 7.5;
	for t2 = t2_start:0.1:t2_end
		t3_start = t2 + 1;
		t3_end = 8.5;
		for t3 = t3_start:3:t3_end
            count = count + 1;
			t = [t1,t2,t3];
            Result{count}.t = t;
        end
    end
end
% for i = 1:21
% 	Result{i}.t = [0*i,7,8];
% 	for j = 1:24
% 		count = count + 1;
% 		A(i,1:3) = Result{i}.t;
% 		A(i,4) = mean(Result{i}.G(:));
% 	end
% end

%%
% cv = 1;
% dir = num2str(cv,'./output/SingleLS/Result_bitan_cv%d.mat');
% dir = num2str(cv,'./output/MultipleLS/first/Result_cv%d.mat');
% dir = num2str(cv,'./output/MultipleLS/second/Result_cv%d.mat');
% dir = num2str(cv,'./output/LogOdds/second/Result01_cv%d.mat');
% load(dir);

count = 0;
A = zeros(33,4);
for i = 1:33
	A(i,1:3) = Result{i}.t;
	A(i,4) = mean(Result{i}.G(:));
end
% A = zeros(40,2);
% for i = 1:40
% 	A(i,1) = Result{i}.s;
% 	A(i,2) = mean(Result{i}.G(:));
% end

