fileName = 'AllTVLcsv.csv';
table = readtable(fileName);

%convert UNIX time to int and then date time
unixtimes = table(:,1);
unixtimes = table2array(unixtimes);

mindate = min(unixtimes);
maxdate = max(unixtimes);
dates = datestr(unixtimes/86400 + datenum(1970,1,1));

for i = 1:length(dates/11)
    datestring(i) = convertCharsToStrings(dates(i,:));
end
dates = datestring';

TVLSyn = table(:,2);
TVLMir = table(:,3);
TVLLin = table(:,4);

TVLSyn = table2array(TVLSyn);
TVLMir = table2array(TVLMir);
TVLLin = table2array(TVLLin);

Y = [TVLSyn,TVLMir,TVLLin];
%plotting
figure
hold on
area(datenum(dates),Y/(10^9))
ylabel("total TVL")
ytickformat('usd')
ytickformat('$%,.0f')
ytickformat('$%g B')
grid on
datetick('x', 'mmm yy')
axis('auto xy')
legend('Synthetix','Mirror','Linear')
xlabel("date")
