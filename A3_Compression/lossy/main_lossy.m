% Init
inputDir = "E:\Repos\MatLab\A3_Compression\test_images";
imgs = {};
labels = {};

% Get synthetic test images
[tests, names] = make_synthetic_tests();
for i = 1 : numel(tests)
    imgs{end + 1} = uint8(tests{i});
    labels{end + 1} = "SYN_" + names{i};
end

% Get real images
exts = ["*.png", "*.bmp", "*.jpg"];
files = [];
for e = exts
    files = [files; dir(fullfile(inputDir, e))];
end
for i = 1 : numel(files)
    p = fullfile(files(i).folder, files(i).name);
    img = imread(p);

    % Drop alpha channel
    if ndims(img) == 3 && size(img, 3) == 4
        img = img(:, :, 1 : 3);
    end

    % Convert to grayscale
    gray = im2uint8(im2gray(img));
    imgs{end + 1} = gray;
    labels{end + 1} = "FILE_" + string(files(i).name);
end

% Picking randpm images for visualization
num_show = 3;
vis_idx = randperm(numel(imgs), num_show);

% Qualities at which to test
qualities = [0.99, 0.95, 0.90, 0.80];

% Open log file for writing
log = fopen("lossy/log.txt", "w");
fprintf(log, "starting run...\n");

% -------------------------------------------------------------------------

for q = qualities
    fprintf(log, "\n=== quality target = %.2f ===\n", q);
    fprintf("\n=== quality target = %.2f ===\n", q);

    vis_original = cell(1, num_show);
    vis_restored = cell(1, num_show);
    vis_labels   = strings(1, num_show);

    for i = 1 : numel(imgs)
        gray = uint8(imgs{i});
        [m, n] = size(gray);
        original_bits = m * n * 8;  % Original size in bits

        % Start timer
        start_time = tic;

        % Compress at current quality
        model = SVD_compress(gray, q);

        % Store factors as single to represent compressed payload better
        model.U = single(model.U);      % 32 bit floats
        model.V = single(model.V);
        model.s = single(model.s);

        % Decompress
        restored = SVD_decompress(model);

        elapsed_time = toc(start_time);

        % PSNR (quality metric)
        err = double(gray) - double(restored);
        mse = mean(err(:) .^ 2);
        if mse == 0
            psnr_val = Inf;
        else
            psnr_val = 10 * log10(255^2 / mse);
        end

        % CR
        compressed_bits = ...
            (numel(model.U) + numel(model.V) + numel(model.s)) * 32;
        CR = original_bits / compressed_bits;

        % Logging
        fprintf(log, "[%3d/%3d] %-30s | k=%4d | achieved=%.2f%% | CR=%.4f | PSNR=%6.2f | time=%.4fs\n", ...
            i, numel(imgs), labels{i}, model.k, 100*model.quality_achieved, CR, psnr_val, elapsed_time);

        fprintf("[%3d/%3d] %-30s | k=%4d | achieved=%.2f%% | CR=%.4f | PSNR=%6.2f | time=%.4fs\n", ...
            i, numel(imgs), labels{i}, model.k, 100*model.quality_achieved, CR, psnr_val, elapsed_time);

        % Save for visualization
        pos = find(vis_idx == i, 1);
        if ~isempty(pos)
            vis_original{pos} = gray;
            vis_restored{pos} = restored;
            vis_labels(pos) = labels{i} + " | k=" + model.k;
        end
    end

    % Visualization
    figure('Name', sprintf("Lossy SVD: q=%.2f", q));
    tiledlayout(num_show, 2, 'Padding', 'compact', 'TileSpacing', 'compact');
    for i = 1 : num_show
        nexttile;
        imshow(vis_original{i}, []);
        title(vis_labels(i), 'Interpreter', 'none');

        nexttile;
        imshow(vis_restored{i}, []);
        title('Restored');
    end
    sgtitle(sprintf('Lossy SVD (quality target = %.2f)', q));
end

% -------------------------------------------------------------------------

fclose(log);