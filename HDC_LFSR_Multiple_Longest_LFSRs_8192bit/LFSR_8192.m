% Please visit: https://ieeexplore.ieee.org/document/8049760
% and https://en.wikipedia.org/wiki/Linear-feedback_shift_register
% and https://users.ece.cmu.edu/~koopman/lfsr/

function bitstream = LFSR_8192(seed, scalar, N, key)

%--------------------------------------------------------------------------
% N = 8192
% taps:

if N == 8192
    seed_scalar = b2d(flip(seed)); %for comparison, binary to decimal conversion is performed

    %for the initial seed
    if scalar > seed_scalar %comparator
        bitstream(1) = 1;
    else bitstream(1) = -1;
    end

    for i = 1:1:8191 % (2^10-1) Cycle

        if key == ' '
            insertion = xor(xor(xor(seed(1), seed(3)), seed(4)), seed(13));
        elseif key == 'a'
            insertion = xor(xor(xor(seed(1), seed(2)), seed(5)), seed(13));
        elseif key == 'b'
            insertion = xor(xor(xor(seed(2), seed(4)), seed(5)), seed(13));
        elseif key == 'c'
            insertion = xor(xor(xor(seed(1), seed(4)), seed(6)), seed(13));
        elseif key == 'd'
            insertion = xor(xor(xor(seed(2), seed(5)), seed(6)), seed(13));
        elseif key == 'e'
            insertion = xor(xor(xor(xor(xor(seed(1), seed(2)), seed(3)), seed(5)), seed(6)), seed(13));
        elseif key == 'f'
            insertion = xor(xor(xor(seed(1), seed(3)), seed(7)), seed(13));
        elseif key == 'g'
            insertion = xor(xor(xor(seed(2), seed(3)), seed(7)), seed(13));
        elseif key == 'h'
            insertion = xor(xor(xor(xor(xor(seed(1), seed(2)), seed(3)), seed(4)), seed(7)), seed(13));
        elseif key == 'i'
            insertion = xor(xor(xor(seed(2), seed(5)), seed(7)), seed(13));
        elseif key == 'j'
            insertion = xor(xor(xor(xor(xor(seed(1), seed(2)), seed(3)), seed(5)), seed(7)), seed(13));
        elseif key == 'k'
            insertion = xor(xor(xor(xor(xor(seed(1), seed(3)), seed(4)), seed(5)), seed(7)), seed(13));
        elseif key == 'l'
            insertion = xor(xor(xor(xor(xor(seed(2), seed(3)), seed(4)), seed(5)), seed(7)), seed(13));
        elseif key == 'm'
            insertion = xor(xor(xor(seed(1), seed(6)), seed(7)), seed(13));
        elseif key == 'n'
            insertion = xor(xor(xor(seed(3), seed(6)), seed(7)), seed(13));
        elseif key == 'o'
            insertion = xor(xor(xor(seed(5), seed(6)), seed(7)), seed(13));
        elseif key == 'p'
            insertion = xor(xor(xor(xor(xor(seed(1), seed(4)), seed(5)), seed(6)), seed(7)), seed(13));
        elseif key == 'q'
            insertion = xor(xor(xor(seed(2), seed(3)), seed(8)), seed(13));
        elseif key == 'r'
            insertion = xor(xor(xor(seed(2), seed(4)), seed(8)), seed(13));
        elseif key == 's'
            insertion = xor(xor(xor(seed(3), seed(5)), seed(8)), seed(13));
        elseif key == 't'
            insertion = xor(xor(xor(xor(xor(seed(1), seed(2)), seed(3)), seed(5)), seed(8)), seed(13));
        elseif key == 'u'
            insertion = xor(xor(xor(xor(xor(seed(1), seed(3)), seed(4)), seed(5)), seed(8)), seed(13));
        elseif key == 'v'
            insertion = xor(xor(xor(seed(1), seed(6)), seed(8)), seed(13));
        elseif key == 'w'
            insertion = xor(xor(xor(xor(xor(seed(1), seed(2)), seed(5)), seed(6)), seed(8)), seed(13));
        elseif key == 'x'
            insertion = xor(xor(xor(xor(xor(seed(1), seed(3)), seed(5)), seed(6)), seed(8)), seed(13));
        elseif key == 'y'
            insertion = xor(xor(xor(xor(xor(seed(3), seed(4)), seed(5)), seed(6)), seed(8)), seed(13));
        elseif key == 'z'
            insertion = xor(xor(xor(seed(3), seed(7)), seed(8)), seed(13));
        else
            insertion = xor(xor(xor(xor(xor(seed(1), seed(2)), seed(4)), seed(7)), seed(8)), seed(13));
        end


        seed(13) = seed(12); %after the first cycle each LFSR value is obtained; I still keep to name it as "seed"
        seed(12) = seed(11);
        seed(11) = seed(10);
        seed(10) = seed(9);
        seed(9) = seed(8);
        seed(8) = seed(7);
        seed(7) = seed(6);
        seed(6) = seed(5);
        seed(5) = seed(4);
        seed(4) = seed(3);
        seed(3) = seed(2);
        seed(2) = seed(1);
        seed(1) = insertion;

        seed_scalar = b2d(flip(seed)); %converting for the current decimal seed
        if scalar > seed_scalar %comparator
            bitstream(i+1) = 1;
        else bitstream(i+1) = -1;
        end

    end
end
end





