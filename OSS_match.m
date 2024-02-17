function [solution,rmse,cor1,cor2]= OSS_match(des1,loc1,des2,loc2,change_form)

%% Improved NNDR matching
distRatio =1;
Nmax=300;
[cor11_low,cor22_low,cor11_up,cor22_up]= Improved_NNDR_match(des1,loc1,des2,loc2,distRatio,Nmax);

%% Remove duplicate points
uni1=[cor11_low(:,[1 2]),cor22_low(:,[1 2])];
[~,i,~]=unique(uni1,'rows','first');
cor11_low=cor11_low(sort(i)',1:2);
cor22_low=cor22_low(sort(i)',1:2);

%% FSC
fprintf('Before FSC low found %d matches.\n', size(cor11_low,1));
fprintf('Before FSC  up found %d matches.\n', size(cor11_up,1));
[solution,rmse,cor1,cor2]=FSC2(cor11_low,cor22_low,cor11_up,cor22_up,change_form,3*2^0.5);
% [solution,rmse,cor1,cor2]=FSC(cor1,cor2,'perspective',3*2^0.5);
fprintf('After FSC found %d matches.\n', size(cor1,1));

end


function [cor11_low,cor22_low,cor11_up,cor22_up]= Improved_NNDR_match(des1,loc1,des2,loc2,distRatio,N)

tratios=zeros(size(des1,1),1);
tindxs=zeros(size(des1,1),1);

for i = 1 : size(des1,1)
    dotprods = des1(i,:) * des2';
    [vals,indx] = sort(acos(dotprods));
    tratios(i)=vals(1)/vals(2);
    tindxs(i)=indx(1);
end

[~,indx1] = sort(tratios);
tmatch1=zeros(1,size(des1,1));
if length(indx1)<N
    tmatch1(indx1(1:end)) = tindxs(indx1(1:end));
else
    tmatch1(indx1(1:N)) = tindxs(indx1(1:N));
end

indx2=find(tratios<distRatio);
tmatch2=zeros(1,size(des1,1));
tmatch2(indx2)=tindxs(indx2);

[~,point1_low,point2_low]=find(tmatch1);
[~,point1_up,point2_up]=find(tmatch2);

cor11_low=loc1(point1_low,1:2);
cor22_low=loc2(point2_low,1:2);

[~,i,~]=unique(cor11_low,'rows','first');
cor11_low=cor11_low(sort(i)',1:2);
cor22_low=cor22_low(sort(i)',1:2);
[~,i,~]=unique(cor22_low,'rows','first');
cor11_low=cor11_low(sort(i)',1:2);
cor22_low=cor22_low(sort(i)',1:2);

cor11_up=loc1(point1_up,1:2);
cor22_up=loc2(point2_up,1:2);
end









