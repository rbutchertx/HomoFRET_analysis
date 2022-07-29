%% Read data
clc; clear; close all;
G = .9201;
load('../mNG/tot_fit.mat');
load('../mNG/drift_fit_mono.mat');

%% hour data
filenames = {'210929_phop1_shift.xlsx', ...
    '220113_phop_shift_1.xlsx', ...
    '211012_phop2_shift.xlsx', ...
    '220113_phop_shift_2.xlsx'};

cols = 12;

read_zone_pa = 'A2:L17';
read_zone_pe = 'A19:L34';

time=[0:4:60]*60;

for z = 1:4    
    data(:,:) = readmatrix([filenames{z}],'Range',read_zone_pa);
    rr_pa(1:16,:,z) = data(1:16,:);
    data(:,:) = readmatrix([filenames{z}],'Range',read_zone_pe);
    rr_pe(1:16,:,z) = data(1:16,:);
    rr_pe(:,:,z) = rr_pe(:,:,z)*G;
end
    
rr_tot = rr_pa+2*rr_pe;
rr_r = (rr_pa-rr_pe)./rr_tot;

%% corrections
for z = 1:4
    for i = 1:cols
        tot = rr_tot(1:16,i,z);
        rr_r(1:16,i,z) = rr_r(1:16,i,z)./tot_fit(tot);
        %No drift calculation due to LL37 growth alteration
    end
end
%% Plotting
close all

figure('Name','S5B','IntegerHandle','off','Units', 'inches', 'Position', [0 0 8 4.725]); hold on;

c1 = [.5*[0 0 1]; 1*[0 0 1]; .5*[1 0 0]; 1*[1 0 0]];
var=.8;
timesel = [1:7];
delay = 240;
time = time(timesel);

s1 = -[rr_r(timesel,4:6,1)-(rr_r(timesel,1:3,1)) rr_r(timesel,4:6,2)-(rr_r(timesel,1:3,2))];
s2 = -[rr_r(timesel,10:12,1)-(rr_r(timesel,7:9,1)) rr_r(timesel,10:12,2)-(rr_r(timesel,7:9,2))];
% Set below for strains missing PhoQ
% s1 = -[rr_r(timesel,4:6,3)-(rr_r(timesel,1:3,3)) rr_r(timesel,4:6,4)-(rr_r(timesel,1:3,4))];
% s2 = -[rr_r(timesel,10:12,3)-(rr_r(timesel,7:9,3)) rr_r(timesel,10:12,4)-(rr_r(timesel,7:9,4))];

c1 = [153 102 255]/255;
scatter(time+delay,mean(s1,2),40,'Marker','o','MarkerFaceColor',c1,'MarkerEdgeColor','k');
scatter(time+delay,mean(s2,2),40,'Marker','^','MarkerFaceColor',c1,'MarkerEdgeColor','k');
    legend('PhoQ-PhoP', ...
        'PhoQ-PhoP(D52N)', ...
        'Location', 'NorthEast', 'AutoUpdate', 'off', 'FontSize',16, 'FontName', 'Arial')
errorbar(time+delay,mean(s1,2),std(s1,0,2),'Color','k','LineWidth',1,'LineStyle','none')
plot(time+delay,mean(s1,2),'Color',[.65 .65 .65],'LineWidth',1)
scatter(time+delay,mean(s1,2),40,'Marker','o','MarkerFaceColor',c1,'MarkerEdgeColor','k');
errorbar(time+delay,mean(s2,2),std(s2,0,2),'Color','k','LineWidth',1,'LineStyle','none')
plot(time+delay,mean(s2,2),'Color',[.65 .65 .65],'LineWidth',1)
scatter(time+delay,mean(s2,2),40,'Marker','^','MarkerFaceColor',c1,'MarkerEdgeColor','k');

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
for j = [1]
    mean(s1(7,:)-0)
    std(s1(7,:)-0,0,2)
    s1(7,:)-0
    mean(s2(7,:)-0)
    std(s2(7,:)-0,0,2)
    s2(7,:)-0
end