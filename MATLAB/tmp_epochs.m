epochs = [172 : 176];
nE = length(epochs);

S = struct;
for e = 1:nE
    epoch_name_a = sprintf('S%da', epochs(e));
    epoch_name_b = sprintf('S%db', epochs(e));
    S.(epoch_name_a) = eval(epoch_name_a);
    S.(epoch_name_a) = S.(epoch_name_a).loss;
    S.(epoch_name_b) = eval(epoch_name_b);
    S.(epoch_name_b) = S.(epoch_name_b).loss;
    
end
%%
track_a = zeros(nE, nIdxs);
track_b = zeros(nE, nIdxs);
    
idxs = 1:10;
nIdxs = length(idxs);

for i = 1:length(idxs)
    for e = 1:nE

        epoch_name_a = sprintf('S%da', epochs(e));
        epoch_name_b = sprintf('S%db', epochs(e));
    
        track_a(e, i) = S.(epoch_name_a)(idxs(i));
        track_b(e, i) = S.(epoch_name_b)(idxs(i));
    end
end

figure(4); clf; hold on;
plot(epochs, track_a, 'bo-');
plot(epochs, track_b, 'rs--');

