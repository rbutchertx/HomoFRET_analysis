%% Read data
clc; clear; close all;

%Load correction files
load('../../mNG/tot_fit.mat');
load('../../mNG/drift_fit_mono.mat');
G = .9201;
%% hour data
filenames = {'220525_genomic.xlsx', ...
    '220527_genomic.xlsx', ...
    '220528_genomic.xlsx'};

cols = 12;

read_zone_a = 'P79:Y79';
read_zone_pa = 'D72:O89';
read_zone_pe = 'D92:O109';

time = [0 1:4:49]*60;

for z = 1:3    
    data(:,:) = readmatrix(filenames{z},'Sheet',[1],'Range',read_zone_pa);
    rr_pa(1:2,:,z) = data(1:2,:);
    rr_pa(3:18,:,z) = data(3:18,:);
    data(:,:) = readmatrix(filenames{z},'Sheet',[1],'Range',read_zone_pe);
    rr_pe(1:2,:,z) = data(1:2,:);
    rr_pe(3:18,:,z) = data(3:18,:);
    rr_pe(:,:,z) = rr_pe(:,:,z)*G;
end

rr_tot = rr_pa+2*rr_pe;
rr_r = (rr_pa-rr_pe)./rr_tot;

%% Hour timecourse plotting
figure('Name','3E','IntegerHandle','off','Units', 'inches', 'Position', [0 0 6 4.725]); hold on;
c = [1 1 1];
var = 1;

sel = [1:3];
%The option below will plot TorTSR data when uncommented
% sel = [1:3]+3;

for i = 1:3
    samp1(:,[1:3]+3*(i-1)) = rr_r(:,sel,i);
    samp2(:,[1:3]+3*(i-1)) = rr_r(:,sel+6,i);
end
samp1_corr = mean(samp1(1:2,:))-samp1;
samp2_corr = mean(samp2(1:2,:))-samp2;

samp1_corr = [mean(samp1_corr(1:2,:)); samp1_corr(3:15,:)];
samp2_corr = [mean(samp2_corr(1:2,:)); samp2_corr(3:15,:)];

blfit = fit(time(2:end)',mean(samp1_corr(2:end,:),2),'SmoothingSpline');
samp1_corr2 = mean([samp1_corr(1,:); samp1_corr(2:end,:)-blfit(time(2:end))],2);
samp2_corr2 = mean([samp2_corr(1,:); samp2_corr(2:end,:)-blfit(time(2:end))],2);

w = ones(14,1);w(1) = w(1)*2;
fitobj1 = fit(time',smooth(samp1_corr2,3),'SmoothingSpline','Weights',w);
fitobj2 = fit(time',smooth(samp2_corr2,3),'SmoothingSpline','Weights',w);

c = [209 227 235]/255;
% c = .3*[255 255 255]/255;

scatter(time,samp1_corr2,40,'Marker','o','MarkerEdgeColor','k','MarkerFaceColor',[1 1 1])
scatter(time,samp2_corr2,40,'Marker','o','MarkerEdgeColor','k','MarkerFaceColor',c)

legend('0mM nitrate', ...
    '5mM nitrate', ...
    'Location', 'NorthEast', 'AutoUpdate', 'off', 'FontSize',16, 'FontName', 'Arial')

y_err1 = std(samp1_corr2,[],2);
y_err2 = std(samp2_corr2,[],2);
plot(0:3000,fitobj2(0:3000),'Color',[.65 .65 .65],'LineWidth',2)
plot(0:3000,fitobj1(0:3000),'Color',[.65 .65 .65],'LineWidth',2)
errorbar(time,samp1_corr2,std(samp1_corr,[],2),'Color','k','LineWidth',1,'LineStyle','none')
errorbar(time,samp2_corr2,std(samp2_corr,[],2),'Color','k','LineWidth',1,'LineStyle','none')
scatter(time,samp1_corr2,40,'Marker','o','MarkerEdgeColor','k','MarkerFaceColor',[1 1 1])
scatter(time,samp2_corr2,40,'Marker','o','MarkerEdgeColor','k','MarkerFaceColor',c)

xlabel('Time (s)','FontSize',16, 'FontName', 'Arial'); 
ylabel('-{\Delta\itr} (x10^-^3)','FontSize',16, 'FontName', 'Arial');
pbaspect([1,1,1]);
grid on; box on;
set(gca,'LineWidth',2,'FontSize',16)
% ylim([-.02 .12]);set(gca, 'YTick', -.02:.02:.12)
ylim([-.015 .075]*.1);set(gca, 'YTick', [-.015:.015:.075]*.1);set(gca, 'YTickLabel', [-.015:.015:.075])
xlim([0 3000])
set(gca, 'XTick', 10*[0 60 120 180 240 300 360])

gen_data = samp2_corr2;
gen_std = std(samp2_corr,[],2);
gen_fit = fitobj2(0:3000);
save('holddata.mat','gen_data','gen_std','gen_fit')