%id	year	month	day	hour	minute	second	wind speed	wind direction
m = csvread('wind data.csv');

%% constants
freq2speed = 1.5; % 1.5mph/hz
units2volt = 4.9*10^-3;

%% time conversions
t = m(:,5)*3600+m(:,6)*60+m(:,7);
t = t-t(1); % normalized, units of seconds

%% wind data
wind_speed_raw = m(:,8);
wind_dir_raw = m(:,9);

%% average value computation
transitions = sum(abs(diff(wind_speed_raw)));
avg_freq = transitions/t(end);
avg_wind_speed_mph = avg_freq*freq2speed;
avg_wind_dir_raw = mode(wind_dir_raw);
avg_wind_dir_volt = avg_wind_dir_raw*units2volt;
avg_wind_dir = 'South East due East';

%% data selection
t_final = 1800; % 30 minute
t=t(t<=t_final);
wind_speed_raw=wind_speed_raw(t<=t_final);
wind_dir_raw=wind_dir_raw(t<=t_final);

%% local averaging
freq = zeros(t_final,1);
for i=0:1:t_final
   time_index = t == i;
   transitions = sum(abs(diff(wind_speed_raw(time_index))));
   freq(i+1) = transitions; % zero crossings per second
end
t_s=(0:1:t_final)'; % time data free of duplications
wind_speed_mph = freq*freq2speed;

hold on;
plot(t_s,wind_speed_mph,'r.');
plot(t_s,wind_speed_mph,'b-');
title('Wind Speed Over Time At Killian Court');
ylabel('Wind Speed (mph)');
xlabel('Time (s)');

%% write data
csvwrite('wind data clean.csv',[t_s,wind_speed_mph]);