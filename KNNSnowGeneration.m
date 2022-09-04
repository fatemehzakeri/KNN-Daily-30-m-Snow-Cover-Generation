function [ResultIndAll,ErrorSTD,ErrorMean]=KNNSnowGeneration(QueryDates,LearningDates,Weights);

% KNN Daily 30 m Snow Cover Generation is composed of a main function named KNNSnowGeneration.mat for ranking learning dates based on their closeness.
% It also provide the average of the similarity metric over the candidates (a scalar),
%and the standard deviation of the similarity metric over the candidates (a scalar)
% KNNSnowGeneration needes two main imports and one otional import.
% 
% The first import in the funtion is a table named QueryDates (needed).
% 
% The columns of the QueryDates is a table composed of:
% the short and long climate temporal-neighborhood of temperature min/max and precipitation,
% shadow,  MOD10A1, MYD10A1
% and the nearest actual Landsat/Sentinel within 30 days. The rows is exch Query Dates. 
% 
% The second import in the funtion is a table named LearningDates (needed).
% 
% The columns of the LearningDates is a table composed of the short and long climate temporal-neighborhood of temperature min/max
% and precipitation, shadow,  MOD10A1, MYD10A1 
% and the actual Landsat/Sentinel for the Learning Dates. The rows is exch  Learning Dates.
% 
% The second import in the funtion is a table named Weights (Optinal).
% 
% The columns of the Weights is a table composed of the weights for: TmaxShortTemporal-neighborhood, 
% TminShortTemporal-neighborhood,PreShortTemporal-neighborhood, 
% TmaxLongTemporal-neighborhood, TminLongTemporal-neighborhood, PreLongTemporal-neighborhood, 
% MOD10A1, MYD10A1, Shadow, Nearest30mSnowMap
%% 
ResultInd=zeros(size(QueryDates,1),size(LearningDates,1)+1);
A=table2array([QueryDates(:,2:end)]);
B=table2array([LearningDates(:,2:end)]);
%%
% If Weights Table is inputed
if exist('Weights','var')
wCloseAggreTmax=Weights.WTmaxShortTemporal-neighborhood;
wCloseAggreTmin=Weights.WTminShortTemporal-neighborhood;
wCloseAggreP=Weights.WPreShortTemporal-neighborhood;
wTmax=Weights.WTmaxLongTemporal-neighborhood;
wTmin=Weights.WTminLongTemporal-neighborhood;
wP=Weights.WPreLongTemporal-neighborhood;
wMODIS=Weights.WMOD10A1;
wMYD=Weights.WMYD10A1;
wShadow=Weights.WShadow;
wClosestLandsat=Weights.WNearest30mSnowMap;
end
% If Weights Table is not inputed
if  ~exist('Weights','var')
    
wCloseAggreTmax=1;
wCloseAggreTmin=1;
wCloseAggreP=1;
wTmax=1;
wTmin=1;
wP=1;
wMODIS=1;
wMYD=1;
wShadow=1;
wClosestLandsat=1;
end
% Makes a weights matrix 
AllW=zeros(size(LearningDates,1),size(LearningDates,2)-1);
AllW(:,166:3:178)=wCloseAggreTmax;
AllW(:,167:3:179)=wCloseAggreTmin;
AllW(:,168:3:180)=wCloseAggreP;
AllW(:,1:3:163)=wTmax;
AllW(:,2:3:164)=wTmin;
AllW(:,3:3:165)=wP;
AllW(:,181)=wMODIS;
AllW(:,182)=wMYD;
AllW(:,183)=wShadow;
AllW(:,184)=wClosestLandsat;

SumWeights=sum(AllW(1,:));
AllW=AllW./SumWeights;
ErrorMean=zeros(size(QueryDates,1),size(LearningDates,1)+1);
ErrorSTD=zeros(size(QueryDates,1),size(LearningDates,1)+1);
% the learning database are ranked based on a criterion that quantifies their distance to a given query date
for i=1:size(A,1)
    A11=A(i,:);
    D=cellfun(@minus, B , repmat(A11, [size(B,1) 1]), 'un', 0);
    A1=D;
    A2=cellfun(@abs,A1,'UniformOutput',false);
    A3=cellfun(@(x) nanmean(x,'all'),A2,'UniformOutput',false);
    A4=[A3{:}];
    A4=reshape(A4,size(A3,1),size(A3,2));
    A4=A4.*AllW;
    A5=sum(A4,2,'omitnan');
    %STD
    A3_1=cellfun(@(x) std(x,0,'all','omitnan'),A2,'UniformOutput',false);
    A4_1=[A3_1{:}];
    A4_1=reshape(A4_1,size(A3_1,1),size(A3_1,2));
    A4_1=A4_1.*AllW;
    A5_1=sum(A4_1,2,'omitnan');
    %
    [B1,I] = sort(A5);
 
    Result1=LearningDates.Dates(I);
   
    ResultInd(i,2:end)=(Result1)';
    ResultInd(i,1)=QueryDates.Dates(i,1);
    
    ErrorMean(i,2:end)=(B1)';
    ErrorMean(i,1)=QueryDates.Dates(i,1);
        ErrorSTD(i,2:end)=(A5_1(I))';
    ErrorSTD(i,1)=QueryDates.Dates(i,1);
end
ResultIndAll=ResultInd;

end