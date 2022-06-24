fileName = 'syn1.json'; % filename in JSON extension
fid = fopen(fileName); % Opening the file
raw = fread(fid,inf); % Reading the contents
str = char(raw'); % Transformation
fclose(fid); % Closing the file
table = jsondecode(str); % Using the jsondecode function to parse JSON from string

%getting data to top level
table = table.data;
table = table.dailyIssueds;
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

dailyIssued = table(:,2);
dailyIssued = table2array(dailyIssued);
dailyIssued = str2double(dailyIssued);

totalDebt = table(:,3);
totalDebt = table2array(totalDebt);
totalDebt = str2double(totalDebt);

%plotting
figure
hold on
xlabel("date");
yyaxis left;
ylabel("daily Synths minted")
ytickformat('usd')
ytickformat('$%,.0f')
ytickformat('$%g M')
b=bar(datenum(dates),dailyIssued/(10^6));
yyaxis right;
ylabel("total debt")
ytickformat('usd')
ytickformat('$%,.0f')
ytickformat('$%g M')
p = plot(datenum(dates),totalDebt/(10^6));
grid on;
datetick('x', 'mmm yy');
%axis('auto xy');
