%function filtering_emg(tbl,initials)

trials_of_interest=tbl.trial;

for i=1:length(trials_of_interest)
   
    trial=trials_of_interest(i);
    task=tbl.task(i);
    file_name=append('stk',initials,'trial',num2str(trial),'.mat');
    load(file_name,'EMG') % loading the matrix that was unpacked from EMG
   
    % filtering: Bandpass 4-200 hx because we are interested in 8-48 hz
    [b,a] = butter(4,[4 200]/(2500*0.5),'bandpass');
    %EMG_filt=zeros(size(EMG));
    EMG_filt=filtfilt(b,a,EMG'); %rotating EMG because filtfilt filters down cols
    

    % filtering the harmonic 60 and 120 hz
    fs=2500;
    harmonic=60;
    wo=(harmonic/(.5*fs));
    bw=wo/35;
    [b,a]=iirnotch(wo,bw);
    EMG_filt=filtfilt(b,a,EMG_filt); 
    fs=2500;
    harmonic=120;
    wo=(harmonic/(.5*fs));
    bw=wo/35;
    [b,a]=iirnotch(wo,bw);
    EMG_filt=filtfilt(b,a,EMG_filt); % delt
    EMG_filt=EMG_filt';
    %EMG_filt(2,:)=EMG(2,:); % replacing with raw EOG
    % Saving file to the correct folder
    save(file_name,'EMG_filt','-append')
end
    