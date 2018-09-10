%Paulo Henrique de Castro Oliveira
clc;close all; clear;

image=imread('05.pgm');
image=imresize(image,[114 90])
[M T]=size(image);

matrixOfpatches = sliding(image);