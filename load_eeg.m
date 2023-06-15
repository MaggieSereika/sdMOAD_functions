%function load_eeg(tbl,hold_tbl,initials)
% 
trials_of_interest=tbl.trial;
% direcotries of data location, fieldtrip, and data storage
%brainvision
dir1 = append('/Users/mas8128/Library/CloudStorage/OneDrive-NorthwesternUniversity/STK/data and matlab/stk',initials,'/brainvision_eeg');

dir2=append('/Users/mas8128/Library/CloudStorage/OneDrive-NorthwesternUniversity/STK/fieldtrip-lite-20221022');
%function where I am saving stuff to
dir3=append('/Users/mas8128/Library/CloudStorage/OneDrive-NorthwesternUniversity/STK/data and matlab/stk',initials,'/maggie_eeg/analysis_may');
% adding fieldtrip to the dirctory
addpath(genpath(dir2))

for i=1:length(trials_of_interest)
cd(dir1)
trial=trials_of_interest(i)
%adjusting zeros in naming convention
if trial<10
    number=append('_00000',num2str(trial));
elseif (10<=trial)&(trial<100)
    number=append('_0000',num2str(trial));
elseif trial>=100
    number=append('_000',num2str(trial));
end

eeg_file_name=append('stk',initials,number,'.eeg');
vmrk_file_name=append('stk',initials,number,'.vmrk');
vhdr_file_name=append('stk',initials,number,'.vhdr');
% finding the begining, end of the hold
tbl_row=find(hold_tbl.trials==trial);
hold_1_start_time=hold_tbl.hold_1_start(tbl_row);
hold_1_end_time=hold_tbl.hold_1_end(tbl_row);

%cfg.headerformat   = vhdr_file_name; %string, see FT_FILETYPE (default is automatic)]
% electrodes of interest= c3 and c4

cfg=[];
% please use ft_read_event(vmrk file) to fine which trigger is lagging
% trigger
cfg.trialdef.eventtype = 'Response'; % Set this to questionmark
cfg.trialdef.eventvalue= 'R 15'; %here I am setting the trigger to look at. Rising edge
%May 25,2023. I just changed this to the lagging edge.. I was confused with 7
%and 15.
cfg.headerfile= vhdr_file_name;
cfg.datafile = eeg_file_name; %string, see FT_FILETYPE (default is automatic)
cfg.trialdef.prestim    = -hold_1_start_time; %amount of time before the trigger to start recordeing. This is negative.
 cfg.trialdef.poststim   = hold_1_end_time; %amount of time after the trigger to stop recording.
% % defining the trial
cfg=ft_definetrial(cfg); %This function lines to TTl and to the segment of data (The holds) I want
% % ready to preprocess
 cfg.channel='all'; %these are the electrode channels
 cfg.demean  = 'no' ;%whether to apply baseline correction (default = 'no')
 cfg.reref         = 'no' ;%(default = 'no')
% %cfg.refchannel    =  'all'; %for a common average reference
% % fieldtrip
 [eegemg] = ft_preprocessing(cfg);
 cd(dir3)
% % Re-saving our data as a matrix into trials regards to their trials
 mat_file=append('stk',initials,'trial',num2str(trial));
EEGEMG=eegemg.trial{:,:};
EEG=EEGEMG(1:31,:); %all scalp electrodes
EMG=EEGEMG(32:end,:); %all muscle electrodes
save(mat_file,'EEG','EMG')
end
