clc
clear all
warning off
result1=[];%存储适应度
rswult2=[];%存储染色体
for index0000=1:10  
    index0000
variablenames={'gender','changeornot','operationmode','eyecode','age','area','density','covercentral','a','b','c','d'};
population=[];%种群
populationsize=30;
historybestfitness=-Inf;
historybestchromosome=[];
featurenumber=12;%特征个数,待定
maxgeneration=50;%最大迭代次数
newpopulation=[];
crossoverrate=0.7;
mutationrate=0.3;
fitness=[];
for index1=1:populationsize
    for index2=1:featurenumber
        if rand()>=0.5
            population(index1,index2)=1;
        else
            population(index1,index2)=0;
        end
    end
end
for k=1:maxgeneration 
   %计算适应度
   k
   for index9=1:populationsize
      currentchromosome=population(index9,:);
      tempaccuracy=[];
      for index100=1:3%三倍交叉验证
          [num,txt,raw1]=xlsread(strcat('triandata',num2str(index100)));
          triandata=raw1(:,1:end-1);
          trianlabel=raw1(:,end);
          [num,txt,raw2]=xlsread(strcat('testdata',num2str(index100)));
          testdata=raw2(:,1:end-1);
          testlabel=raw2(:,end);
          %数据读取完毕
                  temptriandata={};
                  temptestdata={};
                  tempvariablenames={};
                      featurecount=0;
                  for index10=1:featurenumber%准备特征
                      if currentchromosome(index10)==1
                          temptriandata(:,featurecount+1)=triandata(:,index10);
                          temptestdata(:,featurecount+1)=testdata(:,index10);
                          tempvariablenames{featurecount+1}=variablenames{index10};
                          featurecount=featurecount+1;
                      end
                  end
                  
                  %处理数据
                  for index=1:numel(testlabel)
                        testlabel{index}=num2str(testlabel{index});
                  end

                    for index=1:numel(trianlabel)
                        if ischar(trianlabel{index})~=1
                            trianlabel{index}=num2str(trianlabel{index});
                        end
                    end
                    for index=1:size(temptriandata,1)
                        for index1=1:size(temptriandata,2)
                            if ischar(temptriandata{index,index1})~=1
                                temptriandata{index,index1}=num2str(temptriandata{index,index1});
                            end
                        end
                    end
                    for index=1:size(temptestdata,1)
                        for index1=1:size(temptestdata,2)
                            if ischar(temptestdata{index,index1})~=1
                                temptestdata{index,index1}=num2str(temptestdata{index,index1});
                            end
                        end
                    end
                  trian_data=cell2table(temptriandata,'VariableNames', tempvariablenames);
                   test_data=cell2table(temptestdata,'VariableNames', tempvariablenames);
                  
                  %此处使用随机森林分类，获得准确率
                Factor = TreeBagger(100, trian_data, trianlabel);
                [Predict_label,Scores] = predict(Factor, test_data);
%获得准确率
              correct=0;
                for index=1:numel(testlabel)
                    if isequal(testlabel{index},Predict_label{index})==1
                        correct=correct+1;
                    end
                end
                accuracy=correct/numel(testlabel);
              tempaccuracy(index100)=accuracy;
      end
      fitness(index9)=mean(tempaccuracy);
   end
   if max(fitness)>historybestfitness
       historybestfitness=max(fitness);
   end
   maxchromosome=find(fitness==max(fitness));
   historybestchromosome=population(maxchromosome(randint(1,1,[1,numel(maxchromosome)])),:);
   fitness=fitness./sum(fitness);
   %组成轮盘
       lunpan=[];
       lunpan(1)=fitness(1);
       for i=2:populationsize
         lunpan(i)=lunpan(i-1)+fitness(i);
       end
       %轮盘赌选择
    for i=1:populationsize 
        selectedposition=[];
        mark=rand();
        for index3=1:populationsize
            if lunpan(index3)>=mark
                selectedposition=index3;
                break;
            end
        end
        newpopulation(i,:)=population(selectedposition,:);
    end
       %交叉
       for index4=1:crossoverrate*populationsize
           temparray=randperm(populationsize);
           chromosome1=newpopulation(temparray(1),:);
           chromosome2=newpopulation(temparray(2),:);
           crossoverpoint=randint(1,1,[1,featurenumber]);
           tempelement=chromosome1(1:crossoverpoint);
           chromosome1(1:crossoverpoint)=chromosome2(1:crossoverpoint);
           chromosome2(1:crossoverpoint)=tempelement;
       end
       %变异
         for index5=1:mutationrate*populationsize
          mutationposition=randint(1,1,[1,featurenumber]);
          chosenchromosome=randint(1,1,[1,populationsize]);
          character=newpopulation(chosenchromosome,mutationposition);
              if character==1
                  newpopulation(chosenchromosome,mutationposition)=0;
              else
                  newpopulation(chosenchromosome,mutationposition)=1;
              end
         end
         population=newpopulation;
