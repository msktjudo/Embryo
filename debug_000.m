clear
opengl software

ImgSize = [200 250 200];
s = prod(ImgSize);
X = zeros(s,1);
X = reshape(X, ImgSize)>0;

X(100,125,100) = 1;
save_raw(X,'test.raw','uchar');

Y = signed_EUDT(X(:));
Y = reshape(Y,ImgSize);

x = linspace(-100,100,200);

figure
plot(x,Y(:,125,100),'linewidth',3);
ylim([0,100]);
set(gca,'fontsize',20);
set(gcf,'color','white');


S1 = zeros(100,1);
S2 = zeros(100,1);


S1(:,1) = linspace(200,0,100);
S2(:,1) = linspace(0,50,100);
S = vertcat(S1,S2);
figure
plot(x,S,'g','linewidth',3);
set(gca,'fontsize',20);
set(gcf,'color','white');


%% debug candidate 001
Alpha = zeros(200,1);
Alpha(1:100) = 0.5;
Alpha(101:200) = 2;

figure
plot(x,Alpha,'r','linewidth',3);
set(gca,'fontsize',20);
set(gcf,'color','white');

B = Alpha.*S;
figure
plot(x,B,'m','linewidth',3);
set(gca,'fontsize',20);
set(gcf,'color','white');

%% debug candidate 002
TPS = @(X)X.*X.*log(X);
figure
plot(x,TPS(S),'linewidth',3);
set(gca,'fontsize',20);
set(gcf,'color','white');


%%

B = ones(3);
C = ones(3);
C(1,:) = 2;
C(2,:) = 4;
C(3,:) = 8;

T = B./C;
A = T.*B;

