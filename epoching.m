%% Maggie Sereika Wed, April 12th 2023
% this script opens all trial data for a participant and creates 1 second
% epochs of 2500 points each. Lesional, contralesional, emg (either biceps
% or deltoid) will be divided by task

trials_of_interest=tbl.trial
fs=2500;
% all tasks we are hoping to analyze, empty matrix to be filled
%sabdmax_pre=[];
% efmax_pre=[];
% ffmax_pre=[];
% sabdmax_post=[];
% efmax_post=[];
% sabd40_pre=[];
% sabd40_post=[];
% sabd10_pre=[];
% sabd10_post=[];
% ef_synpre_pre=[];
% ef_synpre_post=[];
% ff_synpre_pre=[];
% ff_synpre_post=[];
% ef_synpost_post=[];
% ff_synpost_post=[];
sabd_pre=[];
sabd_post=[];
ef_pre=[];
ef_post=[];
syn_pre=[];
syn_post=[];

for i=1:length(trials_of_interest) %looping through each trial to unpack and put in the respective matrice
    % trial information
    task=tbl.task(i);
    trial=tbl.trial(i);
    time=tbl.time(i);
    % loading file
    file_name=append('stk',initials,'trial',num2str(trial),'.mat');
    % loading EEG, EMG, and labels for electrodes of choice
    load(file_name,'EEG_filt','EMG_filt')
    
    c3=8; %C3new in EEG_ref
    c4=23; %C4new in EEG_ref
    idl=1; % first row in the emg
    bic=2; %second row in the emg
    
    num_windows=floor(length(EEG_filt(c3,:))/fs); %cutting off the windows at a number divisible by 2500
    amt_time=fs*num_windows;
    %reshaping into the size of epochs
    C3=reshape(EEG_filt(c3,1:amt_time),[fs num_windows]); 
    C4=reshape(EEG_filt(c4,1:amt_time),[fs num_windows]);
    IDL=reshape(EMG_filt(idl,1:amt_time),[fs num_windows]);
    BIC=reshape(EMG_filt(bic,1:amt_time),[fs num_windows]);
    % concatenating the electrodes for this trial
    trial_mat_cat=cat(3,C3,C4,IDL,BIC);
    
    %concatenating each trial onto the matrix of specific task
    if task=="SABD" & (time=="pre") 
        sabd_pre=cat(2,sabd_pre,trial_mat_cat);
    elseif task=="SABD" & (time=="post") 
        sabd_post=cat(2,sabd_post,trial_mat_cat);
    elseif task=="EF" & (time=="pre") 
        ef_pre=cat(2,ef_pre,trial_mat_cat);
    elseif task=="EF" & (time=="post") 
        ef_post=cat(2,ef_post,trial_mat_cat);
    elseif task=="syn" & (time=="pre") 
        syn_pre=cat(2,syn_pre,trial_mat_cat);
    elseif task=="syn" & (time=="post") 
        syn_post=cat(2,syn_post,trial_mat_cat);
   
    end
end


whole_file_name=append('stk',initials,'.mat');
%%
 save(whole_file_name,'sabd_pre','sabd_post','ef_pre','ef_post','syn_pre','syn_post')


