num_bits = 8;
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

    gray = im2uint8(im2gray(img));
    imgs{end + 1} = gray;
    labels{end + 1} = "FILE_" + string(files(i).name);
end

% Picking random images for visualization
num_show = 3;
vis_idx = randperm(numel(imgs), num_show);
vis_original = cell(1, num_show);
vis_restored = cell(1, num_show);
vis_labels = strings(1, num_show);

log = fopen("lossless/log.txt", "w");
fprintf(log, "Starting run...\n");

% -------------------------------------------------------------------------

for i = 1 : numel(imgs)
    gray = uint8(imgs{i});
    [m, n] = size(gray);
    original_bits = m * n * 8;

    start_time = tic;

    % Apply gray code
    gray_coded = to_gray_code(gray);

    % Compress & decompress each bit-plane
    total_compressed_bits = 0;
    decompressed_planes = cell(1, num_bits);

    for b = 1 : num_bits
        % Compress bit-planes
        plane = bitget(gray_coded, b);
        [compressed_data, pm, pn] = RLE_compress(plane);

        info = whos('compressed_data');
        total_compressed_bits = total_compressed_bits + info.bytes * 8;

        % Decompress bit-planes
        decompressed_planes{b} = RLE_decompress(compressed_data, pm, pn);
    end

    % Rebuilding gray-coded image from decompressed planes
    restored_graycode = zeros(m, n, 'uint8');
    for b = 1 : num_bits
        restored_graycode = restored_graycode ...
            + uint8(decompressed_planes{b}) * uint8(2^(b - 1));
    end

    % Undo gray coding
    restored = from_gray_code(restored_graycode);

    % Metrics
    elapsed_time = toc(start_time);
    lossless = isequal(gray, restored);
    CR = original_bits / total_compressed_bits;

    fprintf(log, "[%3d/%3d] %-30s | lossless=%d | CR=%.4f | time = %.4f s\n", ...
        i, numel(imgs), labels{i}, lossless, CR, elapsed_time);
    fprintf("[%3d/%3d] %-30s | lossless=%d | CR=%.4f | time = %.4f s\n", ...
        i, numel(imgs), labels{i}, lossless, CR, elapsed_time);

    % Save for visualization
    pos = find(vis_idx == i, 1);
    if ~isempty(pos)
        vis_original{pos} = gray;
        vis_restored{pos} = restored;
        vis_labels(pos) = labels{i};
    end
end

% -------------------------------------------------------------------------

fclose(log);

% Visualization
figure('Name', 'Original vs Restored');
tiledlayout(num_show, 2, 'Padding', 'compact', 'TileSpacing', 'compact');
for i = 1 : num_show
    nexttile;
    imshow(vis_original{i}, []);
    title(vis_labels(i), 'Interpreter', 'none');

    nexttile;
    imshow(vis_restored{i}, []);
    title('Restored');
end
sgtitle('Original vs Restored');