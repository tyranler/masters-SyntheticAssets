fileName = 'syn1.json'; % filename in JSON extension
fid = fopen(fileName); % Opening the file
raw = fread(fid,inf); % Reading the contents
str = char(raw'); % Transformation
fclose(fid); % Closing the file
table1 = jsondecode(str); % Using the jsondecode function to parse JSON from string

fileName = 'syn2.json'; 
fid = fopen(fileName); 
raw = fread(fid,inf); 
str = char(raw');
fclose(fid); 
table2 = jsondecode(str); 

fileName = 'syn3.json'; 
fid = fopen(fileName); 
raw = fread(fid,inf);
str = char(raw'); 
fclose(fid); 
table3 = jsondecode(str); 

%getting data to top level
table1 = table1.data;
table1 = table1.accountLiquidateds;
table1 = struct2table(table1);

table2 = table2.data;
table2 = table2.accountLiquidateds;
table2 = struct2table(table2);

table3 = table3.data;
table3 = table3.accountLiquidateds;
table3 = struct2table(table3);

%concatnate tables
for i = 1:4
    fulltable(:,i) = cat(1, table2array(table1(:,i),table2array(table2(:,i))),table2array(table3(:,i)));
end

%col2 is snx redeemed, col3 is amount liquidated, col4 is liquidator
%address

%there are multiple entries for each daily volume
%so data must be processed and added for unique days
nocelltable = cell2table(fulltable);

sortcol1 = table2array(nocelltable(:,1));
sortcol2 = table2array(nocelltable(:,2));
sortcol3 = table2array(nocelltable(:,3));

sortcol1 = cellfun(@str2num,sortcol1);
sortcol2 = cellfun(@str2num,sortcol2);
sortcol3 = cellfun(@str2num,sortcol3);

%%%%%%%%
temp1 = sortcol1;
temp2 = sortcol2;

datestemp = datestr(temp1/86400 + datenum(1970,1,1));
for i = 1:length(datestemp/11)
    datestring(i) = convertCharsToStrings(datestemp(i,:));
end
datestemp = datestring';

figure
hold on
yyaxis left
scatter(datenum(datestemp),temp2/(10^3),'x')

grid on
axis('auto xy')
ylim([0 160])
%%%%%%%%%%%


uniqueDates = unique(sortcol1);
filler = zeros(height(uniqueDates),1);

newtable = table(uniqueDates,filler);
newtable = [newtable,array2table(zeros(height(uniqueDates),1))];

%adding volumes on the same days
for i = 1:length(sortcol1)
    idate = sortcol1(i);
    foundindex = find(uniqueDates == idate);
    newtable{foundindex,2} = newtable{foundindex,2} + sortcol2(i,1);
    newtable{foundindex,3} = newtable{foundindex,3} + sortcol3(i,1);
end

unixtimes = fulltable(:,1);
unixtimes = cellfun(@str2num,unixtimes);
dates = datestr(unixtimes/86400 + datenum(1970,1,1));

dailyLiquidated = newtable(:,3);
dailySNXRedeemed = newtable(:,2);

dailyLiquidated = table2array(dailyLiquidated)
dailySNXRedeemed = table2array(dailySNXRedeemed)


fileName = 'snxprice.csv';
snxPrice= readtable(fileName,'PreserveVariableNames',false);
snxDailyprice = snxPrice(:,2);
snxDailyprice = table2array(snxDailyprice)


figure
yyaxis left
scatter(uniqueDates,dailyLiquidated)
grid on
datetick('x', 'mmm yy')
axis('auto xy')
