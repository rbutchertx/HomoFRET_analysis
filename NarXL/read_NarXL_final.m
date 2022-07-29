%% Read data
clc; clear; close all;

%Load correction files
load('../mNG/tot_fit.mat');
load('../mNG/drift_fit_mono.mat');
G = .9201;
%% hour data
filename = 'NarXL_data_compiled.xlsx';

cols = 15;

read_zone_pa = 'B6:P24';
read_zone_pe = 'B25:P43';

time = [0	240	265	290	530	770	1010	1250	1490	1730	1970	2210	2450	2690	2930	3170	3410	3650	3890];

lag = time(3);
time = time([1:2 4:19]);

for z = 1:3    
    data(:,:) = readmatrix(filename,'Sheet',['Sheet' num2str(z)],'Range',read_zone_pa);
    rr_pa(1:2,:,z) = data(1:2,:);
    rr_pa(3:18,:,z) = data(4:19,:);
    data(:,:) = readmatrix(filename,'Sheet',['Sheet' num2str(z)],'Range',read_zone_pe);
    rr_pe(1:2,:,z) = data(1:2,:);
    rr_pe(3:18,:,z) = data(4:19,:);
    rr_pe(:,:,z) = rr_pe(:,:,z)*G;
end

rr_tot = rr_pa+2*rr_pe;
rr_r = (rr_pa-rr_pe)./rr_tot;
%% hour corrections
for z = 1:3
    for i = 1:cols
        tot = rr_tot(1:18,i,z);
        rr_r(1:18,i,z) = rr_r(1:18,i,z)./tot_fit(tot);
        tot = mean(rr_tot(1:18,i,z));
        drift = mean(rr_r(1:2,i,z))*(dr_p1_fit(tot)*time(3:18)'.^2+dr_p2_fit(tot)*time(3:18)'-(1-dr_p3_fit(tot)));
        rr_r(3:18,i,z) = rr_r(3:18,i,z)-drift;
    end
end

%% short timecourse data
filename = 'NarXL_data_compiled.xlsx';

cols = 11;

read_zone_pa = 'B6:L103';
read_zone_pe = 'B104:L201';

time_s = [0:4:20 24.8 27.9:4:387.9];

lag_s = time_s(7);
time_s = time_s([1:6 8:98]);

data=[];
for z = 1:3
    data(:,:) = readmatrix(filename,'Sheet',['Sheet' num2str(z+3)],'Range',read_zone_pa);
    rr_pa_s(1:6,:,z) = data(1:6,:);
    rr_pa_s(7:97,:,z) = data(8:98,:);
    data(:,:) = readmatrix(filename,'Sheet',['Sheet' num2str(z+3)],'Range',read_zone_pe);
    rr_pe_s(1:6,:,z) = data(1:6,:);
    rr_pe_s(7:97,:,z) = data(8:98,:);
    rr_pe_s(:,:,z) = rr_pe_s(:,:,z)*G;    
end

rr_tot_s = rr_pa_s+2*rr_pe_s;
rr_r_s = (rr_pa_s-rr_pe_s)./rr_tot_s;

%% short timecourse corrections
for z = 1:3
    for i = 1:cols
        tot = rr_tot_s(1:97,i,z);
        rr_r_s(1:97,i,z) = rr_r_s(1:97,i,z)./tot_fit(tot);
        tot = mean(rr_tot_s(1:97,i,z));
        drift = mean(rr_r_s(1:6,i,z))*(dr_p1_fit(tot)*time_s(7:97)'.^2+dr_p2_fit(tot)*time_s(7:97)'-(1-dr_p3_fit(tot)));
        rr_r_s(7:97,i,z) = rr_r_s(7:97,i,z)-drift;
    end
end

%% total fluorescence plotting
close all

% figure('Units', 'inches', 'Position', [0 0 6 4.82]); hold on;
% for j = 1:3
%     plot(1:15,mean(rr_tot(1:18,:,j)),'LineWidth',2)
% end
% set(gca,'YScale','log');
% grid on;
% legend()
% 
% figure('Units', 'inches', 'Position', [0 0 6 4.82]); hold on;
% for j = 1:3
%     plot(1:11,mean(rr_tot_s(1:97,:,j)),'LineWidth',2)
% end
% set(gca,'YScale','log');
% grid on;
% legend()

rr_r(:,[6],:) = rr_r(:,[4],:);
rr_r_s(:,[6],:) = rr_r_s(:,[4],:);

rr_r_s2(:,1,1:3) = rr_r_s(:,4,1:3);
rr_r_s2(:,2,1:3) = rr_r_s(:,11,1:3);

%% Hour timecourse plotting
j = [1:3];
c = [1 1 1];
var=1;
f1 = figure('Units', 'inches', 'Position', [0 0 6 4.82]); hold on;
for i = [7 11 12]
    base = mean(mean(rr_r(1:2,i,j)),3);
    scatter([0 time(3:16)-lag],-smooth([base; mean(rr_r(3:16,i,j),3)],1),20,'MarkerFaceColor',c*var,'MarkerEdgeColor','k');
end
analyze_NarXL_longTC_controls(rr_r);close(f1);

%% Hour timecourse plotting (inducers)
f1 = figure('Units', 'inches', 'Position', [0 0 6 4.82]); hold on;
%i = 1:4 for IPTG; [6:9] for aTc
for i = [1:4]+5
    base = mean(mean(rr_r(1:2,i,j)),3);
    scatter([0 time(3:16)-lag],-smooth([base; mean(rr_r(3:16,i,j),3)],1),20,'MarkerFaceColor',c*var,'MarkerEdgeColor','k');
end
analyze_NarXL_longTC_inducers();close(f1)

%% Short timecourse plotting (inducers)
f1 = figure('Units', 'inches', 'Position', [0 0 6 4.82]); hold on;
%i = 1:4 for IPTG; [6:9] for aTc
for i = [1:4]+5
    base_s = mean(mean(rr_r_s(1:6,i,j)),3);
    scatter([0 time_s(7:1:97)-lag_s],smooth(-[base_s; mean(rr_r_s(7:1:97,i,j),3)],1),20,'MarkerFaceColor',c*var,'MarkerEdgeColor','k');
end
analyze_NarXL_shortTC_inducers(); close(f1);

%% Short timecourse plotting (compare mNG placement)
f1 = figure('Units', 'inches', 'Position', [0 0 6 4.82]); hold on;
for i = [1 2]
    base_s = mean(mean(rr_r_s2(1:6,i,j)),3);
    scatter([0 time_s(7:1:97)-lag_s],smooth(-[base_s; mean(rr_r_s2(7:1:97,i,j),3)],1),20,'MarkerFaceColor',c*var,'MarkerEdgeColor','k');
end
analyze_NarXL_shortTC_mNGplacement(); close(f1);

%% Hour timecourse plotting (C415R)
j = [1:3];
c = [1 1 1];
var=1;
f1 = figure('Units', 'inches', 'Position', [0 0 6 4.82]); hold on;
for i = [7 14]
    base = mean(mean(rr_r(1:2,i,j)),3);
    scatter([0 time(3:16)-lag],-smooth([base; mean(rr_r(3:16,i,j),3)],1),20,'MarkerFaceColor',c*var,'MarkerEdgeColor','k');
end
analyze_NarXL_longTC_C415R(rr_r);close(f1);