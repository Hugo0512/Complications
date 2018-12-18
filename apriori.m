clc
clear all
warning off
  minsupporting=0;
[num1,txt1,raw1] =xlsread('newsamples10');%载入数据
[num2,txt2,raw2] =xlsread('newsamples11');%载入数据
raw=[raw1;raw2];

% [num,txt,raw] =xlsread('最新数据');%载入数据
% discrete=[];
% raw={raw{:,1};raw{:,4};raw{:,6};raw{:,7};raw{:,8};raw{:,9};raw{:,10};raw{:,3}}';
% for index=1:size(raw,1)
%    raw{index,4}=raw{index,4}+1;
% end
% 
% %对年纪离散化
% for index1=1:size(raw,1)
%     if raw{index1,4}>=1 & raw{index1,4}<=3
%         discrete(index1)=1;
%     elseif raw{index1,4}>=4 & raw{index1,4}<=6
%          discrete(index1)=2;
%     elseif raw{index1,4}>=7 & raw{index1,4}<=9
%          discrete(index1)=3;
%     elseif raw{index1,4}>=10 & raw{index1,4}<=12
%          discrete(index1)=4;
%     elseif raw{index1,4}>=13 & raw{index1,4}<=18 
%          discrete(index1)=5;
%     elseif raw{index1,4}>=19 & raw{index1,4}<=24 
%          discrete(index1)=6; 
%     elseif raw{index1,4}>24    
%          discrete(index1)=7;
%     end
% end
% for index=1:size(raw,1)  
%    raw{index,4}=discrete(index);
% end
% 
% for index1=1:size(raw,1)
%     for index2=1:size(raw,2)
%         if ischar(raw{index1,index2})==1
%           raw{index1,index2}=strtrim(raw{index1,index2});
%         else
%            raw{index1,index2}=strtrim(num2str(raw{index1,index2}));
%         end
%     end
% end
% samplenumber=size(raw,1);%样本数
% %对数据分组，分别为有1对无1，有2对无2
% 
for index=1:size(raw,1)
    raw(index,2)=strcat(raw(index,2),'r');
    raw(index,9)=strcat(raw(index,9),'s');
    raw(index,10)=strcat(raw(index,10),'o');
    raw(index,11)=strcat(raw(index,11),'p');
    raw(index,12)=strcat(raw(index,12),'q');
end
class1={};%存放两类数据，分别挖掘
class2={};
for index=1:size(raw,1)
   if raw{index,end}==1
       raw{index,end}='有';
       class1(size(class1,1)+1,:)=raw(index,:);
   else
       raw{index,end}='无';
       class2(size(class2,1)+1,:)=raw(index,:);
   end
