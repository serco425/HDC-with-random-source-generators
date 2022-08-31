tic
parfor k = 1:1:1

% SIMPLE_UPDATE_langRecognition();
% N = 4;
% D = 8;
% [iM, langAM] = buildLanguageHV (N, D);
% accuracyCONV = test (iM, langAM, N, D);
% 
% clearvars -except accuracyCONV 

SC_UPDATE_langRecognition();
N = 4;
D = 128;
threshold = 0.5;
[space, a, b, c, d, e, f, g, h, i1, j1, k1, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, other] = sobolproc(D);
[iM, langAM] = buildLanguageHV (threshold, N, D, space, a, b, c, d, e, f, g, h, i1, j1, k1, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, other);
accuracySC = test (threshold, iM, langAM, N, D, space, a, b, c, d, e, f, g, h, i1, j1, k1, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, other);

end
toc