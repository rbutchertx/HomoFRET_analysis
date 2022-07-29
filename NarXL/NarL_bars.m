clc;clear;close all;
%% NarL (mNG tag)
series1 = [1046.28; 721.89; 1794.70]; 
series1error = [210.89; 166.77; 504.27];
series2 = [120.29; 814.38; 335.45];
series2error = [30.08; 185.67; 160.15];
series = [series1 series2];
errors = [series1error series2error];
labels = {sprintf('mNG-NarL'),sprintf('NarL-mNG'), ...
    sprintf('NarL')};


c1 = [1 1 1]; c2 = [255 0 0]/255;c3 = [0 0 0];
figure('Units', 'inches','Position', [0 0 8 4.725]); hold on;
b1 = bar(series,1,'EdgeColor',c3,'LineWidth',1,'BaseValue',0);
b1(1).FaceColor = c1; b1(1).DisplayName = '0mM NO3^-';
b1(2).FaceColor = c2; b1(2).DisplayName = '5mM NO3^-';
legend('AutoUpdate','off','Location','NorthWest')

nbars = size(series1, 2);
for j = 1:2
x = [];
for i = 1:nbars
    x = [x ; b1(i,j).XEndPoints];
end
errorbar(x',series(:,j),errors(:,j),'k','linestyle','none','LineWidth',1,'CapSize',6)
end

set(gca, 'XTick', 1:5, 'XTickLabel', labels);

% pbaspect([1,2,1]);
grid on; box on;
pbaspect([1,1,1]);
set(gca,'LineWidth',2,'FontSize',16,'FontName','Arial')
xlim([.5 3.5])
ylim([0 2400]);set(gca, 'YTick', [0:400:2400])
ylabel('mCherry fluorescence (a.u.)','FontSize',16,'FontName','Arial')
xlabel('  ','Color',[1 1 1])
%% narL mutations
close all
series1 = [1046.28; 1014.35; 385.81]; 
series1error = [210.89; 233.9; 133.83];
series2 = [120.29; 1308.57; 404.32];
series2error = [30.08; 236.89; 152.29];
series = [series1 series2];
errors = [series1error series2error];
labels = {sprintf('mNG-NarL'),sprintf('mNG-NarL'), ...
    sprintf('mNG-NarL')};


c1 = [1 1 1]; c2 = [255 0 0]/255;c3 = [0 0 0];
figure('Units', 'inches','Position', [0 0 8 4.725]); hold on;
b1 = bar(series,1,'EdgeColor',c3,'LineWidth',1,'BaseValue',0);
b1(1).FaceColor = c1; b1(1).DisplayName = '0mM NO3^-';
b1(2).FaceColor = c2; b1(2).DisplayName = '5mM NO3^-';
legend('AutoUpdate','off','Location','NorthEast')

nbars = size(series1, 2);
for j = 1:2
x = [];
for i = 1:nbars
    x = [x ; b1(i,j).XEndPoints];
end
errorbar(x',series(:,j),errors(:,j),'k','linestyle','none','LineWidth',1,'CapSize',6)
end

set(gca, 'XTick', 1:5, 'XTickLabel', labels);

% pbaspect([1,2,1]);
grid on; box on;
pbaspect([1,1,1]);
set(gca,'LineWidth',2,'FontSize',16,'FontName','Arial')
xlim([.5 3.5])
ylim([-200 1800]);set(gca, 'YTick', [-200:200:1800])
ylabel('mCherry fluorescence (a.u.)','FontSize',16,'FontName','Arial')
xlabel('  ','Color',[1 1 1])
%% NarL mutations (r)
series1 = [-0.3144; -0.3147; -0.2267]+0.3144; 
series1error = [.0037; .0021; .007];
series2 = [-0.2697; -0.3166; -.2203]+0.3144;
series2error = [.0035; .0012; .0027];
series = [series1 series2];
errors = [series1error series2error];

s1vals = -[0.3155    0.3102    0.3174;0.3151    0.3165    0.3125;0.2347    0.2242    0.2214]+0.3144;
s2vals = -[0.2738    0.2679    0.2676;0.3163    0.3179    0.3156;0.2231    0.2178    0.2202]+0.3144;

c1 = [1 1 1]; c2 = [209 227 235]/255;c3 = [0 0 0]
figure('Units', 'inches','Position', [0 0 10 4.725]); hold on;
b1 = bar(series,1,'EdgeColor',c3,'LineWidth',1,'BaseValue',0);
b1(1).FaceColor = c1; b1(1).DisplayName = '0mM NO3^-';
b1(2).FaceColor = c2; b1(2).DisplayName = '5mM NO3^-';legend('Location','NorthWest','AutoUpdate','off')

nbars = size(series1, 2);
for j = 1:2
x = [];
for i = 1:nbars
    x = [x ; b1(i,j).XEndPoints];
end
errorbar(x',series(:,j),errors(:,j),'k','linestyle','none','LineWidth',1,'CapSize',5)
end

dotx = [x(1)-2.5*.1429 x(1)-2*.1429 x(1)-1.5*.1429];
for i = 1:3
scatter([dotx dotx+2*.1429]+i-1,[s1vals(i,:) s2vals(i,:)],20,'k','MarkerFaceColor','k')
end

set(gca, 'XTick', 1:5, 'XTickLabel', labels);

% pbaspect([1,2,1]);
grid on; box on;
pbaspect([1,1,1]);
set(gca,'LineWidth',2,'FontSize',16,'FontName','Arial')
ylim([-.02 .105]);xlim([.5 3.5])
set(gca, 'YTick', [-.015:.015:.12])
ylabel('-\Deltar','FontSize',16,'FontName','Arial')
xlabel('  ','Color',[1 1 1])