% plotting trials to eliminate epochs

trials_of_interest=tbl.trial;
electrodes_of_interest=[1 5 7 8 9 13 19 22 23 24 27];
electrode_names={'FZ','FC3','C1','C3','C5','CP3','FC4','C2','C4','C6','CP4'};
fs=2500;
for i=1:length(trials_of_interest)
     trial=trials_of_interest(i);   %tbl.trial(i);
     trial_name=append('stk',initials,'trial',num2str(trial),'.mat');
     load(trial_name,'EEG_filt');
     time=(1:size(EEG_filt,2))/fs;
     figure
    for j=1:length(electrodes_of_interest)
       subplot(length(electrodes_of_interest),1,j)
       plot(time,EEG_filt(j,:))
       if j==1
           title(append('EEG ',num2str(trial)),'FontSize',18)
       end
       ylabel(electrode_names{j},'FontSize',16)
       ylim([-20 20])
       xlabel('Time (S')
    end
 end