end
%最后获得的结果分类
   ROCS={};
TP=zeros(1,3);
FN=zeros(1,3);
TN=zeros(1,3);
FP=zeros(1,3);
Accuracy=zeros(1,3);
Sensitivity=zeros(1,3);
FNR=zeros(1,3);
Specificity=zeros(1,3);
FPR=zeros(1,3);
     for index100=1:3
         %换分类器，换成随机森林
          [num,txt,raw1]=xlsread(strcat('triandata',num2str(index100)));
          triandata=raw1(:,1:end-1);
          trianlabel=raw1(:,end);
          [num,txt,raw2]=xlsread(strcat('testdata',num2str(index100)));
          testdata=raw2(:,1:end-1);
          testlabel=raw2(:,end);
                  temptriandata={};
                  temptestdata={};
                  tempvariablenames={};
                      featurecount=0;
                  for index10=1:featurenumber%准备特征
                      if historybestchromosome(index10)==1
                          temptriandata(:,featurecount+1)=triandata(:,index10);
                          temptestdata(:,featurecount+1)=testdata(:,index10);
                           tempvariablenames{featurecount+1}=variablenames{index10};
                          featurecount=featurecount+1;
                      end
                  end
                  %此处使用随机森林分类，获得准确率 %处理数据
                  for index=1:numel(testlabel)
                        testlabel{index}=num2str(testlabel{index});
                  end

                    for index=1:numel(trianlabel)
                        if ischar(trianlabel{index})~=1
                            trianlabel{index}=num2str(trianlabel{index});
                        end
                    end
                    for index=1:size(temptriandata,1)
                        for index1=1:size(temptriandata,2)
                            if ischar(temptriandata{index,index1})~=1
                                temptriandata{index,index1}=num2str(temptriandata{index,index1});
                            end
                        end
                    end
                    for index=1:size(temptestdata,1)
                        for index1=1:size(temptestdata,2)
                            if ischar(temptestdata{index,index1})~=1
                                temptestdata{index,index1}=num2str(temptestdata{index,index1});
                            end
                        end
                    end
                  trian_data=cell2table(temptriandata,'VariableNames', tempvariablenames);
                   test_data=cell2table(temptestdata,'VariableNames', tempvariablenames);  
                  %此处使用随机森林分类，获得准确率
                Factor = TreeBagger(100, trian_data, trianlabel);
                [Predict_label,Scores] = predict(Factor, test_data);
           %获得准确率
              correct=0;
                for index=1:numel(testlabel)
                    if isequal(testlabel{index},Predict_label{index})==1
                        correct=correct+1;
                    end
                end
                accuracy=correct/numel(testlabel);
              Accuracy(index100)=accuracy;
              %计算正常和不正常样本个数          
              testlabel=cell2mat(testlabel);
testlabel=str2num(testlabel);
number1=numel(find(testlabel==1));%阳性样本数
number2=numel(testlabel)-number1;
predict_label=cell2mat(Predict_label);
predict_label=str2num(predict_label);
for index1=1:number1+number2
    if predict_label(index1)==1 & testlabel(index1)==1
        TP(index100)=TP(index100)+1;
    end
    if predict_label(index1)==2 & testlabel(index1)==2
         TN(index100)=TN(index100)+1;
     end
end
% for index1=1:number2
%     if predict_label(index1+number1)==2 & test_label(index1+number1)==2
%         TN=TN+1;
%     end
% end
FP(index100)=number2-TN(index100);
        P(index100)=number1;
        N(index100)=number2;
FN(index100)=number1-TP(index100);
Accuracy(index100)=(TP(index100)+TN(index100))/(P(index100)+N(index100));
Sensitivity(index100)=TP(index100)/P(index100);
FNR(index100)=1-Sensitivity(index100);
Specificity(index100)=TN(index100)/N(index100);
FPR(index100)=1-Specificity(index100);
recall(index100)= 1 - FN(index100)/P(index100);
ROC=[];%画ROC曲线的存储矩阵
largevalues=[];
largevalues=Scores(:,1);%属于正例的概率
templabel=[];
    %组合矩阵
    comprehensivearray=[testlabel largevalues];
    
     %排序
    for index4=1:size(comprehensivearray,1)
        for index5=index4+1:size(comprehensivearray,1)
            if comprehensivearray(index4,2)<comprehensivearray(index5,2)
                %交换
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
  ROC(1,index)=FP1/N(index100);
  ROC(2,index)=TP1/P(index100);     
   end %计算各种指标和ROC曲线
      ROCS{index100}=ROC;            
     end   
%  for index=1:size(ROCS,2)
%        temparray=ROCS{index};
%        tempname=strcat(strcat('ROC',num2str(index)),'.txt');
%        save(tempname,'temparray','-ascii');
% end
result1(index0000)=historybestfitness;
result2(index0000,:)=historybestchromosome;
end
save result1.txt -ascii result1
save result2.txt -ascii result2