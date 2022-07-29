function [] = analyze_TorTSR_longTC_inducers()

all_lines = findobj(gcf,'-property','YData');
for i = 1:4
    normed{i} = all_lines(i).YData;
    w = ones(15,1);w(1) = w(1)*2;
    fitobj{i} = fit(all_lines(i).XData',normed{i}'-normed{i}(1),'a*exp(b*x)+c','StartPoint',[-.03 -.005 .03],'Weights',w);
end
%%
% var = .3;
var = 1;
c = [1 1 1];
figure('Name','S7B, C, or D','IntegerHandle','off','Units', 'inches', 'Position', [0 0 8 4.725]); hold on;
for i = [4 3 2 1]
    mark = 'o';
    plot(0:3000,fitobj{i}(0:3000)-fitobj{i}(0),'Color',c*(var-.233),'LineWidth',2)
    scatter(all_lines(i).XData,normed{i}-normed{i}(1)-fitobj{i}(0),20,'Marker',mark,'MarkerEdgeColor','k','MarkerFaceColor',c*var)
    var=var-.233;
end

xlabel('Time (s)','FontSize',16, 'FontName', 'Arial'); 
ylabel('-\Delta\itr','FontSize',16, 'FontName', 'Arial');
pbaspect([1,1,1]);
grid on; box on;
set(gca,'LineWidth',2,'FontSize',16)
ylim([-.015 .045]);set(gca, 'YTick', -.015:.015:.045)
xlim([0 360])
set(gca, 'XTick', [0 60 120 180 240 300 360])
xlim([0 3000])
set(gca, 'XTick', 10*[0 60 120 180 240 300 360])