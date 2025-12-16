function [compressed_data, m, n] = RLE_compress(bit_plane)
    numeric_plane = uint8(bit_plane);
    [m, n] = size(numeric_plane);
    linear_data = numeric_plane(:);     % Flatten to column vector

    values = zeros(1, 0, 'uint32');
    lengths = zeros(1, 0, 'uint32');

    % Handles empty input
    L = numel(linear_data);
    if L == 0
        compressed_data = zeros(2, 0, 'uint32');
        return;
    end

    % Scans the vector and forms the runs
    i = 1;      % Start of current run
    while i <= L
        current_value = linear_data(i);

        j = i;
        while j <= L && linear_data(j) == current_value
            j = j + 1;
        end
        count = j - i;      % Run length

        % Save run
        values(end + 1) = uint32(current_value);
        lengths(end + 1) = uint32(count);

        % Jump to next run
        i = j;
    end

    % Pack into output
    compressed_data = [values; lengths];
end