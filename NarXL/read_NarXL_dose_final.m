%% Read data
clc; clear; close all;
G = .9201;
load('../mNG_controls/tot_fit.mat');
load('../mNG_controls/drift_fit_mono.mat');

%% hour data
filename = 'NarXL_data_compiled.xlsx';

cols = 24;

read_zone_pa = 'B2:BU49';
read_zone_pe = 'B52:BU99';

time=[4:4:192]*60;

for z = 1:3
    data(:,:) = readmatrix(filename,'Sheet',['211017'],'Range',read_zone_pa);
    rr_pa(1:48,:,z) = data(:,[1:12 37:48]+12*(z-1));
    data(:,:) = readmatrix(filename,'Sheet',['211017'],'Range',read_zone_pe);
    rr_pe(1:48,:,z) = data(:,[1:12 37:48]+12*(z-1));
end    
rr_pe = rr_pe*G;    

rr_tot = rr_pa+2*rr_pe;
rr_r = (rr_pa-rr_pe)./rr_tot;

%% corrections
rr_r_rel = [];
rr_r_norm = [];
for z = 1:3
    for i = 1:24
        tot = rr_tot(1:48,i,z);
        rr_r(1:48,i,z) = rr_r(1:48,i,z)./tot_fit(tot);
    end
    for i = 1:12
%         rr_r_rel(1:48,i,z) = -(rr_r(1:48,i,z)-rr_r(1:48,13,z));
        rr_r_rel(1:48,i,z) = -(rr_r(1:48,i,z)-rr_r(1:48,1,z));
        rr_r_rel(1:48,i+12,z) = -(rr_r(1:48,i+12,z)-rr_r(1:48,13,z));
    end
    for i = 1:12
        rr_r_norm(:,i,z) = rr_r_rel(:,i,z)./rr_r_rel(:,11,z);
        rr_r_norm(:,i+12,z) = rr_r_rel(:,i+12,z)./rr_r_rel(:,23,z);
    end
end
%% Plotting

% close all

figure('Units', 'inches', 'Position', [0 0 8 4.91]); hold on;

c1 = [209 227 235]/255;
c2=[83 190 243]/255;
var=1;
conc = flip([50 10 5 1 .5 .1 .01 .005 .001 .0005 .00005 .00001]); %final value is actually 0

for j = [7]
%     s1=rr_r_norm(j,13:23,:);
%     s2=rr_r_norm(j,1:11,:);
    s1=rr_r_rel(j,13:23,:)./(ones(1,11,3).*mean(rr_r_rel(j,23,:),3));
    s2=rr_r_rel(j,1:11,:)./(ones(1,11,3).*mean(rr_r_rel(j,11,:),3));
    scatter(conc(1:11),mean(s1,3),40,'MarkerFaceColor',c1*var,'MarkerEdgeColor','k');
    scatter(conc(1:11),mean(s2,3),40,'MarkerFaceColor',c2*var,'MarkerEdgeColor','k');
        legend('NarX, NarL', ...
        'NarX (C415R), NarL', ...
        'Location', 'SouthEast', 'AutoUpdate', 'off', 'FontSize',16, 'FontName', 'Arial')
    errorbar(conc(1:11),mean(s1,3),std(s1,0,3),'Color','k','LineWidth',1,'LineStyle','none')
    smoothed=fit(conc(1:11)',mean(s1,3)','x^a/(b+x^a)');smoothed
    plot(1E-5:.0001:10,smoothed(1E-5:.0001:10),'Color',[.65 .65 .65],'LineWidth',2)
    scatter(conc(1:11),mean(s1,3),40,'MarkerFaceColor',c1*var,'MarkerEdgeColor','k');
    errorbar(conc(1:11),mean(s2,3),std(s2,0,3),'Color','k','LineWidth',1,'LineStyle','none')
    smoothed=fit(conc(1:11)',mean(s2,3)','x^a/(b+x^a)');smoothed
    plot(1E-5:.0001:10,smoothed(1E-5:.0001:10),'Color',[.65 .65 .65],'LineWidth',2)
    scatter(conc(1:11),mean(s2,3),40,'MarkerFaceColor',c2*var,'MarkerEdgeColor','k');
    var = var+.01;
end
xlabel('[NO_3^-] mM','FontSize',16, 'FontName', 'Arial'); 
ylabel('Norm. -\Delta\itr','FontSize',16, 'FontName', 'Arial');
pbaspect([1,1,1]);
grid on; box on;grid minor;grid minor;
set(gca,'LineWidth',2,'FontSize',16)
set(gca,'XScale','log')
xlim([1E-5 1E1])
set(gca, 'XTick', [1E-5 1E-4 1E-3 1E-2 1E-1 1 1E1])

%% Time plot
figure('Units', 'inches', 'Position', [0 0 8 4.725]); hold on;

c1 = [209 227 235]/255;
c2=[83 190 243]/255;
var=0;
count = 0;
for i = [4 6:10]
c1_i = c1*(1-.75*count/5);
c2_i = c2*(1-.75*count/5);
s1=rr_r_rel(:,i+12,:);
s1_err=rr_r(:,i+12,:);
s2=rr_r_rel(:,i,:);
s2_err=rr_r(:,i,:);
errorbar(time,mean(s1,3),std(s1_err,0,3),'Color','k','LineWidth',1,'LineStyle','none')
plot(time,mean(s1,3),'Color',c1_i,'LineWidth',2)
scatter(time,mean(s1,3),40,'Marker','o','MarkerFaceColor',c1_i,'MarkerEdgeColor','k');
errorbar(time,mean(s2,3),std(s2_err,0,3),'Color','k','LineWidth',1,'LineStyle','none')
errorbar(time,mean(s2,3),std(s2,0,3),'Color','k','LineWidth',1,'LineStyle','none')
plot(time,mean(s2,3),'Color',c2_i,'LineWidth',2)
scatter(time,mean(s2,3),40,'MarkerFaceColor',c2_i,'MarkerEdgeColor','k');
var = var+.1;
count = count+1;
end

ylim([-.02 .12])
xlim([0 9000])
set(gca, 'XTick', 10*[0:180:900])
xlabel('Time (s)','FontSize',16, 'FontName', 'Arial'); 
ylabel('-\Delta\itr','FontSize',16, 'FontName', 'Arial');
pbaspect([1,1,1]);
grid on; box on;grid minor;grid minor;
set(gca,'LineWidth',2,'FontSize',16)