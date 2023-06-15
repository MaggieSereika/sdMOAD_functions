epoch_tasks={'sabd_pre','sabd_post','ef_pre','ef_post','syn_pre','syn_post'};

%for i=1:length(epoch_tasks)
i=6;
fs=2500;
epoch_tasks{i}
    whole_name=append('stk',initials,'.mat');
    load(whole_name,epoch_tasks{i})
    epoch_mat=eval(epoch_tasks{i});
    epoch_mat=epoch_mat(:,:,[1,2]);
    
    num_trials=size(epoch_mat,2);
    amt4=floor(num_trials/4);
    remainder=rem(num_trials,4);
    to_add=4-remainder;
    if remainder>0
        added_mat=zeros([fs to_add 2]); % adding zeros matrices to make even
        epoch_mat=horzcat(epoch_mat,added_mat);
    end
    %%
    trial=0;
    for i=1:amt4
        figure
        for j=1:4
        trial=trial+1;
        time=1:2500;
        subplot(4,1,j)
        C3=epoch_mat(:,trial,1);
        C4=epoch_mat(:,trial,2)+10;
        plot(time,C3); hold on;plot(time,C4)
        title(num2str(trial))
       
        end
    end
%end