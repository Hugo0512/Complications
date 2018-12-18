clc
clear all
% mark=0;
distance=[];
level=8;%离散级数
[num,txt,raw] =xlsread('最新数据3');%载入数据
discrete=[];
raw={raw{:,1};raw{:,4};raw{:,5};raw{:,7};raw{:,8};raw{:,9};raw{:,10};raw{:,11};raw{:,12};raw{:,13};raw{:,14};raw{:,15};raw{:,3}}';
% for index=1:size(raw,1)
%    raw{index,4}=raw{index,4}+1;
% end
%对年纪离散化
for index1=1:size(raw,1)
    if raw{index1,5}>=1 & raw{index1,5}<=3
        discrete(index1)=1;
    elseif raw{index1,5}>=4 & raw{index1,5}<=6
         discrete(index1)=2;
    elseif raw{index1,5}>=7 & raw{index1,5}<=9
         discrete(index1)=3;
    elseif raw{index1,5}>=10 & raw{index1,5}<=12
         discrete(index1)=4;
    elseif raw{index1,5}>=13 & raw{index1,5}<=18 
         discrete(index1)=5;
    elseif raw{index1,5}>=19 & raw{index1,5}<=24 
         discrete(index1)=6;  
    elseif raw{index1,5}>24    
         discrete(index1)=7;
    end
end
for index=1:size(raw,1)  
   raw{index,5}=discrete(index);
end

for index1=1:size(raw,1)
    for index2=1:size(raw,2)
        if ischar(raw{index1,index2})==1
          raw{index1,index2}=strtrim(raw{index1,index2});
        else
           raw{index1,index2}=strtrim(num2str(raw{index1,index2}));
        end
    end
end
samplenumber=size(raw,1);%样本数
%对数据分组，分别为有1对无1，有2对无2
x=0;
for index=1:size(raw,1)
    k=findstr(raw{index,end},'NULL');
   if isempty(k)==1
       raw{index,end}=num2str(1);
       x=x+1;
   else
       raw{index,end}=num2str(2);
   end
end
for index=1:size(raw,1)
   if isequal(raw{index,3},'OU')==1
       raw{index,4}='双';
   else
       raw{index,4}='单';
   end
end
rest={};%保存剩下的数据（有并发症的数据）
%本程序为smote,对少数类样本进行扩充，所以rest保存多数类
%删除最后一项为1的有病患者
for index=size(raw,1):-1:1
    if isequal(raw{index,end},'2')==1
        rest(size(rest,1)+1,:)=raw(index,:);
        raw(index,:)=[];
    end
end

%运用给数值型的SMOTE算法
ratio=0.5;%也你根本扩充比例，运行时针对不同问题进行修改

rownumber=size(raw,1);
for index=1:size(raw,1)
    tempsample=raw(index,:);
    if floor(ratio)~=ratio
        %整数部分
        
         for index=1:floor(ratio)
                %选择一个不一样的样本
                another=randint(1,1,[1,rownumber]);
                while another==index
                    another=randint(1,1,[1,rownumber]);
                end
                anothersample=raw(another,:);
                %根据最大频率原则产生人工样本，之后存储到raw的最后一行
                values={};
        %         stastistic=[];%存储各种属性取值的统计结果
                artificialsample={};
                for index1=1:size(raw,2)
                    tempvalues={tempsample{index1},anothersample{index1}};
                    uniquevalues=unique(tempvalues);
                    if numel(uniquevalues)==1
                        values{index1}=uniquevalues;
                        artificialsample{index1}=uniquevalues{1};
                    else
                        values{index1}=uniquevalues;
                        if rand()>0.5
                            artificialsample{index1}=uniquevalues{1};
                        else
                            artificialsample{index1}=uniquevalues{2};
                        end
                    end
                end
                raw(size(raw,1)+1,:)=artificialsample;
            end
        
          for index=1:ceil(ratio-floor(ratio))
        %选择一个不一样的样本
        if rand()>0.5
                another=randint(1,1,[1,rownumber]);
                while another==index
                    another=randint(1,1,[1,rownumber]);
                end
                anothersample=raw(another,:);
                %根据最大频率原则产生人工样本，之后存储到raw的最后一行
                values={};
        %         stastistic=[];%存储各种属性取值的统计结果
                artificialsample={};
                for index1=1:size(raw,2)
                    tempvalues={tempsample{index1},anothersample{index1}};
                    uniquevalues=unique(tempvalues);
                    if numel(uniquevalues)==1
                        values{index1}=uniquevalues;
                        artificialsample{index1}=uniquevalues{1};
                    else
                        values{index1}=uniquevalues;
                        if rand()>0.5
                            artificialsample{index1}=uniquevalues{1};
                        else
                            artificialsample{index1}=uniquevalues{2};
                        end
                    end
                end
                raw(size(raw,1)+1,:)=artificialsample;

                end
         end
        
    else

        for index=1:floor(ratio)
                %选择一个不一样的样本
                another=randint(1,1,[1,rownumber]);
                while another==index
                    another=randint(1,1,[1,rownumber]);
                end
                anothersample=raw(another,:);
                %根据最大频率原则产生人工样本，之后存储到raw的最后一行
                values={};
        %         stastistic=[];%存储各种属性取值的统计结果
                artificialsample={};
                for index1=1:size(raw,2)
                    tempvalues={tempsample{index1},anothersample{index1}};
                    uniquevalues=unique(tempvalues);
                    if numel(uniquevalues)==1
                        values{index1}=uniquevalues;
                        artificialsample{index1}=uniquevalues{1};
                    else
                        values{index1}=uniquevalues;
                        if rand()>0.5
                            artificialsample{index1}=uniquevalues{1};
                        else
                            artificialsample{index1}=uniquevalues{2};
                        end
                    end
                end
                raw(size(raw,1)+1,:)=artificialsample;
            end
        
    end
end