% function sneak_peak

% which trials do you want to sneak peak
%randomize the EEG
random_trials=tbl.trial(34);
%left=c3,fc3,c5,cp3,c1
%right=c4,fc4,c6,cp4,c1

 electrodes_of_interest=[1 5 7 8 9 13 19 22 23 24 27];
 electrode_names={'FZ','FC3','C1','C3','C5','CP3','FC4','C2','C4','C6','CP4'};

% electrodes_of_interest=[8 23];
%electrode_names={'C3' ,'FC3'};
fs=2500;
  % 'no' for not raw. 'referenced' for EEG_ref, 'filtered' for eeg_filt
what_to_observe={'no','referenced','filtered'};
for k=1:length(what_to_observe)
 preprocess=what_to_observe(k);
    for i=1:length(random_trials)
        %trial=80;   %tbl.trial(i);
        trial=random_trials(i);
         trial_name=append('stk',initials,'trial',num2str(trial),'.mat');
        if preprocess=="no"
            load(trial_name,'EEG');
            eeg=EEG(electrodes_of_interest,:);
        elseif preprocess=="referenced"
            load(trial_name,'EEG_ref');
            eeg=EEG_ref(electrodes_of_interest,:);
        elseif preprocess=="filtered"
        load(trial_name,'EEG_filt');
        eeg=EEG_filt;
        end
         %time=(1:size(eeg,2))/fs;
         time=1:2500;
         eeg=eeg(:,1:(2500));
         figure
        for j=1:length(electrodes_of_interest)
           subplot(12,1,j)
           plot(time,eeg(j,:))
           if j==1
               title(append('EEG ',num2str(trial),' preprocessed=',preprocess))%' high/low/notch filtered'),'FontSize',18)
           end
           ylabel(electrode_names{j},'FontSize',14)
           ylim([-50 50])
           xlabel('Time (S','FontSize',7)
           
        end
        subplot(12,1,12)
           [pc3,f] = pwelch(eeg(4,:),fs,0,1:100,fs);
           [pc4,f] = pwelch(eeg(9,:),fs,0,1:100,fs); 
           plot(f,pc3,f,pc4,'LineWidth',1.3)
           legend('C3','C4')
           title('PSD Plot')
           xlabel('Frequency Hz')
    end


end
