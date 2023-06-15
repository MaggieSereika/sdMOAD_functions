%remove_epochs
%r_ef_synpost_post=[75 76 91 117]

r_sabd_pre=[24,48];
r_sabd_post=[4,16,39,40];
r_ef_pre=[54,60];
r_ef_post=[1,19,21,58];
r_syn_pre=[];
r_syn_post=[];

epoch_tasks={'sabd_pre','sabd_post','ef_pre','ef_post','syn_pre','syn_post'};
    
for i=1:length(epoch_tasks)
    whole_name=append('stk',initials,'.mat');
    data_name=append('data_',whole_name);
    task=epoch_tasks{i};
    load(whole_name,task)
    matrix=eval(task);
    remove_name=append('r_',task);
    remove=eval(remove_name);
    matrix(:,remove,:)=[];
    matrix=matrix(:,:,1:4);
    
    if task=="sabd_pre"
        sabd_pre=matrix;
        save(data_name,'sabd_pre')
    elseif task=="sabd_post"
        sabd_post=matrix;
        save(data_name,'sabd_post','-append')
    elseif task=="ef_pre"
        ef_pre=matrix;
        save(data_name,'ef_pre','-append')
    elseif task=="ef_post"
        ef_post=matrix;
        save(data_name,'ef_post','-append')
    elseif task=="syn_pre"
        syn_pre=matrix;
        save(data_name,'syn_pre','-append')
    elseif task=="syn_post"
        syn_post=matrix;
        save(data_name,'syn_post','-append')
    
    end
end