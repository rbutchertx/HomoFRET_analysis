function [] = analyze_NarXL_longTC_SuppPromotersTC(rr_r)

all_lines = findobj(gcf,'-property','YData');
for i = 1:2
normed{i} = all_lines(i).YData;
    w = ones(15,1);w(1) = w(1)*2;
    fitobj{i} = fit(all_lines(i).XData',normed{i}'-normed{i}(1),'SmoothingSpline','Weights',w)
end
%%
figure('Name','S9C','IntegerHandle','off','Units', 'inches', 'Position', [0 0 8 4.725]); hold on;
clear c mark
for i = [2 1]
    if i == 2
        c{i} = [209 227 235]/255;
        mark{i} = 'o';
    elseif i == 1
        c{i} = [209 227 235]/255;
        mark{i} = 's';
    end
    scatter(all_lines(i).XData,normed{i}-normed{i}(1)-fitobj{i}(0),40,'Marker',mark{i},'MarkerEdgeColor','k','MarkerFaceColor',c{i})
    legend('-P{\it_d_c_u_S}_7_7', ...
        '+P{\it_d_c_u_S}_7_7', ...
        'Location', 'SouthEast', 'AutoUpdate', 'off', 'FontSize',16, 'FontName', 'Arial')
end
for i = [2 1]
    x = all_lines(i).XData;
    y = normed{i}-normed{i}(1)-fitobj{i}(0);
    sel = [2 7]+1;
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
ylim([-.015 .075]);set(gca, 'YTick', -.015:.015:.075)
xlim([0 3000])
set(gca, 'XTick', 10*[0 60 120 180 240 300 360])