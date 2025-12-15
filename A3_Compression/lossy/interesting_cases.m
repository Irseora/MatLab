% Visually interesting test cases

qualities = [0.99, 0.95, 0.90, 0.80];

% -------------------------------------------------------------------------
% BLOBS - general shape kept even at .80

figure('Name', 'Blobs');
tiledlayout(1, 5, "Padding", "compact", "TileSpacing", "compact");

original = imread('E:\Repos\MatLab\A3_Compression\test_images\blobs.bmp');
gray = im2uint8(im2gray(original));
nexttile;
imshow(gray, []);
title('Original');

for q = qualities
   model = SVD_compress(gray, q);
   restored = SVD_decompress(model);

   nexttile;
   imshow(restored, []);
   title(sprintf('q=%.0f%% (k=%d)', 100 * q, model.k));
end

sgtitle('Blobs');

% -------------------------------------------------------------------------
% COLORCHECKER - shape kept, "color" lost at lower qualities

figure('Name', 'Colorchecker');
tiledlayout(1, 5, "Padding", "compact", "TileSpacing", "compact");

original = imread('E:\Repos\MatLab\A3_Compression\test_images\Colorchecker.bmp');
gray = im2uint8(im2gray(original));
nexttile;
imshow(gray, []);
title('Original');

for q = qualities
   model = SVD_compress(gray, q);
   restored = SVD_decompress(model);

   nexttile;
   imshow(restored, []);
   title(sprintf('q=%.0f%% (k=%d)', 100 * q, model.k));
end

sgtitle('Colorchecker');

% -------------------------------------------------------------------------
% MACHCOLOR - text turns into reactangles

figure('Name', 'MachColor');
tiledlayout(1, 5, "Padding", "compact", "TileSpacing", "compact");

original = imread('E:\Repos\MatLab\A3_Compression\test_images\MachColor.bmp');
gray = im2uint8(im2gray(original));
nexttile;
imshow(gray, []);
title('Original');

for q = qualities
   model = SVD_compress(gray, q);
   restored = SVD_decompress(model);

   nexttile;
   imshow(restored, []);
   title(sprintf('q=%.0f%% (k=%d)', 100 * q, model.k));
end

sgtitle('MachColor');

% -------------------------------------------------------------------------
% JUPITER - circles turn into squares

figure('Name', 'Jupiter');
tiledlayout(1, 5, "Padding", "compact", "TileSpacing", "compact");

original = imread('E:\Repos\MatLab\A3_Compression\test_images\Jupiter.bmp');
gray = im2uint8(im2gray(original));
nexttile;
imshow(gray, []);
title('Original');

for q = qualities
   model = SVD_compress(gray, q);
   restored = SVD_decompress(model);

   nexttile;
   imshow(restored, []);
   title(sprintf('q=%.0f%% (k=%d)', 100 * q, model.k));
end

sgtitle('Jupiter');

% -------------------------------------------------------------------------
% MALTESE - struggles with large images

figure('Name', 'Maltese');
tiledlayout(1, 5, "Padding", "compact", "TileSpacing", "compact");

original = imread('E:\Repos\MatLab\A3_Compression\test_images\Maltese.bmp');
gray = im2uint8(im2gray(original));
nexttile;
imshow(gray, []);
title('Original');

for q = qualities
   model = SVD_compress(gray, q);
   restored = SVD_decompress(model);

   nexttile;
   imshow(restored, []);
   title(sprintf('q=%.0f%% (k=%d)', 100 * q, model.k));
end

sgtitle('Maltese');