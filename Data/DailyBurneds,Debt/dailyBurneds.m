fileName = 'syn1.json'; % filename in JSON extension
fid = fopen(fileName); % Opening the file
raw = fread(fid,inf); % Reading the contents
str = char(raw'); % Transformation
fclose(fid); % Closing the file
table = jsondecode(str); % Using the jsondecode function to parse JSON from string

%getting data to top level
table = table.data;
table = table.dailyBurneds;
table = struct2table(table);

%getting daily SNX price
fileName = 'snxprice.csv';
snxPrice= readtable(fileName,'PreserveVariableNames',false);

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

dailyBurned = table(:,3);
dailyBurned = table2array(dailyBurned);
dailyBurned = str2double(dailyBurned);

totalDebt = table(:,2);
totalDebt = table2array(totalDebt);
totalDebt = str2double(totalDebt);

snxDailyprice = snxPrice(:,2);
snxDailyprice = table2array(snxDailyprice)

%plotting burned,total debt

figure
hold on
xlabel("date");
yyaxis left;
ylabel("daily Synths burned")
ytickformat('usd')
ytickformat('$%,.0f')
ytickformat('$%g M')
b=bar(datenum(dates),dailyBurned/(10^6));

yyaxis right;
ylabel("total debt")
ytickformat('usd')
ytickformat('$%,.0f')
ytickformat('$%g M')
p = plot(datenum(dates),totalDebt/(10^6));
grid on;
datetick('x', 'mmm yy');



%axis('auto xy');

%plotting snxprice, totaldebt
figure
hold on
xlabel("date");
yyaxis left;
ylabel("SNX daily average price")
ytickformat('usd')
ytickformat('$%,.0f')
ytickformat('$%g')
b=plot(datenum(dates),snxDailyprice);

yyaxis right;
ylabel("total debt")
ytickformat('usd')
ytickformat('$%,.0f')
ytickformat('$%g M')
p = plot(datenum(dates),totalDebt/(10^6));
datetick('x', 'mmm yy');
grid on;

%plotting snxprice, dailyburned
figure
hold on
xlabel("date");
yyaxis right;
ylabel("SNX daily average price")
ytickformat('usd')
ytickformat('$%,.0f')
ytickformat('$%g')
b=plot(datenum(dates),snxDailyprice);

yyaxis left;
ylabel("daily Synths burned")
ytickformat('usd')
ytickformat('$%,.0f')
ytickformat('$%g M')
p = bar(datenum(dates),dailyBurned/(10^6));
datetick('x', 'mmm yy');
grid on;