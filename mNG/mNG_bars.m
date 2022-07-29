%Plots mNG control data as bar plot 

clc;clear;close all;
%% mNG bars
series1 = -[0.3095; 0.3095]+0.3095;
series1error = [.0017 0];
series2 = -[0.3095; 0.2711]+0.3095;
series2error = [0 .0043];
labels = {'mNG','mNG-mNG'};
s1vals = -[0.3109    0.3076    0.3101]+.3095;
s2vals = -[0.2733    0.2661    0.2738]+.3095;

c1 = [0 176 80]/255; c2 = [0 .6 0];c3 = [0 0 0];
figure('Name','1C','IntegerHandle','off','Units', 'inches', 'Position', [0 0 8 3.5]); hold on;
b1 = bar(series1,.4,'FaceColor',c1,'EdgeColor',c3,'LineWidth',1,'BaseValue',0);
b2 = bar(series2,0.4,'FaceColor',c1,'EdgeColor',c3,'LineWidth',1,'BaseValue',0);

nbars = size(series1, 2);
x = [];
for i = 1:nbars
    x = [x ; b1(i).XEndPoints];
end
errorbar(x',series1,series1error,'k','linestyle','none','LineWidth',1,'CapSize',5)

nbars = size(series2, 2);
x = [];
for i = 1:nbars
    x = [x ; b2(i).XEndPoints];
end
errorbar(x',series2,series2error,'k','linestyle','none','LineWidth',1,'CapSize',5)

set(gca, 'XTick', 1:2, 'XTickLabel', labels);

scatter([.9 1 1.1 1.9 2 2.1],[s1vals s2vals],20,'k','MarkerFaceColor','k') 

pbaspect([1,1,1]);
set(gca, 'YGrid', 'on', 'XGrid', 'off'); box on;
set(gca,'LineWidth',2,'FontSize',16,'FontName','Arial')
ylim([-.01 .05]);xlim([.5 2.5])
set(gca,'YTick',[0.00:0.02:.04])
ylabel('-\Delta\itr','FontSize',16,'FontName','Arial')
xlabel('  ','Color',[1 1 1])