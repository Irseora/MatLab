function reconstructed = SVD_decompress(model)
    Uk = double(model.U);
    Vk = double(model.V);
    sk = double(model.s(:)');   % Reshape singular values into row vector

    % Reconstruction without building a diagonal matrix, for speed
    reconstructed = (Uk .* sk) * Vk';

    % Round to nearest integer pixel values
    reconstructed = round(reconstructed);

    % Clamp values to valid 8 bit range
    reconstructed = min(max(reconstructed, 0), 255);
    
    reconstructed = uint8(reconstructed);
end