% This code is written by Mahmood Deypir, mdeypir@gmail.com 
clear all;
load('base_first.mat');% first
%load('BTCP_second.mat'); %second BTCP dataset 
%load('textual_third.mat'); %third dataset
%load('kaggle_fourth.mat'); %fourth dataset
Benign =  urls(labels==0,:);
Benign_label = labels(labels==0);
Malwares = urls(labels==1,:);
MalLabeles = labels(labels==1);
rib = randperm(size(Benign,1));
rim = randperm(size(Malwares,1));
foldsizeB = round(size(Benign,1) * 0.1);
foldsizeM = round(size(Malwares,1) * 0.1);
for i =1:10
    tIndexB = rib(1:foldsizeB);
    tIndexM = rim(1:foldsizeM);
    TIndexB = rib(foldsizeB+1:end);
    TIndexM = rim(foldsizeM+1:end);
    xt = [Benign(tIndexB,:);Malwares(tIndexM,:)];
    yt = [Benign_label(tIndexB); MalLabeles(tIndexM)];
    xT = [Benign(TIndexB,:);Malwares(TIndexM,:)];
    yT = [Benign_label(TIndexB); MalLabeles(TIndexM)];
    Res1(i,:) = FRU(xT,yT,xt,yt); %Feature based security risk score
    Res2(i,:) = NRU(xT,yT,xt,yt); %Nearest based
    rib = circshift(rib,[0,foldsizeB]);
    rim = circshift(rim,[0,foldsizeM]);
end
mRes1 = mean(Res1,1); 
mRes2 = mean(Res2,1);
x=0:0.01:1;
hold all;
p= plot(x,mRes1(1,:));
set(p,'Color','black','LineWidth',1.4,'Marker','+','MarkerSize',4);
xlabel('Warning rate','FontSize',12,'FontName','Times','FontWeight','Normal');
ylabel('Detection Rate','FontSize',12,'FontName','Times','FontWeight','Normal');
p = plot(x,mRes2(1,:));
set(p,'Color','red','LineWidth',1.4);
hleg= legend('FRU','NRU');
set(hleg,'Location','East');
box on; 
figure;

AUC_FRU1p = trapz(x(1:2),mRes1(1:2));
AUC_NRU1p = trapz(x(1:2),mRes2(1:2));

AUC_FRU2p = trapz(x(1:3),mRes1(1:3));
AUC_NRU2p = trapz(x(1:3),mRes2(1:3));

AUC_FRU4p = trapz(x(1:5),mRes1(1:5));
AUC_NRU4p = trapz(x(1:5),mRes2(1:5));

AUC_FRU8p = trapz(x(1:9),mRes1(1:9));
AUC_NRU8p = trapz(x(1:9),mRes2(1:9));

AUC_FRU16p = trapz(x(1:17),mRes1(1:17));
AUC_NRU16p = trapz(x(1:17),mRes2(1:17));

AUC_FRU32p = trapz(x(1:33),mRes1(1:33));
AUC_NRU32p = trapz(x(1:33),mRes2(1:33));

AUC_FRU64p = trapz(x(1:65),mRes1(1:65));
AUC_NRU64p = trapz(x(1:65),mRes2(1:65));

AUC_FRU = trapz(x,mRes1);  %100p
AUC_NRU = trapz(x,mRes2);  %100p  

%str = {'1','2','4','8','16','32','64','100'};
str = {'4','8','16','32','64','100'};
%yAUC_FRU=[AUC_FRU1p,AUC_FRU2p,AUC_FRU4p,AUC_FRU8p,AUC_FRU16p,AUC_FRU32p,AUC_FRU64p,AUC_FRU];
yAUC_FRU=[AUC_FRU4p,AUC_FRU8p,AUC_FRU16p,AUC_FRU32p,AUC_FRU64p,AUC_FRU];
%yAUC_IRU=[AUC_IRU1p,AUC_IRU2p,AUC_IRU4p,AUC_IRU8p,AUC_IRU16p,AUC_IRU32p,AUC_IRU64p,AUC_IRU];
yAUC_NRU=[AUC_NRU4p,AUC_NRU8p,AUC_NRU16p,AUC_NRU32p,AUC_NRU64p,AUC_NRU];
YAUC(1,:) =yAUC_FRU;
YAUC(2,:)= yAUC_NRU;
b=bar(YAUC','Grouped'); %title('AUC');
xticklabels(str);
b(1).FaceColor = 'black';
b(2).FaceColor = 'red';
xlabel('Warning rates up to X%','FontSize',12,'FontName','Times','FontWeight','Normal');
ylabel('Detection Rate','FontSize',12,'FontName','Times','FontWeight','Normal');
hleg= legend('FRU','NRU');
set(hleg,'Location','NorthWest');




