function x=qRandSample(list,dims)

i = randi(length(list), dims); 
x = list(i); 

end