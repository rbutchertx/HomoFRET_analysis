all_lines = findobj(gcf,'-property','YData');
for i = 1:4
    normed{i} = all_lines(i).YData;
    w = ones(15,1);w(1) = w(1)*2;
% w = ones(92,1);w(1) = w(1)*6;
    fitobj{i} = fit(all_lines(i).XData',smooth(normed{i}'-normed{i}(1),3),'SmoothingSpline','Weights',w)
end
%%
var = .3;
var = 1;
c = [209 227 235]/255;
figure('Units', 'inches', 'Position', [0 0 8 4.725]); hold on;
for i = [1:4]
    if i < 0
        mark = 's';
    else
        mark = 'o';
    end
    plot(0:3000,fitobj{i}(0:3000)-fitobj{i}(0),'Color',c*var-.1,'LineWidth',2)
    scatter(all_lines(i).XData,normed{i}-normed{i}(1)-fitobj{i}(0),20,'Marker',mark,'MarkerEdgeColor','k','MarkerFaceColor',c*var)
%     var=var+.233;
    
    y = fitobj{i}(0:3000)-fitobj{i}(0);
    x = 0:3000;
    max(y)
    t_half = x(y>.5*max(y));
    T50(i) = t_half(1);
end
flip(T50)


    legend('mNG-NarL', ...
        'NarL-mNG', ...
        'Location', 'SouthEast', 'AutoUpdate', 'off', 'FontSize',16, 'FontName', 'Arial')
xlabel('Time (s)','FontSize',16, 'FontName', 'Arial'); 
ylabel('-\Delta\itr','FontSize',16, 'FontName', 'Arial');
pbaspect([1,1,1]);
grid on; box on;
set(gca,'LineWidth',2,'FontSize',16)
ylim([-.015 .075]);set(gca, 'YTick', -.015:.015:.075)
xlim([0 360])
set(gca, 'XTick', [0 60 120 180 240 300 360])
xlim([0 3000])
set(gca, 'XTick', 10*[0 60 120 180 240 300 360])