clc;close all;clear;
%% TorR Transcript
%% TorR data
close all
series1 = [18.90; 378.37; 616.62]; 
series1error = [15.45; 171.39; 565.34];
series2 = [35.82; 2214.40; 1868.33];
series2error = [16.15; 744.24; 744.49];
series = [series1 series2];
errors = [series1error series2error];
labels = {sprintf('TorR-mNG'),sprintf('mNG-TorR'), ...
    sprintf('TorR')};


c1 = [1 1 1]; c2 = [255 0 0]/255;c3 = [0 0 0];
figure('Name','S3E','IntegerHandle','off','Units', 'inches','Position', [0 0 8 4.725]); hold on;
b1 = bar(series,1,'EdgeColor',c3,'LineWidth',1,'BaseValue',0);
b1(1).FaceColor = c1; b1(1).DisplayName = '0mM TMAO';
b1(2).FaceColor = c2; b1(2).DisplayName = '1mM TMAO';
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
ylim([0 3000]);set(gca, 'YTick', [0:500:3000])
ylabel('mCherry fluorescence (a.u.)','FontSize',16,'FontName','Arial')
xlabel('  ','Color',[1 1 1])