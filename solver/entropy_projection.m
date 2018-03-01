function d_new = entropy_projection(d_cur, g_cur, L_ell1)
    g_entropy = 1 + log(d_cur);

    % update point
    d_shift = (1/L_ell1)*g_cur - g_entropy;
    d_new = exp(-d_shift);
    d_new = d_new/sum(d_new);
end