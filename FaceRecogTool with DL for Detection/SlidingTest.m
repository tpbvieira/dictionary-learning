%Paulo Henrique de Castro Oliveira
clc; close all; clear;

image=imread('05.pgm','pgm');
matrixOfPatches=sliding(image);

