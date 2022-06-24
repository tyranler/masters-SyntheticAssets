fileName = 'UMA1.json'; % filename in JSON extension
fid = fopen(fileName); % Opening the file
raw = fread(fid,inf); % Reading the contents
str = char(raw'); % Transformation
fclose(fid); % Closing the file
table1 = jsondecode(str); % Using the jsondecode function to parse JSON from string

table1 = table1.data;
table1 = table1.liquidationCreatedEvents;
table1 = struct2table(table1);

%convert UNIX time to int and then date time
unixtimes = table1(:,1);
unixtimes = table2array(unixtimes);
unixtimes = str2double(unixtimes);
mindate = min(unixtimes);
maxdate = max(unixtimes);
dates = datestr(unixtimes/86400 + datenum(1970,1,1));

for i = 1:length(dates/11)
    datestring(i) = convertCharsToStrings(dates(i,:));
end
dates = datestring';

allLiquidations = table1(:,2);
allLiquidations = table2array(allLiquidations);
allLiquidations = cellfun(@str2num,allLiquidations);
allLiquidations = allLiquidations/(10^18);