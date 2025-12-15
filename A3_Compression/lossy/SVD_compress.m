function model = SVD_compress(img, quality)
    img = double(img);
    [m, n] = size(img);

    [U, S, V] = svd(img, "econ");
    s = diag(S);

    e = cumsum(s .^ 2);
    k = find(e / e(end) >= quality, 1, "first");

    model = struct();
    model.m = m;
    model.n = n;
    model.k = k;

    model.quality_target = quality;
    model.quality_achieved = e(k) / e(end);

    model.U = U(:, 1:k);
    model.s = s(1:k);
    model.V = V(:, 1:k);
end