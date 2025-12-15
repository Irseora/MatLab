function img = from_gray_code(gray)
    img = gray;

    img = bitxor(img, bitshift(img, -1));
    img = bitxor(img, bitshift(img, -2));
    img = bitxor(img, bitshift(img, -4));
end