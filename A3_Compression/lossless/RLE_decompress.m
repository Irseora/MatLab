function decompressed_data = RLE_decompress(compressed_data, m, n)
    m = double(m);
    n = double(n);

    % Handle empty input
    if isempty(compressed_data)
        decompressed_data = zeros(m, n, 'uint8');
        return;
    end

    values = compressed_data(1, :);
    lengths = compressed_data(2, :);

    % Compute output size
    total_length = sum(double(lengths));
    reconstructed_vector = zeros(total_length, 1, 'uint8');
    
    % Fills each run back into the vector
    current_index = 1;
    for i = 1 : numel(values)
        val = uint8(values(i));
        len = double(lengths(i));

        reconstructed_vector(current_index : current_index + len - 1) = val;
        current_index = current_index + len;
    end

    % Reshape back to original size
    decompressed_data = reshape(reconstructed_vector, m, n);
end