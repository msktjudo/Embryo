clear
% dir1 = '//tiger/D/mskt/output/search/Single_LS_each3/cv1/Result.mat';
dir2 = '//tiger/D/mskt/output/search/Single_LS_each3/cv2/Result.mat';
% load(dir1);
load(dir2);
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
			count = count + 1;
			Result{count}.t = t;
		end
	end
end

save('Result_cv2.mat','Result');
% save('Result_cv2.mat','S2');

%%
clear
% Result_cv1 = load('Result_cv1.mat');
load('Result_cv2.mat');
max = 0;
count = 0;
A = zeros(56,4);
for i = 1:56
	for j = 1:24
		count = count + 1;
		A(i,1) = mean(Result{i}.G(:));
		A(i,2:4) = Result{i}.t;
		if Result{i}.G(j) > max
			max = Result{i}.G(j);
			max_t = Result{i}.t;
		end
	end
end

S = sort(A);
