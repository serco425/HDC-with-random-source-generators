clear all
tic
%Total number of iterations; keep them same for fairness
total_test_size_CONV = 50;

WaitMessage = parfor_wait(total_test_size_CONV, 'Waitbar', true);

%LFSR-BASED CONVENTIONAL HDC
SIMPLE_UPDATE_langRecognition_LFSR();
parfor k = 1:1:total_test_size_CONV
    N = 4;
    D = 8192;
    [iM, langAM] = buildLanguageHV (N, D);
    accuracyCONV(k) = test (iM, langAM, N, D);

    WaitMessage.Send;
    pause(0.002);

end

WaitMessage.Destroy

AVG_CONV = mean(accuracyCONV);
MIN_CONV = min(accuracyCONV);
MAX_CONV = max(accuracyCONV);
STDDEV_CONV = std(accuracyCONV);

clearvars -except accuracyCONV AVG_CONV MIN_CONV MAX_CONV STDDEV_CONV total_test_size_SC D

toc
