function dy = FisherKolmogorovFun(y, alpha, L, k)
    c = y; % Concentrations
    reactionTerm = alpha * c .* (1 - c);
    diffusionTerm = -k*(L * c);
    dy = reactionTerm + diffusionTerm;
end