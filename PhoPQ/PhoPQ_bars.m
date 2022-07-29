close all;clear;clc
%% phoP data
close all
series1 = [0; 0; 0; 0]; 
series1error = [0; 0; 0; 0];
series2 = [0.0147; 0.0061; .0020; .0051];
series2error = [.0015; .0032; .0042; .0044];
% series = [series1 series2];
% errors = [series1error series2error];
series = [series2];
errors = [series2error];

s1vals = -[0 0 0 0 0 0;0 0 0 0 0 0;0 0 0 0 0 0;0 0 0 0 0 0]
s2vals = [0.0153    0.0119    0.0158    0.0155    0.0142    0.0154;0.0023    0.0060    0.0031    0.0109    0.0056    0.0084; 0.0077    0.0048    0.0041   -0.0015   -0.0031   -0.0003; 0.0027    0.0075    0.0117    0.0035    0.0062   -0.0011];

c1 = [1 1 1]; c2 = [153 102 255]/255;c3 = [0 0 0];
figure('Name','S5C','IntegerHandle','off','Units', 'inches','Position', [0 0 10 4.725]); hold on;
b1 = bar(series,1,'EdgeColor',c3,'LineWidth',1,'BaseValue',0,'BarWidth',.5);
% b1(1).FaceColor = c1; b1(1).DisplayName = '0\muM LL37';
b1.FaceColor = c1*.9; b1.DisplayName = '0\muM LL37';
% b1(2).FaceColor = c2; b1(2).DisplayName = '5\muM LL37';legend('Location','SouthWest','AutoUpdate','off')

labels = {'a','a'};
nbars = size(series1, 2);
for j = 1:1
x = [];
for i = 1:nbars
    x = [x ; b1(i,j).XEndPoints];
end
errorbar(x',series(:,j),errors(:,j),'k','linestyle','none','LineWidth',1,'CapSize',5)
end

dotx = [x(1)-2.75*.1429 x(1)-2.5*.1429 x(1)-2.25*.1429 x(1)-2*.1429 x(1)-1.75*.1429 x(1)-1.5*.1429]+.0125;
for i = 1:4
% scatter([dotx dotx+2*.1429]+i-1,[s1vals(i,:) s2vals(i,:)],20,'k','MarkerFaceColor',[.5 .5 .5])
scatter([dotx+2*.1429]+i-1,[s2vals(i,:)],20,'k','MarkerFaceColor',c2)
end

set(gca, 'XTick', 1:5, 'XTickLabel', labels);

% pbaspect([1,2,1]);
grid on; box on;
pbaspect([1,1,1]);
set(gca,'LineWidth',2,'FontSize',16,'FontName','Arial')
ylim([-.005 .025]);xlim([.5 4.5])
set(gca, 'YTick', [-.005:.005:.025])
ylabel('-\Delta\itr','FontSize',16,'FontName','Arial')
xlabel('  ','Color',[1 1 1])