%function filtering_eeg(tbl,initials)

trials_of_interest=tbl.trial;

for i=1:length(trials_of_interest)
   
    trial=trials_of_interest(i);
    task=tbl.task(i);
    file_name=append('stk',initials,'trial',num2str(trial),'.mat');
    load(file_name,'EEG_ref') % loading the matrix that was just referenced

     % High passing 5hz;
    [b,a] = butter(4,5/(2500*0.5),'high');
    EEG_filt=filtfilt(b,a,EEG_ref'); %note filtfilt works on columns

    %Low passing 50hz
    [b,a] = butter(4,50/(2500*0.5),'low');
    EEG_filt=filtfilt(b,a,EEG_filt); 
    
    % Notch filtering
    fs=2500;
    harmonic=60;
    wo=(harmonic/(.5*fs));
    bw=wo/35;
    [b,a]=iirnotch(wo,bw);
    EEG_filt=filtfilt(b,a,EEG_filt); % delt
    EEG_filt=EEG_filt'; %switching each electrode back to the row

    save(file_name,'EEG_filt','-append')

end

%%
% eeg_test=EEG_filt(1,:);
% 
% [pxx,f] = pwelch(eeg_test,2500,[],1:100,2500);
% 
% figure; plot(f,pxx)