end
% clear raw
% raw=class1;
% raw(:,end)=[];
% for index=1:size(raw,1)
%    if isequal(raw{index,3},'OU')==1
%        raw{index,3}='双';
%    else
%        raw{index,3}='单';
%    end
% end
% %对手术方式进行处理
% % %有无IOL，其他三种手术方式
% % IOL={};
% % for index1=1:size(raw,1)
% %          k=findstr(raw{index1,2},'IOL');
% %          str=raw{index1,2};
% %        if isempty(k)~=1
% %            IOL{index1}='Y';
% %            raw{index1,2}=str(1:end-4);
% %        else
% %         IOL{index1}='N';
% %     end
% % end
% %重新组合数据
% % raw=[raw(:,1:7) IOL' raw(:,8)];
% 
% % dataclass1={};
% % dataclass2={};
% % for index=1:size(raw,1)  
% %    if  strcmp(raw{index,8},'有')==1
% %        dataclass1(size(dataclass1,1)+1,:)=raw(index,:);
% %    else
% %        dataclass2(size(dataclass2,1)+1,:)=raw(index,:);
% %    end
% %    if strcmp(raw{index,8},'1')==1
% %        dataclass1(size(dataclass1,1)+1,:)=raw(index,:);
% %    elseif strcmp(raw{index,8},'2')==1
% %        dataclass2(size(dataclass2,1)+1,:)=raw(index,:);
% %    elseif strcmp(raw{index,8},'1,2')==1
% %        dataclass3(size(dataclass3,1)+1,:)=raw(index,:);
% %    end
% % end
% 
% % raw=dataclass1;

itemset={};
itemsetnumber=[];
%计算频繁1项集
for index1=1:size(raw,1)
    for index2=1:size(raw,2)
        %寻找此元素是否包含在项集中
         if isempty(itemset)==1
            itemset{size(itemset,1)+1,1}=raw{index1,index2}; 
            itemsetnumber(size(itemset,1)+1)=1;
         else
             position=0;
             for index3=1:size(itemset,1)
                 if isequal(itemset{index3,1},raw{index1,index2})
                     position=index3;
                     break;
                 end
             end
             if position~=0
                  itemsetnumber(position)=itemsetnumber(position)+1;
             else
                  itemset{size(itemset,1)+1,1}=raw{index1,index2}; 
                  itemsetnumber(size(itemset,1)+1)=1;
             end
         end
        
    end
end

selectitemset={};
itemsetnumberexchange=[];
for index4=1:size(itemset,1)
    if itemsetnumber(index4)>size(raw,1)*minsupporting
        selectitemset{size(selectitemset,1)+1,1}=itemset{index4,1};
    end
end
if isempty(selectitemset)==1
    display('无解');
end
k=1;


while isempty(selectitemset)==0%直到找不到频繁相集为止
    %寻找k+1项集
    k=k+1;
    itemset={};
    k
    
    if k==2
        itemsetexchange={};
        %组成二项集
        for index5=1:size(selectitemset,1)
            for index6=index5+1:size(selectitemset,1)
                tempitem={selectitemset{index5,1},selectitemset{index6,1}};
                rownumber=size(itemsetexchange,1);
                for index8=1:k
                    itemsetexchange(rownumber+1,index8)=tempitem(1,index8);
                end
            end
        end
        %判断出现频率
         itemsetnumberexchange=zeros(size(itemsetexchange,1),1);
         label=[];%标记频繁项集的存在与否
             for index7=1:size(raw,1)
                   temp=raw(index7,:);
                        for index6=1:size(itemsetexchange,1)
                            label=[];
                                 for index8=1:k
                                     for index9=1:size(temp,2)
                                         if isequal(temp(1,index9),itemsetexchange(index6,index8))==1
                                             label(index8)=1;
                                             break;
                                         end
                                     end
                                 end
                                 if isequal(label,ones(1,k))==1
                                     itemsetnumberexchange(index6)=itemsetnumberexchange(index6)+1;
                                 end
                        end
             end
           %将频率较低的项集删除
             selectitemsetexchange={};
                    for index4=1:size(itemsetexchange,1)
                        if itemsetnumberexchange(index4)>size(raw,1)*minsupporting
                            selectitemsetexchange(size(selectitemsetexchange,1)+1,:)=itemsetexchange(index4,:);
                        end
                    end
    else
        %组成k项集（k>=3）
        itemsetexchange={};
        for index5=1:size(selectitemset,1)
            for index6=index5+1:size(selectitemset,1)
                label=[];%标记前几项是否都相同
                for index10=1:k-2
                    if isequal(selectitemset(index5,index10),selectitemset(index6,index10))==1
                        label(index10)=1;
                    else
                        label(index10)=0;
                    end
                end
                
                if isequal(label,ones(k-2,1))==1
                    tempitem={selectitemset{index5,:} selectitemset{index6,k-1}};
                    rownumber=size(itemsetexchange,1);
                    for index8=1:k
                        itemsetexchange{rownumber+1,index8}=tempitem{index8};
                    end
                 end
            end
            end 
         %计算频率
            itemsetnumberexchange=zeros(size(itemsetexchange,1),1);
         label=[];%标记频繁项集的存在与否
       for index7=1:size(raw,1)
                   temp=raw(index7,:);
                        for index6=1:size(itemsetexchange,1)
                            label=[];
                                 for index8=1:k
                                     for index9=1:size(temp,2)
                                         if isequal(temp(1,index9),itemsetexchange(index6,index8))==1
                                             label(index8)=1;
                                             break;
                                         end
                                     end
                                 end
                                 if isequal(label,ones(1,k))==1
                                     itemsetnumberexchange(index6)=itemsetnumberexchange(index6)+1;
                                 end
                        end
             end
           %将频率较低的项集删除
             selectitemsetexchange={};
                    for index4=1:size(itemsetexchange,1)
                        if itemsetnumberexchange(index4)>size(raw,1)*minsupporting
                            selectitemsetexchange(size(selectitemsetexchange,1)+1,:)=itemsetexchange(index4,:);
                        end
                    end
    end
    if  isempty(selectitemsetexchange)==0 
       selectitemset=selectitemsetexchange;
    else
        %if isempty(itemsetexchange)==0
            result=selectitemset;
            break;
        %end
    end
end%与while对应
%产生关联规则
rule={};
for index=1:size(result,1)
    temp=result(index,:);
    
    
    for index1=1:numel(temp)-1
    
           combos = combntns(1:numel(temp),index1);%求排列组合
         for index2=1:size(combos,1)
            left=temp(1,combos(index2,:));
            rightnumber=setdiff(1:numel(temp),combos(index2,:));
            right=temp(1,rightnumber);
            rownumber=size(rule,1);
            rule{rownumber+1,1}=left;
            rule{rownumber+1,2}=right;
        %计算置信度
         tempnumber=0;
         leftnumber=0;
         length1=zeros(size(raw,1),numel(temp));
         length2=zeros(size(raw,1),numel(left));
         
          for index9=1:numel(temp)
            for index4=1:size(raw,1)
                for index5=1:size(raw,2)
                   
                    if isequal(temp(index9),raw(index4,index5))==1
                        length1(index4,index9)=1;
%                         break;
                    end
                end
            end%与index4对应
          end
         
     for index9=1:numel(left)
            for index4=1:size(raw,1)
                for index5=1:size(raw,2)
                   if isequal(left(index9),raw(index4,index5))==1
                        length2(index4,index9)=1;
%                         break;
                    end
                end
            end%与index4对应
         end
         
            for index6=1:size(length1,1)
                if isequal(length1(index6,:),ones(1,numel(temp)))
                    tempnumber=tempnumber+1;
                end
                if isequal(length2(index6,:),ones(1,numel(left)))
                    leftnumber=leftnumber+1;  
                end
            end
            rule{rownumber+1,3}=tempnumber/leftnumber;
         end
    end
end
% newrule={};

% %将关联规则存储起来
% for index1=1:size(rule,1)
%     temp=rule{index1,1};
%     newrule{index1,1}=temp{1};
%     temp=rule{index1,2};
%      newrule{index1,2}=temp{1};
%      newrule{index1,3}=rule{index1,3};
% end