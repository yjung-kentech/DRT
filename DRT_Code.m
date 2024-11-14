clear; clc; close all;

%% Load the data
data_dir = 'G:\공유 드라이브\Battery Software Lab\Projects\DRT\SD';
data_file = fullfile(data_dir, 'AS2_1per.mat');
loaded_struct = load(data_file);
data = loaded_struct.AS2_1per; % 파일이 바뀌면 바꿔야함

%% 미리 할당할 총 조합 수 계산
num_combinations = 0;

% 조합 1: dt=0.1, duration=1000, n=[201, 101, 21]
num_combinations = num_combinations + length([201, 101, 21]);

% 조합 2: dt=[0.2, 1, 2], duration=1000, n=201
num_combinations = num_combinations + length([0.2, 1, 2]);

% 조합 3: dt=0.1, duration=[500, 250], n=201
num_combinations = num_combinations + length([500, 250]);

% combinations 구조체 배열 미리 할당
combinations(num_combinations) = struct('dt', [], 'duration', [], 'n', []);

idx = 1;

% 조합 1
dt = 0.1;
duration = 1000;
n_list = [201, 101, 21];
for i = 1:length(n_list)
    n = n_list(i);
    combinations(idx).dt = dt;
    combinations(idx).duration = duration;
    combinations(idx).n = n;
    idx = idx + 1;
end

% 조합 2
dt_list = [0.2, 1, 2];
duration = 1000;
n = 201;
for i = 1:length(dt_list)
    dt = dt_list(i);
    combinations(idx).dt = dt;
    combinations(idx).duration = duration;
    combinations(idx).n = n;
    idx = idx + 1;
end

% 조합 3
dt = 0.1;
duration_list = [500, 250];
n = 201;
for i = 1:length(duration_list)
    duration = duration_list(i);
    combinations(idx).dt = dt;
    combinations(idx).duration = duration;
    combinations(idx).n = n;
    idx = idx + 1;
end

% 결과를 저장할 struct 배열 초기화
total_results = num_combinations * 10;
AS2_1per_new(total_results) = struct('dt', [], 'dur', [], 'n', [], 'SN', [], 'V', [], 'I', [], 't', []);

index = 1;

% 모든 조합에 대해 데이터 처리
for i = 1:length(combinations)
    dt = combinations(i).dt;
    duration = combinations(i).duration;
    n = combinations(i).n;

    for j = 1:10
        % 원본 데이터 가져오기
        SN = data(j).SN;
        V_orig = data(j).V;
        I_orig = data(j).I;
        t_orig = data(j).t;

        % duration에 따른 데이터 리샘플링
        dur = t_orig <= duration;
        V_dur = V_orig(dur);
        I_dur = I_orig(dur);
        t_dur = t_orig(dur);

        % dt에 따른 데이터 리샘플링
        step = round(dt/0.1);
        V_new = V_dur(1:step:end);
        I_new = I_dur(1:step:end);
        t_new = t_dur(1:step:end);
        
        % 결과 저장
        AS2_1per_new(index).SN = SN;
        AS2_1per_new(index).dt = dt;
        AS2_1per_new(index).dur = duration;
        AS2_1per_new(index).n = n;
        AS2_1per_new(index).V = V_new;
        AS2_1per_new(index).I = I_new;
        AS2_1per_new(index).t = t_new;
        index = index + 1;
    end
end


save('AS2_1per_new.mat', 'AS2_1per_new'); % 파일마다 이름 바꾸기
