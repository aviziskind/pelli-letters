function plotLetterPowerSpectrum(fontName)
%%
    if nargin < 1
        fontName = 'Bookman';
    end
    %%
    allLet = loadLetters(fontName, 24);
    allLet = addMarginToPow2(allLet, 5);

    let = allLet(:,:,1);
    

    imgf = fftshift(fft2(let));


end