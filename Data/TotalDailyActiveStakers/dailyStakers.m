fileName = 'syn1.json'; % filename in JSON extension
fid = fopen(fileName); % Opening the file
raw = fread(fid,inf); % Reading the contents
str = char(raw'); % Transformation
fclose(fid); % Closing the file
table = jsondecode(str); % Using the jsondecode function to parse JSON from string

%getting data to top level
table = table.data;
table = table.totalDailyActiveStakers;
table = struct2table(table);

%convert UNIX time to int and then date time
unixtimes = table(:,1);
unixtimes = table2array(unixtimes);
unixtimes = str2double(unixtimes);
mindate = min(unixtimes);
maxdate = max(unixtimes);
dates = datestr(unixtimes/86400 + datenum(1970,1,1));

for i = 1:length(dates/11)
    datestring(i) = convertCharsToStrings(dates(i,:));
end
dates = datestring';

activeStakers = table(:,2);
activeStakers = table2array(activeStakers);
activeStakers = str2double(activeStakers);

%getting daily SNX price
fileName = 'snxprice.csv';
snxPrice= readtable(fileName,'PreserveVariableNames',false);
snxDailyprice = snxPrice(:,2);
snxDailyprice = table2array(snxDailyprice)

%plotting
figure
hold on
yyaxis left
ylabel("number of active stakers")
plot(datenum(dates),activeStakers)
yyaxis right
ylabel("SNX daily average price")
ytickformat('usd')
ytickformat('$%,.0f')
ytickformat('$%g')
plot(datenum(dates),snxDailyprice);
grid on
datetick('x', 'mmm yy')
axis('auto xy')
