function Bp = project_B_to_arch(B, S_sets)
% Hesam Nezhadmohammad
% 2025/11/28 (last revised)
    M = size(B,1);
    Bp = zeros(M);
    for i = 1:M
        J = S_sets{i};
        J = J(J >= i);               % upper-tri only
        if ~isempty(J)
            Bp(i,J) = B(i,J);
        end
    end
    Bp = triu(Bp) + triu(Bp,1)';     % symmetrize
    Bp = real(Bp);
end

