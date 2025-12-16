function GrayCode = to_gray_code(img)
    % Right bit shift by 1 = floor(img / 2)
    img_shifted = bitshift(img, -1);

    % XOR original with shifted versionw
    GrayCode = bitxor(img, img_shifted);
end