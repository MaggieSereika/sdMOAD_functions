epoch_tasks={'sabd_pre','sabd_post','ef_pre','ef_post'};


% alpha and beta with fwcoh
alpha=(fw>=8) & (fw<12);
alpha_num=length(find(alpha))*2500;
beta=(fw>=12) & (fw<=45);
beta_num=length(find(beta))*2500;
% forloop
%for i=1:13
%load(file_name)

% Load the wcoh file

%decide which lesion and contralesion
%what side is the lesion, and which electrode is that?

%emptying out vectors to concatenate

pre_cl_bic_a=[];
pre_cl_idl_a=[];


pre_cl_bic_b=[];
pre_cl_idl_b=[];


pre_l_bic_a=[];
pre_l_idl_a=[];


pre_l_bic_b=[];
pre_l_idl_b=[];


post_cl_bic_a=[];
post_cl_idl_a=[];


post_cl_bic_b=[];
post_cl_idl_b=[];


post_l_bic_a=[];
post_l_idl_a=[];


post_l_bic_b=[];
post_l_idl_b=[];

for i=1:length(epoch_tasks)
    file_name=append('wcoh_',epoch_tasks{i},'.mat');
    load(file_name)
    
PRE = ~contains(file_name,'post'); % name that does not contain post... is pre!
    if contains(file_name,'sabd')
        task='sabd';
    % elseif contains(file_name,'syn')
    %     task='syn';
    elseif contains(file_name,'ef')
        task='ef';
    
    end
    task
    % significance: those greater than the threshold can stay. Those less
    % are pushed to zero.
    alp=0.05;
    sig_thresh=1-alp^(1/(trial_num-1)); %significance threshold
    C3_wcoh(C3_wcoh<sig_thresh)=0;
    C4_wcoh(C4_wcoh<sig_thresh)=0;
    
    if lesion=='l'
        L=eval('C3_wcoh');
        CL=eval('C4_wcoh');
    elseif lesion=='r'
        L=eval('C4_wcoh');
        CL=eval('C3_wcoh');
    end
    
    
    % contralesion and lesion alpha and beta sums across time and frequency
    % band
    CL_alpha_sum=sum(sum(CL(alpha,:,:),1),2); 
    L_alpha_sum=sum(sum(L(alpha,:,:),1),2);
    
    CL_beta_sum=sum(sum(CL(beta,:,:),1),2);
    L_beta_sum=sum(sum(L(beta,:,:),1),2);
    
    % divide into muscle groups
     CL_IDL_a=CL_alpha_sum(1)/alpha_num;
    L_IDL_a=L_alpha_sum(1)/alpha_num;
    CL_IDL_b=CL_beta_sum(1)/beta_num;
    L_IDL_b=L_beta_sum(1)/beta_num;
    
    CL_BIC_a=CL_alpha_sum(2)/alpha_num;
    L_BIC_a=L_alpha_sum(2)/alpha_num;
    CL_BIC_b=CL_beta_sum(2)/beta_num;
    L_BIC_b=L_beta_sum(2)/beta_num;
    
    % add to speadsheet
    
    if PRE
        pre_cl_idl_a=[pre_cl_idl_a;CL_IDL_a];
        pre_cl_bic_a=[pre_cl_bic_a;CL_BIC_a];
        
    
        pre_cl_idl_b=[pre_cl_idl_b;CL_IDL_b];
        pre_cl_bic_b=[pre_cl_bic_b;CL_BIC_b];
        
    
        pre_l_idl_a=[pre_l_idl_a;L_IDL_a];
        pre_l_bic_a=[pre_l_bic_a;L_BIC_a];
        
    
        pre_l_idl_b=[pre_l_idl_b;L_IDL_b];
        pre_l_bic_b=[pre_l_bic_b;L_BIC_b];
        
    else
        post_cl_idl_a=[post_cl_idl_a;CL_IDL_a];
        post_cl_bic_a=[post_cl_bic_a;CL_BIC_a];
        
    
        post_cl_idl_b=[post_cl_idl_b;CL_IDL_b];
        post_cl_bic_b=[post_cl_bic_b;CL_BIC_b];
        
    
        post_l_idl_a=[post_l_idl_a;L_IDL_a];
        post_l_bic_a=[post_l_bic_a;L_BIC_a];
        
    
        post_l_idl_b=[post_l_idl_b;L_IDL_b];
        post_l_bic_b=[post_l_bic_b;L_BIC_b];
        
    end

end
%% Generate table Alpha
tasks={'sabd';'ef'};

filename='stkRP_alpha.xlsx'
tbla=table(tasks,pre_cl_idl_a,post_cl_idl_a,pre_l_idl_a,post_l_idl_a,...
    pre_cl_bic_a,post_cl_bic_a,pre_l_bic_a,post_l_bic_a);
   
writetable(tbla,filename)
%% Generate table beta
tasks={'sabd';'ef'};
filename='stkRP_beta.xlsx'
tblb=table(tasks,pre_cl_idl_b,post_cl_idl_b,pre_l_idl_b,post_l_idl_b,...
    pre_cl_bic_b,post_cl_bic_b,pre_l_bic_b,post_l_bic_b);
   
writetable(tblb,filename)
%% Alpha Plots 

% SABD 
x=categorical({'Contralesional-IDL','Lesional-IDL'});
y=[pre_cl_idl_a(1),post_cl_idl_a(1);pre_l_idl_a(1),post_l_idl_a(1)];
figure
bar(x,y)
title('Linear WCoherence Alpha Band During SABD Hold','FontSize',15)
legend('Pre','Post')

% EF - synergy
x=categorical({'Contralesional-IDL','Lesional-IDL'});
y=[pre_cl_bic_a(1),post_cl_bic_a(1);pre_l_bic_a(1),post_l_bic_a(1)];
figure
bar(x,y)
title('Synergy Linear WCoherence EF Alpha Band During SABD Hold','FontSize',15)
legend('Pre','Post')

% EF - volitional
x=categorical({'Contralesional-IDL','Lesional-IDL'});
y=[pre_cl_bic_a(2),post_cl_bic_a(2);pre_l_bic_a(2),post_l_bic_a(2)];
figure
bar(x,y)
title('Volitional Linear WCoherence Alpha Band During EF Hold','FontSize',15)
legend('Pre','Post')

%% Beta Plots 

% SABD 
x=categorical({'Contralesional-IDL','Lesional-IDL'});
y=[pre_cl_idl_b(1),post_cl_idl_b(1);pre_l_idl_b(1),post_l_idl_b(1)];
figure
bar(x,y)
title('Linear WCoherence Beta Band During SABD Hold','FontSize',15)
legend('Pre','Post')

% EF - synergy
x=categorical({'Contralesional-IDL','Lesional-IDL'});
y=[pre_cl_bic_b(1),post_cl_bic_b(1);pre_l_bic_b(1),post_l_bic_b(1)];
figure
bar(x,y)
title('Synergy Linear WCoherence EF Beta Band During SABD Hold','FontSize',15)
legend('Pre','Post')

% EF - volitional
x=categorical({'Contralesional-IDL','Lesional-IDL'});
y=[pre_cl_bic_b(2),post_cl_bic_b(2);pre_l_bic_b(2),post_l_bic_b(2)];
figure
bar(x,y)
title('Volitional Linear WCoherence Beta Band During EF Hold','FontSize',15)
legend('Pre','Post')