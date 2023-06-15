%% plot_wcoh_synergy
% in this script I am retrieving the synergy induced coherence and the
% volitional coherence matched to the pre

% add to see what type of plot you want
cortex="Lesional"
muscle="fcr"


%function plot_wcoh(cortex,muscle)

%what side is the lesion, and which electrode is that?
if lesion=='l'
    L='C3';
    CL='C4';
elseif lesion=='r'
    L='C4';
    CL='C3';
end
% did the command want to look at lesional or contralesional?
if cortex=="Lesional"
    eeg=L;
elseif cortex=="Contralesional"
    eeg=CL;
end

% Which muscle?
if muscle=='idl'
    mus=3;
    comp='wcoh_sabd10_';
    task='SABD';
elseif muscle=='bic';
    mus=2;
    comp='wcoh_ef_synpre_';
    task='EF';
elseif muscle=='fcr';
    mus=1;
    comp='wcoh_ff_synpre_';
    task='FF';
end
eeg
mus
time=(1:2500)/2500; %plotting on 
figure
alpha=0.05;
%% pre sabd 40
%loading
load("wcoh_sabd40_pre.mat")
mat_name=append(eeg,'_wcoh')
mat=eval(mat_name);
wcoh40pre=mat(:,:,mus);
% significance
sig_thresh=1-alpha^(1/(trial_num-1));
wcoh40pre(wcoh40pre<sig_thresh)=0;
subplot(2,2,1)
% plotting
imagesc(time,fw,wcoh40pre,[0 .15])
colorbar
set(gca,'YDir','normal','YScale', 'log')
title([cortex,' Synergy Induced ',task, ' pre'])
xlabel('Time (s)')
ylabel('Frequencies (Hz)')

%% pre muscle of choice
%loading
muscle_of_choice=append(comp,'pre.mat')
load(muscle_of_choice)
mat_name=append(eeg,'_wcoh')
mat=eval(mat_name);
wcohmuspre=mat(:,:,mus);
%significance
sig_thresh=1-alpha^(1/(trial_num-1));
wcohmuspre(wcohmuspre<sig_thresh)=0;
subplot(2,2,2)
% plotting
imagesc(time,fw,wcohmuspre,[0 .15]) 
colorbar
set(gca,'YDir','normal','YScale', 'log')
title([cortex,' voluntary ',task, ' pre'])
xlabel('Time (s)')
ylabel('Frequencies (Hz)')

 %% post sabd 40
%loading
load("wcoh_sabd40_post.mat")
mat_name=append(eeg,'_wcoh')
mat=eval(mat_name);
wcoh40post=mat(:,:,mus);
%significance
sig_thresh=1-alpha^(1/(trial_num-1));
wcoh40post(wcoh40post<sig_thresh)=0;
%plotting
subplot(2,2,3)
imagesc(time,fw,wcoh40post,[0 .15])
colorbar
set(gca,'YDir','normal','YScale', 'log')
title([cortex,' Synergy ',task,' post'])
xlabel('Time (s)')
ylabel('Frequencies (Hz)')

%% loading post muscle of choice
%loading
muscle_of_choice=append(comp,'post.mat')
load(muscle_of_choice);
mat_name=append(eeg,'_wcoh')
mat=eval(mat_name);
wcohmuspost=mat(:,:,mus);
% significance
sig_thresh=1-alpha^(1/(trial_num-1));
wcohmuspost(wcohmuspost<sig_thresh)=0;
% plotting
subplot(2,2,4)
imagesc(time,fw,wcohmuspost,[0 .15])
colorbar
set(gca,'YDir','normal','YScale', 'log')
title([cortex,' voluntary ',task,' post'])
xlabel('Time (s)')
ylabel('Frequencies (Hz)')
%end

%% PLotting Change in coherence as well
% here I want to take post minus pre to see the change in coherence value
synergy_diff=wcoh40post-wcoh40pre; % this is the synergy
volitional_diff=wcohmuspost-wcohmuspre; % this is volitional

figure

subplot(1,2,1)
imagesc(time,fw,synergy_diff,[-.13 .13])
colorbar
set(gca,'YDir','normal','YScale', 'log')
if muscle=="idl"
    title([cortex,'SABD 40%' ,'difference between post-pre'],'FontSize',20)
else
    title([cortex,' Synergy ',task,' difference between post-pre'],'FontSize',20)
end
xlabel('Time (s)','FontSize',15)
ylabel('Frequencies (Hz)','FontSize',15)

subplot(1,2,2)
imagesc(time,fw,volitional_diff,[-.13 .13])
colorbar
set(gca,'YDir','normal','YScale', 'log')
if muscle=="idl"
    title([cortex,'SABD 10%',' difference between post-pre'],'FontSize',20)
else
    title([cortex,' volitional ',task,' difference between post-pre'],'FontSize',20)
end
xlabel('Time (s)','FontSize',15)
ylabel('Frequencies (Hz)','FontSize',15)
