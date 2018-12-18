clc
clear all
format long
TP=0;
FN=0;
TN=0;
FP=0;
recall=0;
[num,txt,raw1]=xlsread('151');%��ȡѵ������
[num,txt,raw2]=xlsread('152');
raw=[raw1;raw2];
%raw=raw1;
train_label=raw(:,end);
%raw(:,end)=[];
train_data=raw;

clear raw1 raw2
[num,txt,raw9]=xlsread('153');%��ȡ��������
raw13=raw9;
test_label=raw13(:,end);
for index=1:numel(test_label)
    test_label{index}=num2str(test_label{index});
end

%raw13(:,end)=[];
test_data=raw13;
for index=1:numel(train_label)
    if ischar(train_label{index})~=1
        train_label{index}=num2str(train_label{index});
    end
end
for index=1:size(train_data,1)
    for index1=1:size(train_data,2)
        if ischar(train_data{index,index1})~=1
            train_data{index,index1}=num2str(train_data{index,index1});
        end
    end
end
for index=1:size(test_data,1)
    for index1=1:size(test_data,2)
        if ischar(test_data{index,index1})~=1
            test_data{index,index1}=num2str(test_data{index,index1});
        end
    end
end
% train_data=cell2table(train_data,'VariableNames', {'gender','changeornot','operationmode','eyecode','age','area','density','covercentral','a','b','c','d'});
% test_data=cell2table(test_data,'VariableNames', {'gender','changeornot','operationmode','eyecode','age','area','density','covercentral','a','b','c','d'});
% 
% Factor = TreeBagger(1000, train_data, train_label);
% [Predict_label,Scores] = predict(Factor, test_data);
%��ʼ���ر�Ҷ˹����
classvariable={'1','2'};
%ͳ�����Ժ�����ǩ֮��Ĺ�ϵ
variablenumber=size(train_data,2);%���Եĸ���
stastistics={};
%����ÿһ�����Ե�ȡֵ
values={{'Ů' '��'} {'��' '��'} {'I/A' 'I/A+PCCC' 'I/A+PCCC+ANTI+VIT'} {'��' '˫'} {'1' '2' '3' '4' '5' '6' '7'} {'��' 'С'} {'��' 'ǳ'} {'��' '��'} {'��' '��'} {'��' '��'} {'��' '��'} {'��' '��'}};
for index1=1:variablenumber-1%���Ը���
%     temp=train_data(:,index1);%���ܴ������л�ȡ�������Ե�ȡֵ����
%     value=unique(temp);
%     values{index1}=value;
    value=values{index1};
    stas=zeros(numel(value),2);
    for index4=1:size(train_data,1)
          for index2=1:numel(value)%���Ե�ȡֵ����
                %ͳ�����
                if isequal(train_data{index4,index1},value{index2})==1
                    if isequal(train_data{index4,end},'1')==1
                        stas(index2,1)=stas(index2,1)+1;
                    else
                        stas(index2,2)=stas(index2,2)+1;
                    end
                end
          end
    end
    %������˹ƽ������ֹ0�ĳ���
    stas=stas+1;
    stastistics{index1}=stas;
end
sumnumber=zeros(1,2);

%ͳ������ĸ����ֱ�Ϊ����
for index=1:size(train_data,1)
   if isequal(train_data{index,end},'1')==1
       sumnumber(1)= sumnumber(1)+1;
   else
       sumnumber(2)= sumnumber(2)+1;
   end
end
%��ʼ����
probobality=[];%�洢�������

