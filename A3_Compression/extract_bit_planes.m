% Separates a grayscale image into its 8 bit-planes
function BitPlanes = extract_bit_planes(img, num_bits, big_title)
    % Init
    BitPlanes = cell(1, num_bits);
    figure('Name', big_title);

    % Stores every binary plane (LSB -> MSB)
    for k = 1 : num_bits
        plane = bitget(img, k);
        BitPlanes{k} = plane;

        % Display planes
        subplot(2, 4, k);
        imshow(BitPlanes{k}, []);
        if k == 1
            title('Bit-Plane 1 (LSB)');
        elseif k == num_bits
            title(['Bit-Plane ', num2str(k), ' (MSB)']);
        else
            title(['Bit-Plane ', num2str(k)]);
        end

        sgtitle(big_title)
    end
end