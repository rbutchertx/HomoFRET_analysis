function [] = analyze_NarXL_shortTC_mNGplacement()

all_lines = findobj(gcf,'-property','YData');
for i = 1:2
normed{i} = all_lines(i).YData;
    w = ones(92,1);w(1) = w(1)*6;
    fitobj{i} = fit(all_lines(i).XData',normed{i}'-normed{i}(1),'SmoothingSpline','Weights',w);
end

%%
figure('Name','S8C','IntegerHandle','off','Units', 'inches', 'Position', [0 0 8 4.725]); hold on;
clear c mark
for i = [2 1]
    if i == 2
        c{i} = [209 227 235]/255;
        mark{i} = 'o';
    elseif i == 1
        c{i} = [209 227 235]/255;
        mark{i} = 's';
    end
    scatter(all_lines(i).XData,normed{i}-normed{i}(1)-fitobj{i}(0),20,'Marker',mark{i},'MarkerEdgeColor','k','MarkerFaceColor',c{i})
    legend('mNG-NarL', ...
    'NarL-mNG', ...
    'Location', 'SouthEast', 'AutoUpdate', 'off', 'FontSize',16, 'FontName', 'Arial')
end

xlabel('Time (s)','FontSize',16, 'FontName', 'Arial'); 
ylabel('-\Delta\itr','FontSize',16, 'FontName', 'Arial');
pbaspect([1,1,1]);
grid on; box on;
set(gca,'LineWidth',2,'FontSize',16)
ylim([-.015 .075]);set(gca, 'YTick', -.015:.015:.075)
xlim([0 360])
set(gca, 'XTick', [0 60 120 180 240 300 360])
end