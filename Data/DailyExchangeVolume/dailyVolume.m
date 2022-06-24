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
table1 = table1.dailyExchangePartners;
table1 = struct2table(table1);

table2 = table2.data;
table2 = table2.dailyExchangePartners;
table2 = struct2table(table2);

table3 = table3.data;
table3 = table3.dailyExchangePartners;
table3 = struct2table(table3);

%concatnate tables
for i = 1:4
    fulltable(:,i) = cat(1, table2array(table1(:,i),table2array(table2(:,i))),table2array(table3(:,i)));
end

%there are multiple entries for each daily volume
%so data must be processed and added for unique days
sqltable = cell2table(fulltable);

sortcol1 = table2array(sqltable(:,1));
sortcol2 = table2array(sqltable(:,3));

sortcol1 = cellfun(@str2num,sortcol1);
sortcol2 = cellfun(@str2num,sortcol2);

uniqueDates = unique(sortcol1);
filler = zeros(height(uniqueDates),1);

newtable = table(uniqueDates,filler);
newtable2 = sortrows(newtable);

%adding volumes on the same days
for i = 1:length(sortcol1)
    idate = sortcol1(i);
    foundindex = find(uniqueDates == idate);
    newtable{foundindex,2} = newtable{foundindex,2} + sortcol2(i,1);
end

unixtimes = uniqueDates;
mindate = min(unixtimes);
maxdate = max(unixtimes);
dates = datestr(unixtimes/86400 + datenum(1970,1,1));

for i = 1:length(dates/11)
    datestring(i) = convertCharsToStrings(dates(i,:));
end
dates = datestring';

dailyVolSyn = newtable(:,2);
dailyVolSyn = table2array(dailyVolSyn);

%plotting
figure
bar(datenum(dates),dailyVolSyn)
grid on
datetick('x', 'mmm yy')
axis('auto xy')
