function S_sets = arch_sparsity_sets_all(M, architecture, opts)
% ARCH_SPARSITY_SETS_ALL  Build {S_i} index sets encoding a BD-RIS architecture.
% Paper mapping (graph modeling of BD-RIS):
%   - Architecture ↔ undirected graph G with adjacency A_G (symmetric 0-1, zero diag).
%   - Off-diagonal support of susceptance B matches A_G:  A_G(n,m)=1  <=>  B(n,m)≠0 (n≠m).
%   - For pp-ADMM B-update linearization, we stack only the UPPER-TRI variables:
%         S_i = { i } ∪ { m : m>i and A_G(i,m)=1 }.
%     (diagonal always allowed).
% References: Beyond-Diagonal RIS in Multiuser MIMO: Graph Theoretic Modeling and Optimal Architectures With Low Complexity (https://ieeexplore.ieee.org/document/11162566)
% Hesam Nezhadmohammad
% 2025/11/28 (last revised)


    % --- Build adjacency A according to 'architecture' or use provided A/edges
    A = zeros(M);  % symmetric 0-1 adjacency, zero diagonal

    switch lower(architecture)

        % --- Baselines -----------------------------------------------------
        case {'diagonal','single'}
            % No interconnections (E = \emptyset).
            % A stays all-zero.

        case 'fully'
            % Complete graph (fully-connected).
            A = ones(M) - eye(M);

        case 'group'
            % Cluster graph: fully-connected within each group; block-diagonal A.
            % Options:
            %  (a) opts.groups: length-M vector of group labels in {1..G}
            %  (b) opts.group_size: contiguous groups of given size (last truncated)
            if ~isempty(opts.groups)
                gvec = opts.groups(:);
                G = max(gvec);
                for g = 1:G
                    idx = find(gvec==g).';
                    A(idx,idx) = 1; A(idx,idx) = A(idx,idx) - eye(numel(idx));
                end
            elseif ~isempty(opts.group_size)
                Gs = opts.group_size;
                for i = 1:M
                    g = floor((i-1)/Gs);
                    idx = (g*Gs+1):min((g+1)*Gs, M);
                    A(idx,idx) = 1; A(idx,idx) = A(idx,idx) - eye(numel(idx));
                end
            else
                error('group: provide opts.groups or opts.group_size.');
            end

        % --- Named graph families (tree / band / stem / forest) -----------
        case {'tridiagonal','path'}   % path graph (tree-connected special case)
            for i = 1:M-1
                A(i,i+1)=1; A(i+1,i)=1;
            end

        case 'arrowhead'              % star graph (tree-connected special case)
            c = 1;                    % take port 1 as center (any center is OK; permutation isomorphism)
            A(c,2:M) = 1; A(2:M,c) = 1;

        case 'tree'
            % Generic tree: supply opts.edges as undirected edge list, size (M-1) x 2.
            E = opts.edges;
            if isempty(E), error('tree: provide opts.edges (M-1 x 2)'); end
            for k = 1:size(E,1)
                u = E(k,1); v = E(k,2);
                A(u,v)=1; A(v,u)=1;
            end
            % (No cycle checks here; assume valid tree.)

        case 'band'
            % q-step path graph (band-connected RIS): connect |i-j| <= q (off-diagonal).
            % Paper: q = 2L-1 can match fully-connected performance (Theorem 1 corollary).
            q = opts.q;
            if isempty(q), error('band: provide opts.q (bandwidth).'); end
            for i = 1:M
                j1 = max(1, i-q); j2 = min(M, i+q);
                A(i, j1:j2) = 1; A(i,i)=0;
            end
            A = triu(A,1); A = A + A.';  % ensure symmetric, zero diag

        case 'stem'
            % q-center graph (stem-connected RIS): first q are “centers” connected to all others;
            % remaining vertices connect only to centers (no leaf-to-leaf edges).
            q = opts.q;
            if isempty(q), error('stem: provide opts.q (stem width / #centers).'); end
            q = min(q, M);
            if q >= 1
                % centers 1..q fully connected among themselves
                A(1:q,1:q) = 1 - eye(q);
                % each center connects to all non-centers
                A(1:q, q+1:M) = 1;
                A(q+1:M, 1:q) = 1;
                % non-centers (q+1..M) do not connect among themselves
            end

        case 'forest'
            % Forest-connected (block of trees): provide groups and per-group edges.
            % opts.forest_groups : cell {g} with vertex indices of group g
            % opts.tree_edges    : cell {g} with edge list (Ng-1 x 2) over those indices
            if isempty(opts.forest_groups) || isempty(opts.tree_edges)
                error('forest: provide opts.forest_groups and opts.tree_edges (cell arrays).');
            end
            G = numel(opts.forest_groups);
            for g = 1:G
                idx = opts.forest_groups{g}(:).';
                Eg  = opts.tree_edges{g};
                for k = 1:size(Eg,1)
                    u = Eg(k,1); v = Eg(k,2);
                    A(u,v)=1; A(v,u)=1;
                end
                % Ensure no cross-group edges:
                A(idx, setdiff(1:M, idx)) = 0;
                A(setdiff(1:M, idx), idx) = 0;
            end

        % --- Arbitrary custom graph (mask or edges) ------------------------
        case {'adjacency','custom','edges'}
            if ~isempty(opts.A)
                A = opts.A;
            elseif ~isempty(opts.edges)
                for k = 1:size(opts.edges,1)
                    u = opts.edges(k,1); v = opts.edges(k,2);
                    A(u,v)=1; A(v,u)=1;
                end
            else
                error('adjacency/custom/edges: provide opts.A or opts.edges.');
            end

        otherwise
            error('Unknown architecture "%s".', architecture);
    end

    % --- Clean-up: enforce symmetric 0-1, zero diagonal
    A = (A>0);
    A = triu(A,1) + triu(A,1).';  % symmetric, 0/1, no diag

    % --- Convert adjacency to upper-tri sparsity sets {S_i}
    S_sets = cell(M,1);
    for i = 1:M
        upper_neighbors = find(A(i, i+1:M)) + i;   % neighbors with index > i
        S_sets{i} = [i, upper_neighbors];          % include diagonal by construction
    end
end





%%%% Simple application

% % Fully:
% S = arch_sparsity_sets(8, 'fully', struct());
%
% % Group (contiguous groups of size 3):
% S = arch_sparsity_sets(10, 'group', struct('group_size',3));
%
% % Group (explicit labels):
% labels = [1 1 1 2 2 2 3 3 3 3];
% S = arch_sparsity_sets(10, 'group', struct('groups', labels));
%
% % Tridiagonal (path):
% S = arch_sparsity_sets(8, 'tridiagonal', struct());
%
% % Arrowhead (star):
% S = arch_sparsity_sets(8, 'arrowhead', struct());
%
% % Band-connected with q = 3:
% S = arch_sparsity_sets(12, 'band', struct('q',3));
%
% % Stem-connected with q = 2 centers:
% S = arch_sparsity_sets(10, 'stem', struct('q',2));
%
% % Tree from edges:
% E = [1 2; 2 3; 2 4; 4 5; 5 6; 3 7; 7 8];
% S = arch_sparsity_sets(8, 'tree', struct('edges',E));
%
% % Forest: two disjoint trees over {1..5} and {6..10}
% Fg = {1:5, 6:10};
% Eg = { [1 2; 2 3; 3 4; 4 5], [6 7; 7 8; 8 9; 9 10] };
% S = arch_sparsity_sets(10, 'forest', struct('forest_groups',Fg,'tree_edges',Eg));
%
% % Arbitrary custom mask:
% A = zeros(6); A(1,[2 3])=1; A(2,5)=1; A(4,6)=1; A = A + A.';  % symmetric 0-1
% S = arch_sparsity_sets(6, 'adjacency', struct('A',A));
%
%
