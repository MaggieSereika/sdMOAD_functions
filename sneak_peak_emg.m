% function sneak_peak

% which trials do you want to sneak peak
%randomize the EEG
random_trials=randi(length(tbl.trial),[1 3]);
%left=c3,fc3,c5,cp3,c1
%right=c4,fc4,c6,cp4,c1
electrodes_of_interest=[32,33,34,35];
electrode_names={'FCR','TRI','BIC','IDL'};
fs=2500;

for i=(random_trials)
     trial=tbl.trial(i);
     trial_name=append('stk',initials,'trial',num2str(trial),'.mat');
     load(trial_name,'EMG')
     figure
    for j=1:length(electrodes_of_interest)
       subplot(length(electrodes_of_interest),2,2*j-1)
       plot(EMG(j,:))
       if j==1
           title(append('EMG Raw',num2str(trial)))
       end
       ylabel(electrode_names{j})
       

       subplot(length(electrodes_of_interest),2,2*j)
       [pc3,f] = pwelch(EEG(j,:),fs,0,1:100,fs);
       plot(f,pc3)
       if j==1
           title(append('EMG PSD',num2str(trial)))
       end
       
    end
end