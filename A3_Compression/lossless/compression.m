[tests, names] = make_synthetic_tests();

num_bits = 8;
CRs = zeros(numel(tests), 1);
ok  = false(numel(tests), 1);

figure;

for t = 1 : numel(tests)
    gray = uint8(im2gray(tests{t}));
    [m, n] = size(gray);
    original_size_bits = m * n * 8;

    gray_coded = to_gray_code(gray);

    total_compressed_bits = 0;
    decompressed_planes = cell(1, num_bits);

    for i = 1 : num_bits
        plane = bitget(gray_coded, i);
        [compressed_data, m_plane, n_plane] = RLE_compress(plane);

        info = whos('compressed_data');
        total_compressed_bits = total_compressed_bits + info.bytes * 8;

        decompressed_planes{i} = RLE_decompress(compressed_data, m_plane, n_plane);
    end

    restored_gray_coded = zeros(m, n, 'uint8');
    for i = 1 : num_bits
        restored_plane = uint8(decompressed_planes{i}) * uint8(2^(i - 1));
        restored_gray_coded = restored_gray_coded + restored_plane;
    end

    restored = from_gray_code(restored_gray_coded);

    ok(t) = isequal(gray, restored);
    CRs(t) = original_size_bits / total_compressed_bits;

    fprintf("[%2d/%2d] %-22s | lossless=%d | CR=%.4f\n", ...
        t, numel(tests), names{t}, ok(t), CRs(t));
end