%% Main Drum Beat Analysis Script

file_names = {'File1.wav', 'File2.wav', 'File3.wav', 'File4.wav'};
num_instruments = 3; 

master_fig = figure('Name', 'Robust Drum Beat Analysis Results');

for file_idx = 1:length(file_names)
    current_file = file_names{file_idx};
    
    [analysis_table, ODF, time_odf, beat_instants, centroid_features] = ...
        analyze_drum_file(current_file, num_instruments);
    
    if ~isempty(analysis_table)
        
        % --- SUMMARY ADDED HERE ---
        num_beats_detected = size(analysis_table, 1);
        
        % The clustering function sets Instrument_ID to '1' if beats < num_instruments.
        if num_beats_detected >= num_instruments
            num_distinct_instruments = num_instruments;
        else
            % If not enough beats for clustering, we report only 1 instrument found.
            num_distinct_instruments = 1;
        end
        
        fprintf('\n--- SUMMARY for %s ---\n', current_file);
        fprintf('Total Number of Drum Beats Detected: %d\n', num_beats_detected);
        fprintf('Number of Distinct Instruments Found (Target %d): %d\n', num_instruments, num_distinct_instruments);
        fprintf('*** Beat Results Table ***\n');
        % --- END OF SUMMARY ---

        disp(analysis_table);

        % --- Plotting Results ---
        
        % Plot 1: Waveform and Spectrogram (Left Column)
        figure(master_fig);
        
        % Waveform Plot
        ax_wf = subplot(4, 2, 2*file_idx - 1);
        [y, Fs] = audioread(current_file);
        t = (0:length(y)-1) / Fs;
        plot(t, mean(y, 2));
        title(['Waveform: ', current_file]);
        ylabel('Amplitude');
        grid on;
        
        % Spectrogram Plot (using mean(y, 2) to ensure mono for visualization)
        ax_spec = subplot(4, 2, 2*file_idx);
        spectrogram(mean(y, 2), 1024, 512, 1024, Fs, 'yaxis');
        colorbar;
        title(['Spectrogram: ', current_file]);
        xlabel('Time (s)');
        ylabel('Frequency (kHz)');
        
        % Plot 2: Clustering Results (Right Column)
        figure(master_fig);
        ax_clust = subplot(4, 2, 2*file_idx); 
        scatter(beat_instants, centroid_features, 75, analysis_table.Instrument_ID, 'filled', 'MarkerEdgeColor', 'k'); hold on;
        
        % Plot centroid lines if clustering was successful
        if size(analysis_table, 1) >= num_instruments
            [~, C] = kmeans(centroid_features, num_instruments, 'Replicates', 5, 'Start', 'plus');
            C_sorted = sort(C);
            colors = {'r--', 'g--', 'b--'};
            for k = 1:min(num_instruments, length(C_sorted))
                plot(xlim, [C_sorted(k) C_sorted(k)], colors{k}, 'LineWidth', 1);
            end
            colorbar(ax_clust, 'Ticks', 1:num_instruments);
        end
        title(['Clustering Results for ', current_file]);
        xlabel('Time (s)');
        ylabel('Spectral Centroid (Hz)');
        grid on;
        hold off;
    end
end
sgtitle('Integrated Drum Beat Analysis Results');