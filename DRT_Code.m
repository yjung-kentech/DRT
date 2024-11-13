clear; clc; close all;

%% Load the data
data_dir = 'G:\공유 드라이브\Battery Software Lab\Projects\DRT\SD';
data_file = fullfile(data_dir, 'AS2_2per.mat');
loaded_struct = load(data_file);
data = loaded_struct.AS2_2per; % 파일이 바뀌면 바꿔야함

%% 미리 할당할 총 조합 수 계산
num_combinations = 0;

% 조합 1: dt=0.1, duration=1000, N=[201, 101, 21]
num_combinations = num_combinations + length([201, 101, 21]);

% 조합 2: dt=[0.2, 1, 2], duration=1000, N=201
num_combinations = num_combinations + length([0.2, 1, 2]);

% 조합 3: dt=0.1, duration=[500, 250], N=201
num_combinations = num_combinations + length([500, 250]);

% combinations 구조체 배열 미리 할당
combinations(num_combinations) = struct('dt', [], 'duration', [], 'N', []);

idx = 1;

% 조합 1
dt = 0.1;
duration = 1000;
N_list = [201, 101, 21];
for i = 1:length(N_list)
    N = N_list(i);
    combinations(idx).dt = dt;
    combinations(idx).duration = duration;
    combinations(idx).N = N;
    idx = idx + 1;
end

% 조합 2
dt_list = [0.2, 1, 2];
duration = 1000;
N = 201;
for i = 1:length(dt_list)
    dt = dt_list(i);
    combinations(idx).dt = dt;
    combinations(idx).duration = duration;
    combinations(idx).N = N;
    idx = idx + 1;
end

% 조합 3
dt = 0.1;
duration_list = [500, 250];
N = 201;
for i = 1:length(duration_list)
    duration = duration_list(i);
    combinations(idx).dt = dt;
    combinations(idx).duration = duration;
    combinations(idx).N = N;
    idx = idx + 1;
end

% 결과를 저장할 struct 배열 초기화
total_results = num_combinations * 10;
result(total_results) = struct('dt', [], 'dur', [], 'N', [], 'V', [], 'I', [], 't', [], 'V_est', []);

index = 1;

% 모든 조합에 대해 데이터 처리
for i = 1:length(combinations)
    dt = combinations(i).dt;
    duration = combinations(i).duration;
    N = combinations(i).N;

    for j = 1:10
        % 원본 데이터 가져오기
        V_orig = data(j).V;
        I_orig = data(j).I;
        t_orig = data(j).t;
        V_est_orig = data(j).V_est;

        % duration에 따른 데이터 리샘플링
        dur = t_orig <= duration;
        V_dur = V_orig(dur);
        I_dur = I_orig(dur);
        t_dur = t_orig(dur);
        V_est_dur = V_est_orig(dur);

        % dt에 따른 데이터 리샘플링
        step = round(dt/0.1);
        V_new = V_dur(1:step:end);
        I_new = I_dur(1:step:end);
        t_new = t_dur(1:step:end);
        V_est_new = V_est_dur(1:step:end);

        % 결과 저장
        result(index).dt = dt;
        result(index).dur = duration;
        result(index).N = N;
        result(index).V = V_new;
        result(index).I = I_new;
        result(index).t = t_new;
        result(index).V_est = V_est_new;
        index = index + 1;
    end
end


save('AS2_2per_new.mat', 'result'); % 파일마다 이름 바꾸기
