% unpacking the 14 tasks
epoch_tasks={'sabd_pre','sabd_post','ef_pre','ef_post','syn_pre','syn_post'};

%this is the correct order in each epoch matrice
c3=1; 
c4=2; 
idl=3; 
bic=4; 
fs=2500;

for i=1:6 %looping through each of the 14 tasks described above

task=epoch_tasks{i}
load(append('data_stk',initials,'.mat'),task)
matrix=eval(task);
trial_num=size(matrix,2); %number ofwindows in this epoch

for j=[c3 c4] % looping through both sides of the cortex
    cortex_wcoh=[]; %creating an empty matrix for both C3 and C4
    for k=[idl bic] %looping through each muslce to compute coherence between cortex&muscle
        cortex=matrix(:,:,j); %either C3 or C4
        muscle=matrix(:,:,k); %either  idl bic
        coh=0; % zeroing out a vector that we will add to to sum up coherence
        for window=1:trial_num %This will loop through all the windows
            [wcoh,wcs,fw]=wcoherence(cortex(:,window),muscle(:,window),fs); %computing corticomuscular coherence for each window
            coh=coh+wcs; % computing coherence and adding each next window iteration
        end
        wcoh_lin=abs(coh/trial_num); %dividing by the number of tialso to average out and taking the absolute value to only get real values
        cortex_wcoh=cat(3,cortex_wcoh,wcoh_lin); %concatenating every new matrix that represents a muscle
    end
    % renaming the concatenated matrix based off of the side of cortex we
    % are computing
    if j==c3 
        C3_wcoh=cortex_wcoh; %wcoherence between C3 and [IDL;BIC]
    elseif j==c4
        C4_wcoh=cortex_wcoh; %wcoherence between C4 and [IDL;BIC]
    end
end
file_name=append('wcoh_',task)
save(file_name,"C3_wcoh","C4_wcoh","trial_num","fw"); %saving new file to represent coherence
end
