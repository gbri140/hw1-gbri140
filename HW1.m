% Homework 1. Due before class on 9/6/16.

%% Problem 1 - addition with strings

% Fill in the blank space in this section with code that will add 
% the two numbers regardless of variable type. Hint see the matlab
% functions ischar, isnumeric, and str2num. 

%your code should work no matter which of these lines is uncommented. 
x = 3; y = 5; % integers
%x = '3'; y= '5';
%z = x + y;
%your code goes here

if ischar (x)
    x1 = str2num(x);
    y1 = str2num(y);
    z2=x1+y1;
else 
    z=x+y;
end     

%output your answer

%% Problem 2 - our first real biology problem. Open reading frames and nested loops.

%part 1: write a piece of code that creates a random DNA sequence of length
% N (i.e. consisting of the letters ATGC) where we will start with N=500 base pairs (b.p.).
% store the output in a variable
% called rand_seq. Hint: the function randi may be useful. Bonus points if
% you can do this without using a loop.

N = 500; % define sequence length
ATGCdna = ['A', 'T', 'G', 'C'];
rand_seq = ATGCdna(randi(4, 1, N));

%part 2: open reading frames (ORFs) are pieces of DNA that can be
% transcribed and translated. they start with a start codon (ATG) and end with a
% stop codon (TAA, TGA, or TAG). Write a piece of code that finds the longest ORF 
% in your seqeunce rand_seq. Hint: see the function strfind.
ATG = strfind(rand_seq, 'ATG');
stop_codon_positions = [strfind(rand_seq, 'TGA') strfind(rand_seq, 'TAG') strfind(rand_seq, 'TAA')]; 
for i = 1: length (ATG)
   for j =1: length (stop_codon_positions);
  %orf = stop_codon_positions(i) - ATG(i);
  
   end;
end;    
%part 3: copy your code in parts 1 and 2 but place it inside a loop that
% runs 10000 times. Use this repeating operation to determine the probability
% that an sequence of length 500 has an ORF of greater than 50 b.p.

%part 4: copy your code from part 3 but put it inside yet another loop,
% this time over the sequence length N. Plot the probability of having an
% ORF > 50 b.p. as a funciton of the sequence length. 

%part 5: Make sure your results from part 4 are sensible. What features
% must this curve have (hint: what should be the value when is small or when
% N is very large? how should the curve change in between.) Make sure your
% plot looks like this. 

%% problem 3 data input/output and simple analysis

%The file qPCRdata.txt is an actual file that comes from a Roche
%LightCycler qPCR machine. The important columns are the Cp which tells
%you the cycle of amplification and the position which tells you the well
%from the 96 well plate. Each column of the plate has a different gene and
%each row has a different condition. Each gene in done in triplicates so
%columns 1-3 are the same gene, columns 4-6 the same, etc.
%so A1-A3 are gene 1 condition 1, B1-B3 gene 1 condition 2, A4-A6 gene 2
%condition 1, B4-B6 gene2 condition 2 etc. 

% part1: write code to read the Cp data from this file into a vector. You can ignore the last two
% rows with positions beginning with G and H as there were no samples here. 
filename='qPCRdata.txt';
qPCRfile=importdata(filename);
qPCRfile.data(1:72,1);

% Part 2: transform this vector into an array representing the layout of
% the plate. e.g. a 6 row, 12 column array should that data(1,1) = Cp from
% A1, data(1,2) = Cp from A2, data(2,1) = Cp from B1 etc. 

for i=1:6
    originalplate(i,:)=[qPCRfile.data(i*12-11:i*12)'];
end 
% Part 3. The 4th gene in columns 10 - 12 is known as a normalization gene.
% That is, it's should not change between conditions and it is used to normalize 
% the expression values for the others. For the other three
% genes, compute their normalized expression in all  conditions, normalized to condition 1. 
% In other words, the fold change between these conditions and condition 1. The
% formula for this is 2^[Cp0 - CpX - (CpN0 - CpNX)] where Cp0 is the Cp for
% the gene in the 1st condition, CpX is the value of Cp in condition and
% CpN0 and CpNX are the same quantitites for the normalization gene.
% Plot this data in an appropriate way. 
for i=1:6
    for j=1:4
        average(i,j)= mean(originalplate(i,(j*3)-2:(j*3-2)+2));    
    end 
end
for i=1:5
   for  j=1:3   
   normal(i,j)= [2^(average(1,j) - average(i+1,j) - (average(1,4) - average(i+1,4)))];    
end 
end
x=2:6;
plot (x,normal)
legend('id1', 'pai1', 'smad7')
title('qPCR plot')
ylabel('fold change')
xlabel('condtions')


%% problem 4. starting with image data:

%download this zstack of a fly embryo with all the cell membranes marked:
%https://www.dropbox.com/s/atq9j35gtq6jcov/Screenshot%202016-08-25%2013.40.53.png?dl=0

% part 1. each image can be read in with the imread command e.g. img =
% imread('z1.tif'); will store the data in img for the first image. 
% wrote a loop that reads all the data and makes a maximum intensity
% project (that is, each pixel in the image should contain the maximal
% value for that pixel in the entire z-stack. store this in the variable
% max_img
Files = dir('/Users/George/Desktop/Classes/QuantBio/Hw1/flyData/*.tif');
for i=1:384
    filename=strcat('/Users/George/Desktop/Classes/QuantBio/Hw1/flyData/',Files(i).name);
    images{i}=imread(filename);
    
end
max_img=max(cat(3,images{:}),[],3);

% part 2. write a loop that reads all the images and writes them as a
% single 3D image. hint: see the function imwrite and its option 'append' 
%
Files=dir('/Users/George/Desktop/Classes/QuantBio/Hw1/flyData/*.tif');
n=length(Files);
for ii=1:n
    image=imread(['z',num2str(ii),'.tif']);
    imwrite(image,'fileimage.tif','WriteMode','append','Compression','none')
    
end

