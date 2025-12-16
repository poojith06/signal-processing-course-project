
function [analysis_table, odf, time_odf, beat_time_instants, centroid_features] = analyze_drum_file(filename, num_instruments)

    WINDOW_SIZE = 1024;
    OVERLAP = 512;
    MIN_PEAK_DISTANCE_S = 0.1;
    ADAPTIVE_THRESHOLD_RATIO = 0.2;
    DURATION_ENERGY_RATIO = 0.1;
    SEGMENT_DURATION_S = 0.05;

    analysis_table = []; 
    odf = []; time_odf = []; beat_time_instants = []; centroid_features = [];

    try
        [y, Fs] = audioread(filename);
        y = mean(y, 2); 
        num_samples = length(y);
    catch
        return;
    end
    
    try
        afe = audioFeatureExtractor('SampleRate', Fs, 'Window', hann(WINDOW_SIZE), 'OverlapLength', OVERLAP, 'spectralFlux', true);
        features = extract(afe, y);
        odf = features(:, 1); 
        hop_time = OVERLAP / Fs;
        time_odf = (0:length(odf)-1) * hop_time;

        adaptive_threshold = ADAPTIVE_THRESHOLD_RATIO * max(odf);
        
        min_peak_dist_samples = round(MIN_PEAK_DISTANCE_S / hop_time);
        [~, beat_indices] = findpeaks(odf, 'MinPeakHeight', adaptive_threshold, 'MinPeakDistance', min_peak_dist_samples);
        beat_time_instants = time_odf(beat_indices);
        num_beats = length(beat_time_instants);

    catch
        return;
    end
    
    if num_beats == 0
        return; 
    end

    hit_durations = zeros(num_beats, 1);
    centroid_features = zeros(num_beats, 1);
    segment_length = round(SEGMENT_DURATION_S * Fs);
    
    for i = 1:num_beats
        start_sample = round(beat_time_instants(i) * Fs);
        
        end_search_sample = min(num_samples, start_sample + round(0.5 * Fs));
        peak_amp = max(abs(y(start_sample:min(num_samples, start_sample + round(0.01 * Fs)))));
        decay_threshold = peak_amp * DURATION_ENERGY_RATIO;
        decay_sample = start_sample;
        while decay_sample < end_search_sample && abs(y(decay_sample)) > decay_threshold
            decay_sample = decay_sample + 1;
        end
        hit_durations(i) = (decay_sample - start_sample) / Fs;

        end_sample = min(num_samples, start_sample + segment_length);
        segment = y(start_sample:end_sample);
        
        if isempty(segment) || length(segment) < 2
            centroid_features(i) = 0; 
        else
            sc = spectralCentroid(segment, Fs);
            centroid_features(i) = sc(1);
        end
    end

    if num_beats >= num_instruments
        cluster_idx = kmeans(centroid_features, num_instruments, 'Replicates', 5, 'Start', 'plus');
    else
        cluster_idx = ones(num_beats, 1); 
    end

    analysis_table = table(beat_time_instants', hit_durations, cluster_idx, ...
        'VariableNames', {'Onset_Time_s', 'Duration_s', 'Instrument_ID'});

end