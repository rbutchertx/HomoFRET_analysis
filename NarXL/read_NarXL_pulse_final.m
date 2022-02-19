%% Read data
clc; clear; close all;
G = .9201;
load('../mNG_controls/tot_fit.mat');
load('../mNG_controls/drift_fit_mono.mat');

%% hour data
filename = 'NarXL_data_compiled.xlsx';

cols = 18;

read_zone_pa = 'B2:J40';
read_zone_pe = 'B43:J81';

time=[4:4:156]*60;

for z = 1:3
    data(:,:) = readmatrix(filename,'Sheet',['211027'],'Range',read_zone_pa);
    rr_pa(1:39,:,z) = data(:,[1 4 7]+1*(z-1));
    data(:,:) = readmatrix(filename,'Sheet',['211027'],'Range',read_zone_pe);
    rr_pe(1:39,:,z) = data(:,[1 4 7]+1*(z-1));
end    
rr_pe = rr_pe*G;    

rr_tot = rr_pa+2*rr_pe;
rr_r = (rr_pa-rr_pe)./rr_tot;

%% corrections
rr_r_rel = [];
rr_r_norm = [];
for z = 1:3
    for i = 1:3
        tot = rr_tot(1:39,i,z);
        rr_r(1:39,i,z) = rr_r(1:39,i,z)./tot_fit(tot);
    end
    for i = 1:3
        rr_r_rel(1:39,i,z) = -(rr_r(1:39,i,z)-rr_r(1:39,1,z));
    end
end

%% Time plot
figure('Units', 'inches', 'Position', [0 0 8 4.725]); hold on;

time=[4:4:156]*60;
time =time-72*60;
c1 = [83 190 243]/255;
c2 = .4*[83 190 243]/255;
time = time(18:33);
s1=rr_r_rel(18:33,1,:);
s1_err=rr_r(18:33,1,:);
s2=rr_r_rel(18:33,2,:);
s2_err=rr_r(18:33,2,:);
s3=rr_r_rel(18:33,3,:);
s3_err=rr_r(18:33,3,:);
scatter(time,mean(s1,3),40,'Marker','o','MarkerFaceColor',c1,'MarkerEdgeColor','k');
scatter(time,mean(s2,3),40,'Marker','^','MarkerFaceColor',c1,'MarkerEdgeColor','k');
scatter(time,mean(s3,3),40,'Marker','s','MarkerFaceColor',c1,'MarkerEdgeColor','k');
%     legend('NarX, NarL, 0\muM NO_3^-', ...
%         'NarX, NarL, 500\muM NO_3^-', ...
%         'NarX (C415R), NarL, 5\muM NO_3^-', ...
%         'Location', 'SouthEast', 'AutoUpdate', 'off', 'FontSize',16, 'FontName', 'Arial')
    legend('0\muM nitrate', ...
        '10\muM nitrate', ...
        '50\muM nitrate', ...
        'Location', 'NorthEast', 'AutoUpdate', 'off', 'FontSize',16, 'FontName', 'Arial')
% x = 0:10000;
% err_fit = fit(time',mean(s1,3),'SmoothingSpline');
% err_fit2 = fit(time',std(s1_err,0,3),'SmoothingSpline');
% a = fill([x flip(x)],[err_fit(x)-err_fit2(x); flip(err_fit(x)+err_fit2(x))],'w','LineWidth',1);
% set(a,'facealpha',.3);
% plot([0 0],[-.02 .12],'--k','LineWidth',2)
% plot([74 74]*60,[-.02 .12],'--k','LineWidth',2)
% plot([106 106]*60,[-.02 .12],'--k','LineWidth',2)
% plot([1 1]*60,[-.02 .12],'--k','LineWidth',2)
% plot([33 33]*60,[-.02 .12],'--k','LineWidth',2)
errorbar(time(1:1:end),mean(s1(1:1:end,1,:),3),std(s1_err(1:1:end,1,:),0,3),'Color','k','LineWidth',1,'LineStyle','none')
plot(time,mean(s1,3),'Color',[.65 .65 .65],'LineWidth',2)
scatter(time,mean(s1,3),40,'Marker','o','MarkerFaceColor',c1,'MarkerEdgeColor','k');
errorbar(time(1:1:end),mean(s2(1:1:end,1,:),3),std(s2_err(1:1:end,1,:),0,3),'Color','k','LineWidth',1,'LineStyle','none')
smoothed = fit(time',mean(s2,3),'SmoothingSpline','SmoothingParam',.9);
plot(0:1:4000,smoothed(0:1:4000),'Color',[.65 .65 .65],'LineWidth',2)
% plot(time,mean(s2,3),'Color',[.65 .65 .65],'LineWidth',2)
scatter(time,mean(s2,3),40,'Marker','^','MarkerFaceColor',c1,'MarkerEdgeColor','k');
errorbar(time(1:1:end),mean(s3(1:1:end,1,:),3),std(s3_err(1:1:end,1,:),0,3),'Color','k','LineWidth',1,'LineStyle','none')
smoothed = fit(time',mean(s3,3),'SmoothingSpline','SmoothingParam',.9);
plot(0:1:4000,smoothed(0:1:4000),'Color',[.65 .65 .65],'LineWidth',2)
% plot(time,mean(s3,3),'Color',[.65 .65 .65],'LineWidth',2)
scatter(time,mean(s3,3),40,'Marker','s','MarkerFaceColor',c1,'MarkerEdgeColor','k');


ylim([-.015 .12])
set(gca, 'YTick', -.02:.02:.12)
xlim([0 3600])
set(gca, 'XTick', 10*[0:120:360])
xlabel('Time (s)','FontSize',16, 'FontName', 'Arial'); 
ylabel('-\Delta\itr','FontSize',16, 'FontName', 'Arial');
pbaspect([1,1,1]);
grid on; box on;grid minor;grid minor;
set(gca,'LineWidth',2,'FontSize',16)