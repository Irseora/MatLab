function model = SVD_compress(img, quality)
    % Convert to double, because SVD is a float operation
    img = double(img);
    [m, n] = size(img);

    % Perform SVD
    % "econ" saves memory & time by not fully allocating
    [U, S, V] = svd(img, "econ");
    
    % Extract singular values as a vector
    s = diag(S);

    % Cumulative energy
    e = cumsum(s .^ 2);

    % Finds smallest k that hits target quality
    k = find(e / e(end) >= quality, 1, "first");

    model = struct();
    model.m = m;
    model.n = n;
    model.k = k;

    model.quality_target = quality;
    model.quality_achieved = e(k) / e(end);

    % Truncated SVD factors based on k
    model.U = U(:, 1:k);
    model.s = s(1:k);
    model.V = V(:, 1:k);
end