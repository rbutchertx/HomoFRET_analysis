function [] = analyze_TorTSR_longTC_mNGplacement(rr_conc)

all_lines = findobj(gcf,'-property','YData');
for i = 1:30
    normed{i} = all_lines(i).YData;  
    w = ones(15,1);w(1) = w(1)*2;
    fitobj{i} = fit(all_lines(i).XData',normed{i}'-normed{i}(1),'SmoothingSpline');
end
%%
var = .3;
var = 1;
c = [255 255 255]/255;
for i = 1:30
    y = fitobj{i}(0:3000)-fitobj{i}(0);
    x = 0:3000;
    max(y)
    t_half = x(y>.5*max(y));
    T50(i) = t_half(1);
    amp(i) = max(y);
end

T50_f = flip(T50);

samp2 = [rr_conc(1,6:10,1); rr_conc(1,6:10,2); rr_conc(1,6:10,3)]/100000; 
samp1 = [rr_conc(1,11:15,1); rr_conc(1,11:15,2); rr_conc(1,11:15,3)]/100000;

T50_f2 = [T50_f(1:5); T50_f(11:15); T50_f(21:25)];
T50_f1 = [T50_f(6:10); T50_f(16:20); T50_f(26:30)];

figure('Name','S3D','IntegerHandle','off','Units', 'inches', 'Position', [0 0 8 4.725]); hold on;
scatter(mean(samp1,1),mean(T50_f1,1), ...
    40,'o','MarkerEdgeColor','k','MarkerFaceColor',1*[1 1 1],'LineWidth',1);
scatter(mean(samp2,1),mean(T50_f2,1), ...
    40,'s','MarkerEdgeColor','k','MarkerFaceColor',1*[1 1 1],'LineWidth',1);
legend('TorR-mNG', ...
    'mNG-TorR', ...
    'Location', 'SouthEast', 'AutoUpdate', 'off', 'FontSize',16, 'FontName', 'Arial')
errorbar(mean(samp1,1),mean(T50_f1,1),std(T50_f1,[],1),std(T50_f1,[],1), ...
    'o','MarkerEdgeColor','k','MarkerFaceColor',1*[1 1 1],'LineWidth',1,'Color','k','LineStyle','-');
errorbar(mean(samp2,1),mean(T50_f2,1),std(T50_f2,[],1),std(T50_f2,[],1), ...
    's','MarkerEdgeColor','k','MarkerFaceColor',1*[1 1 1],'LineWidth',1,'Color','k','LineStyle','-');
xlabel('(Tot. fl.)/(abs600nm)','FontSize',16, 'FontName', 'Arial'); 
ylabel('T1/2','FontSize',16, 'FontName', 'Arial');
ylim([0 800]);
pbaspect([1,1,1]);
grid on; box on;
set(gca,'LineWidth',2,'FontSize',16)