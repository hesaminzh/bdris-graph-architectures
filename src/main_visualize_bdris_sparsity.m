% This script constructs and visualize the susceptance matrix B of different BD-RIS architectures.
% Hesam Nezhadmohammad
% 2025/11/28 (last revised)
clc;
clear all;
close all;

% addpath('./function/');

rng(7); % reproducibility
NI = 8; % number of BD-RIS elements, choose small to visualize patterns
NT = 4; % number of BS antennas
K  = 4; % number of users
Gs = 2; % group size (for group-conn.)
q_band  = 3; % band/stem width
arch_list = {'fully', 'group', 'single', 'tridiagonal', 'arrowhead', 'band','stem'};
% arch_list = {'stem'};

% Create a general complex B (it later becomes real susceptance matrix in project_B_to_arch)
B = randn(NI) + 1i*randn(NI);

fprintf('Matrix size NI=%d, group size=%d\n', NI, Gs);

for iArch = 1:numel(arch_list)
    arch = arch_list{iArch};
    % Build sparsity sets S_i for B (depends on architecture)
    switch arch
        case 'fully'
            S_sets = arch_sparsity_sets_all(NI, 'fully', []);
        case 'group'
            S_sets = arch_sparsity_sets_all(NI, 'group', struct('groups',[],'group_size', Gs));
        case 'single'
            S_sets = arch_sparsity_sets_all(NI, 'single', []);
        case 'tridiagonal'
            S_sets = arch_sparsity_sets_all(NI, 'tridiagonal', []);
        case 'arrowhead'
            S_sets = arch_sparsity_sets_all(NI, 'arrowhead', []);
        case 'stem'
            % q_band = compute_q_band_stem(NI, NT, ones(K,1));
            S_sets = arch_sparsity_sets_all(NI, 'stem', struct('q',q_band));
        case 'band'
            % q_band = compute_q_band_stem(NI, NT, ones(K,1));
            S_sets = arch_sparsity_sets_all(NI, 'band', struct('q',q_band));
        otherwise
            error('Unknown architecture: %s', arch);
    end

    fprintf('\n-- Architecture: %s --\n', arch);
    Bp = project_B_to_arch(B, S_sets);


    fig = figure('Color','w','defaultaxesfontsize',12);
    hold on;

    % Plot zeros as faint dots
    [row0, col0] = find(Bp == 0);
    plot(col0, row0, '.', 'Color', [0.8 0.8 0.8], 'MarkerSize', 12);

    % Plot nonzeros as strong dots
    [row1, col1] = find(Bp ~= 0);
    plot(col1, row1, 'k.', 'MarkerSize', 16);

    axis ij; axis equal tight;
    % axis ij; axis equal;
    xlabel('Column index'); ylabel('Row index');
    % title(sprintf('Zero vs nonzero elements in %s', arch), 'Interpreter','latex');

    % Dummy plots
    h0 = plot(NaN, NaN, 'k.', 'MarkerSize', 14);
    h1 = plot(NaN, NaN, '.', 'Color', [0.8,0.8,0.8], 'MarkerSize', 14);

    legend([h0 h1], {'Nonzero elements', 'Zero elements'}, 'Location', 'southoutside', 'FontSize', 12, 'Orientation', 'horizontal');

    print(fig, sprintf('Bpattern_%s.png', arch), '-dpng', '-r300');



end
