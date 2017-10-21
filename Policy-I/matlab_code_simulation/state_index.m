function s_index=state_index(s,type)
ref_state_matrix=[1 2 3;1 3 2;3 2 1;3 1 2;2 3 1;2 1 3];

for i=1:size(ref_state_matrix,1)
    if s==ref_state_matrix(i,:);
        s_index=i;
        break
    end
end
if type==1 %subhealth state
    s_index=s_index+3;
end
end