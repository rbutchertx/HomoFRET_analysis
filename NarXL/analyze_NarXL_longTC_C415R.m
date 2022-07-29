function [] = analyze_NarXL_longTC_C415R(rr_r)

all_lines = findobj(gcf,'-property','YData');
for i = 1:2
normed{i} = all_lines(i).YData;
    w = ones(15,1);w(1) = w(1)*2;
    fitobj{i} = fit(all_lines(i).XData',smooth(normed{i}'-normed{i}(1),1),'SmoothingSpline','Weights',w)
    if i == 1
        fitobj{i} = fit(all_lines(i).XData',smooth(normed{i}'-normed{i}(1),1),'exp2','Weights',w)
    end
end
%%
figure('Name','4C','IntegerHandle','off','Units', 'inches', 'Position', [0 0 8 4.725]); hold on;
for i = [2 1]
    if i == 2
        c{i} = [209 227 235]/255;
        mark{i} = 'o';
    elseif i == 1
        c{i} = [83 190 243]/255;
        mark{i} = 'o';
    end
    scatter(all_lines(i).XData,normed{i}-normed{i}(1)-fitobj{i}(0),40,'Marker',mark{i},'MarkerEdgeColor','k','MarkerFaceColor',c{i})
    legend('NarX, NarL', ...
        'NarX (C415R), NarL', ...
        'Location', 'SouthEast', 'AutoUpdate', 'off', 'FontSize',16, 'FontName', 'Arial')
end
for i = [2 1]
    x = all_lines(i).XData;
    y = normed{i}-normed{i}(1)-fitobj{i}(0);
    sel = [14 7];
    y_err = smooth(std(rr_r([2:16],sel(i),1:3),0,3)',3)';
    plot(0:3000,fitobj{i}(0:3000)-fitobj{i}(0),'Color',[.65 .65 .65],'LineWidth',2)
    errorbar(x,y,y_err,'Color','k','LineWidth',1,'LineStyle','none')
end
for i = [2 1]
    scatter(all_lines(i).XData,normed{i}-normed{i}(1)-fitobj{i}(0),40,'Marker',mark{i},'MarkerEdgeColor','k','MarkerFaceColor',c{i})
end

xlabel('Time (s)','FontSize',16, 'FontName', 'Arial'); 
ylabel('-\Delta\itr','FontSize',16, 'FontName', 'Arial');
pbaspect([1,1,1]);
grid on; box on;
set(gca,'LineWidth',2,'FontSize',16)
ylim([-.02 .12]);set(gca, 'YTick', -.02:.02:.12)
xlim([0 3000])
set(gca, 'XTick', 10*[0 60 120 180 240 300 360])