for index1=1:size(test_data,1)
    %�����һ,����ĸ���
    sumprobobality1=sumnumber(1)/sum(sumnumber);
    partprobobality1=[];%�洢ÿ�����Եķָ���
    sumprobobality2=sumnumber(2)/sum(sumnumber);
    partprobobality2=[];%�洢ÿ�����Եķָ���
    for index2=1:variablenumber-1
        tempvalue=values{index2};%��index2�����Ե�ȡֵ����
        tempstas=stastistics{index2};
        for index3=1:numel(tempvalue)
            if isequal(test_data{index1,index2},tempvalue{index3})==1
                partprobobality1(index2)=tempstas(index3,1)/(sumnumber(1)+1);
                partprobobality2(index2)=tempstas(index3,2)/(sumnumber(2)+1);
            end
        end
    end
    probobality(index1,1)=prod(partprobobality1)* sumprobobality1;
    probobality(index1,2)=prod(partprobobality2)* sumprobobality2;
end

Predict_label={};
for index=1:size(test_data,1)
    [c,i]=max(probobality(index,:));
    Predict_label{index}=num2str(i);
end

Predict_label=Predict_label';

correct=0;
for index=1:numel(test_label)
    if isequal(test_label{index},Predict_label{index})==1
        correct=correct+1;
    end
end
accuracy=correct/numel(test_label);

test_label=cell2mat(test_label);
test_label=str2num(test_label);

number1=numel(find(test_label==1));%����������
number2=numel(test_label)-number1;
predict_label=cell2mat(Predict_label);
predict_label=str2num(predict_label);
for index1=1:number1+number2
    if predict_label(index1)==1 & test_label(index1)==1
        TP=TP+1;
    end
    if predict_label(index1)==2 & test_label(index1)==2
         TN=TN+1;
     end
end

% for index1=1:number2
%     if predict_label(index1+number1)==2 & test_label(index1+number1)==2
%         TN=TN+1;
%     end
% end
FP=number2-TN;
        P=number1;
        N=number2;
FN=number1-TP;
Accuracy=(TP+TN)/(P+N);
Sensitivity=TP/P;
FNR=1-Sensitivity;
Specificity=TN/N;
FPR=1-Specificity;
recall= 1 - FN/P;
ROC=[];%��ROC���ߵĴ洢����
PR=[];%��PR���ߵĴ洢����
largevalues=[];
%�������
for index=1:size(probobality,1)
    probobality(index,:)=probobality(index,:)/sum(probobality(index,:));
end
largevalues=probobality(:,1);%���������ĸ���
templabel=[];


    %��Ͼ���
    comprehensivearray=[test_label largevalues];
    
     %����
    for index4=1:size(comprehensivearray,1)
        for index5=index4+1:size(comprehensivearray,1)
            if comprehensivearray(index4,2)<comprehensivearray(index5,2)
                %����
                temp=comprehensivearray(index4,:);
                comprehensivearray(index4,:)=comprehensivearray(index5,:);
                comprehensivearray(index5,:)=temp;
            end
        end
    end
   for index=1:size(comprehensivearray,1)
    benchmark=comprehensivearray(index,2);
    for index1=1:size(comprehensivearray,1)
        if comprehensivearray(index1,2)>=benchmark
           comprehensivearray(index1,3)=1;
        else
           comprehensivearray(index1,3)=2;
        end
    end

        FP1=0;
        TP1=0;
        FN1=0;
        for index2=1:size(comprehensivearray,1)
            if comprehensivearray(index2,1)==2 & comprehensivearray(index2,3)==1
                FP1=FP1+1;
            end
        end
        for index3=1:size(comprehensivearray,1)
            if comprehensivearray(index3,1)==1 & comprehensivearray(index3,3)==1
                TP1=TP1+1;
            end
        end
         for index3=1:size(comprehensivearray,1)
            if comprehensivearray(index3,1)==1 & comprehensivearray(index3,3)==2
                FN1=FN1+1;
            end
        end
  ROC(1,index)=FP1/N;
  ROC(2,index)=TP1/P;  
  PR(2,index)=TP1/(FP1+TP1);%PRECISION
  PR(1,index)=TP1/(TP1+FN1);%RECALL��������
  end 
 plot(ROC(1,:),ROC(2,:),'-*r');