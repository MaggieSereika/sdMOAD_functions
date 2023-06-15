%% new reference EEG
% Here, I am observing the electrodes C3 and C4 and referenceing to the
% electrodes that surround

%the electrodes of interest are the index of the electrode names
electrodes_of_interest=[1 5 7 8 9 13 19 22 23 24 27];
electrode_names={'FZ','FC3','C1','C3','C5','CP3','FC4','C2','C4','C6','CP7'};

FZ=1;
FC3=5;
C1=7;
C3=8;
C5=9;
CP3=12;
FC4=19;
C2=22;
C4=23;
C6=24;
CP4=27;
left=[FC3 C1 C5 CP3]; %these are the electrodes we will subtract from C3
right=[FC4 C2 C6 CP4]; %these are the electrodes we will subtract from C4
trials_of_interest=tbl.trial;
for i=1:length(trials_of_interest)
     trial=tbl.trial(i);
     trial_name=append('stk',initials,'trial',num2str(trial),'.mat');
     load(trial_name,'EEG')
% remove baseline
EEG=EEG-mean(EEG,2);
% referencing to the surrounding channels
C3new=EEG(C3,:)-mean(EEG(left,:),1);
C4new=EEG(C4,:)-mean(EEG(right,:),1);

%creating this EEG_ref matrix to save the electordes of interest for
%plotting
EEG_ref=EEG;
% replacing C3 and C4 witht the C3new and C4new which are the rereferenced
EEG_ref(8,:)=C3new;
EEG_ref(23,:)=C4new;

save(trial_name,'EEG_ref','-append')
end
