%% Read data
clc; clear; close all;
G = .9201;
load('../mNG_controls/tot_fit.mat');
load('../mNG_controls/drift_fit_mono.mat');

%% hour data
filenames = {'210929_phop1_shift.xlsx', ...
    '220113_phop_shift_1.xlsx'};

cols = 12;

read_zone_pa = 'A2:L17';
read_zone_pe = 'A19:L34';

time=[0:4:60]*60;

for z = 1:2    
    data(:,:) = readmatrix([filenames{z}],'Range',read_zone_pa);
    rr_pa(1:16,:,z) = data(1:16,:);
    data(:,:) = readmatrix([filenames{z}],'Range',read_zone_pe);
    rr_pe(1:16,:,z) = data(1:16,:);
    rr_pe(:,:,z) = rr_pe(:,:,z)*G;
end
    
rr_tot = rr_pa+2*rr_pe;
rr_r = (rr_pa-rr_pe)./rr_tot;

%% corrections
for z = 1:2
    for i = 1:cols
        tot = rr_tot(1:16,i,z);
        rr_r(1:16,i,z) = rr_r(1:16,i,z)./tot_fit(tot);
%         tot = mean(rr_tot(1:7,i,z));
%         drift = mean(rr_r(1,i,z))*(dr_p1_fit(tot)*time(1:7)'.^2+dr_p2_fit(tot)*time(1:7)'-(1-dr_p3_fit(tot)));
%         rr_r(1:7,i,z) = rr_r(1:7,i,z)-drift;
    end
end
%% Plotting
close all

figure('Units', 'inches', 'Position', [0 0 8 4.725]); hold on;

% c = [209 227 235]/255;
% c2=[83 190 243]/255;
c1 = [.5*[0 0 1]; 1*[0 0 1]; .5*[1 0 0]; 1*[1 0 0]];
var=.8;
% for z = [1 4]
% j = [1:3]
%     plot(time,mean(rr_r(:,1:3,z),2),'Color', c1(3,:))
%     errorbar(time+120,mean(-mean(rr_r(:,j+3,[1 4]),2)+mean(rr_r(:,1:3,[1 4]),2),3),std(rr_r(:,j+3,z),0,2),'Color', c1(2,:),'LineWidth', 2)
%     errorbar(time+120,mean(-mean(rr_r(:,j+9,[1 4]),2)+mean(rr_r(:,7:9,[1 4]),2),3),std(rr_r(:,j+9,z),0,2),'Color', c1(4,:),'LineWidth', 2)
%     errorbar(time,mean(rr_r(:,10:12,z),2)-mean(rr_r(:,7:9,z),2),std(rr_r(:,10:12,z),0,2),'Color', c1(4,:))
%     plot(time,mean(rr_r(:,7:9,z),2),'Color', c1(3,:))
%     plot(time,mean(rr_r(:,10:12,z),2),'Color', c1(4,:))
% end
% end
timesel = [1:7];
delay = 240;
time = time(timesel);

s1 = -[rr_r(timesel,4:6,1)-(rr_r(timesel,1:3,1)) rr_r(timesel,4:6,2)-(rr_r(timesel,1:3,2))];
s2 = -[rr_r(timesel,10:12,1)-(rr_r(timesel,7:9,1)) rr_r(timesel,10:12,2)-(rr_r(timesel,7:9,2))];
% s1 = -[rr_r(timesel,4:6,3)-(rr_r(timesel,1:3,3)) rr_r(timesel,4:6,5)-(rr_r(timesel,1:3,5))];
% s2 = -[rr_r(timesel,10:12,3)-(rr_r(timesel,7:9,3)) rr_r(timesel,10:12,5)-(rr_r(timesel,7:9,5))];

c1 = [153 102 255]/255;
scatter(time+delay,mean(s1,2),40,'Marker','o','MarkerFaceColor',c1,'MarkerEdgeColor','k');
scatter(time+delay,mean(s2,2),40,'Marker','^','MarkerFaceColor',c1,'MarkerEdgeColor','k');
    legend('PhoQ-PhoP', ...
        'PhoQ-PhoP(D52N)', ...
        'Location', 'NorthEast', 'AutoUpdate', 'off', 'FontSize',16, 'FontName', 'Arial')
%         legend('PhoP', ...
%         'PhoP(D52N)', ...
%         'Location', 'NorthEast', 'AutoUpdate', 'off', 'FontSize',16, 'FontName', 'Arial')
errorbar(time+delay,mean(s1,2),std(s1,0,2),'Color','k','LineWidth',1,'LineStyle','none')
plot(time+delay,mean(s1,2),'Color',[.65 .65 .65],'LineWidth',1)
% smoothed = fit(time'+delay,mean(s1,2),'SmoothingSpline','SmoothingParam',.9);
% plot(0:1:4000,smoothed(0:1:4000),'Color',[.65 .65 .65],'LineWidth',2)
scatter(time+delay,mean(s1,2),40,'Marker','o','MarkerFaceColor',c1,'MarkerEdgeColor','k');

errorbar(time+delay,mean(s2,2),std(s2,0,2),'Color','k','LineWidth',1,'LineStyle','none')
plot(time+delay,mean(s2,2),'Color',[.65 .65 .65],'LineWidth',1)
% smoothed = fit(time'+delay,mean(s2,2),'SmoothingSpline','SmoothingParam',.9);
% plot(0:1:4000,smoothed(0:1:4000),'Color',[.65 .65 .65],'LineWidth',2)
scatter(time+delay,mean(s2,2),40,'Marker','^','MarkerFaceColor',c1,'MarkerEdgeColor','k');

% errorbar(time+120,-mean(s2,2),std(s2,0,2),'Color', c1(4,:),'LineWidth', 2)
% 
% errorbar(time+120,-mean(s1,2),std(s1,0,2),'Color', c1(2,:),'LineWidth', 2)
% errorbar(time+120,-mean(s2,2),std(s2,0,2),'Color', c1(4,:),'LineWidth', 2)

xlabel('Time (s)','FontSize',16, 'FontName', 'Arial'); 
ylabel('-\Delta\itr','FontSize',16, 'FontName', 'Arial');
pbaspect([1,1,1]);
ylim([-.005 .025]);xlim([.5 4.5])
set(gca, 'YTick', [-.005:.005:.025])
xlim([0 1920])
set(gca, 'XTick', [0:480:1920])
grid on; box on;grid minor;grid minor;
set(gca,'LineWidth',2,'FontSize',16)
%%
% meandiffs = [.2941 .2672 .2455]-.2941;
for j = [1]
    mean(s1(7,:)-0)
    std(s1(7,:)-0,0,2)
    s1(7,:)-0
    mean(s2(7,:)-0)
    std(s2(7,:)-0,0,2)
    s2(7,:)-0
end
% xlabel('[NO_3^-] mM','FontSize',15.2, 'FontName', 'Arial'); 
% ylabel('Norm. -\Delta\itr','FontSize',15.2, 'FontName', 'Arial');
% pbaspect([1,1,1]);
% grid on; box on;grid minor;grid minor;
% set(gca,'LineWidth',2,'FontSize',15.2)
% set(gca,'XScale','log')
% xlim([1E-5 1E1])
% set(gca, 'XTick', [1E-5 1E-4 1E-3 1E-2 1E-1 1 1E1])