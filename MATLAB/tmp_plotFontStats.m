
S = loadLetters;
%%
fn = fieldnames(S);
for i = 1:length(fn)
    Si = S.(fn{i});
    if isfield(Si, 'letters')
        S2.(fn{i}).letters = Si.letters;
    else
        Ssum.(fn{i}) = Si;
    end

end

%%
figure(10); clf; hold on;
fn_sum = fieldnames(Ssum);
fn_sum_raw = unique(cellfun(@(s) getRawFontName(s, 1), fn_sum, 'un', 0));
h = [];
for i = 1:length(fn_sum_raw)
    Si = Ssum.(fn_sum_raw{i});
    h(i) = plot(Si.sizes, Si.k_heights, [color_s(i) marker(i) '-' ]);
end

legend(h, fn_sum_raw)
