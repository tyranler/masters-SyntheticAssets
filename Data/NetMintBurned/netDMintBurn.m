fileName = 'dIssued.json'; % filename in JSON extension
fid = fopen(fileName); % Opening the file
raw = fread(fid,inf); % Reading the contents
str = char(raw'); % Transformation
fclose(fid); % Closing the file
table1 = jsondecode(str); % Using the jsondecode function to parse JSON from string

fileName = 'dBurned.json'; % filename in JSON extension
fid = fopen(fileName); % Opening the file
raw = fread(fid,inf); % Reading the contents
str = char(raw'); % Transformation
fclose(fid); % Closing the file
table2 = jsondecode(str); % Using the jsondecode function to parse JSON from string

%getting data to top level
table1 = table1.data;
table1 = table1.dailyIssueds;
table1 = struct2table(table1);
table2 = table2.data;
table2 = table2.dailyBurneds;
table2 = struct2table(table2);

%convert UNIX time to int and then date time
unixtimes = table2(:,1);
unixtimes = table2array(unixtimes);
unixtimes = str2double(unixtimes);
mindate = min(unixtimes);
maxdate = max(unixtimes);
dates = datestr(unixtimes/86400 + datenum(1970,1,1));

for i = 1:length(dates/11)
    datestring(i) = convertCharsToStrings(dates(i,:));
end
dates = datestring';


%process data, one table has missing dates
fileName = 'col1fix.csv';
col1 = readtable(fileName,'PreserveVariableNames',false);
%col1 = table1(:,2);%for minitng
col2 = table2(:,3);%for burning


mintcol = table2array(col1);
burncol = table2array(col2);


dailyIssued = col1;
dailyIssued = table2array(dailyIssued);


dailyBurned = col2;
dailyBurned = table2array(dailyBurned);
dailyBurned = str2double(dailyBurned);

dailyNet = dailyIssued - dailyBurned;


%plotting
figure
hold on 
ylabel("daily net minted/burned")
ytickformat('usd')
ytickformat('$%,.0f')
ytickformat('$%g M')
b=bar(datenum(dates),dailyNet/(10^6));
ylim([-150 150])
grid on


datetick('x', 'mmm yy');
xlabel("date")

%axis('auto xy');