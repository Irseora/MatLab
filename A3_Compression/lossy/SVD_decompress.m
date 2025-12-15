function reconstructed = SVD_decompress(model)
    Uk = double(model.U);
    Vk = double(model.V);
    sk = double(model.s(:)');

    reconstructed = (Uk .* sk) * Vk';

    reconstructed = round(reconstructed);
    reconstructed = min(max(reconstructed, 0), 255);
    reconstructed = uint8(reconstructed);
end