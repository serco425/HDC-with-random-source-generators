% Please visit: https://ieeexplore.ieee.org/document/8049760
% and https://en.wikipedia.org/wiki/Linear-feedback_shift_register

function bitstream = LFSR1(seed, scalar, N)

%--------------------------------------------------------------------------
% N = 8
% initial seed: [true true false]
% taps: 3 2
if N == 8
    seed_scalar = b2d(flip(seed));
    %seed_scalar = bi2de(seed, 'right-msb'); %for comparison, binary to decimal conversion is performed
    
    %for the initial seed
    if scalar > seed_scalar %comparator
        bitstream(1) = 1;
    else bitstream(1) = -1;
    end
    
    for i = 1:1:7 % (2^3-1) Cycle
        insertion = xor(seed(3), seed(2)); %tap
        
        seed(3) = seed(2); %after the first cycle each LFSR value is obtained; I still keep to name it as "seed"
        seed(2) = seed(1);
        seed(1) = insertion;
        
        %seed_binary_1s_0s = matches(seed, 'true');
        
        seed_scalar = b2d(flip(seed));
        %seed_scalar = bi2de(seed, 'right-msb'); %converting for the current decimal seed
        if scalar > seed_scalar %comparator
            bitstream(i+1) = 1;
        else bitstream(i+1) = -1;
        end
    end
end

%--------------------------------------------------------------------------
% N = 16
% initial seed: [true true false false]
% taps: 4 3
if N == 16
    seed_scalar = b2d(flip(seed));
    %seed_scalar = bi2de(seed, 'right-msb'); %for comparison, binary to decimal conversion is performed
    
    %for the initial seed
    if scalar > seed_scalar %comparator
        bitstream(1) = 1;
    else bitstream(1) = -1;
    end
    
    for i = 1:1:15 % (2^4-1) Cycle
        insertion = xor(seed(4), seed(3)); %tap
        
        seed(4) = seed(3); %after the first cycle each LFSR value is obtained; I still keep to name it as "seed"
        seed(3) = seed(2);
        seed(2) = seed(1);
        seed(1) = insertion;
        
        seed_scalar = b2d(flip(seed));
        %seed_scalar = bi2de(seed, 'right-msb'); %converting for the current decimal seed
        if scalar > seed_scalar %comparator
            bitstream(i+1) = 1;
        else bitstream(i+1) = -1;
        end
    end
end

%--------------------------------------------------------------------------
% N = 32
% initial seed: [true false true false false]
% taps: 5 3
if N == 32
    seed_scalar = b2d(flip(seed));
    %seed_scalar = bi2de(seed, 'right-msb'); %for comparison, binary to decimal conversion is performed
    
    %for the initial seed
    if scalar > seed_scalar %comparator
        bitstream(1) = 1;
    else bitstream(1) = -1;
    end
    
    for i = 1:1:31 % (2^5-1) Cycle
        insertion = xor(seed(5), seed(3)); %tap
        
        seed(5) = seed(4); %after the first cycle each LFSR value is obtained; I still keep to name it as "seed"
        seed(4) = seed(3);
        seed(3) = seed(2);
        seed(2) = seed(1);
        seed(1) = insertion;
        
        seed_scalar = b2d(flip(seed));
        %seed_scalar = bi2de(seed, 'right-msb'); %converting for the current decimal seed
        if scalar > seed_scalar %comparator
            bitstream(i+1) = 1;
        else bitstream(i+1) = -1;
        end
    end
end

%--------------------------------------------------------------------------
% N = 64
% initial seed: [true true false false false false]
% taps: 6 5
if N == 64
    seed_scalar = b2d(flip(seed));
    %seed_scalar = bi2de(seed, 'right-msb'); %for comparison, binary to decimal conversion is performed
    
    %for the initial seed
    if scalar > seed_scalar %comparator
        bitstream(1) = 1;
    else bitstream(1) = -1;
    end
    
    for i = 1:1:63 % (2^6-1) Cycle
        insertion = xor(xor(xor(seed(2), seed(3)), seed(5)), seed(6));%tap
        
        seed(6) = seed(5); %after the first cycle each LFSR value is obtained; I still keep to name it as "seed"
        seed(5) = seed(4);
        seed(4) = seed(3);
        seed(3) = seed(2);
        seed(2) = seed(1);
        seed(1) = insertion;
        
        seed_scalar = b2d(flip(seed));
        %seed_scalar = bi2de(seed, 'right-msb'); %converting for the current decimal seed
        if scalar > seed_scalar %comparator
            bitstream(i+1) = 1;
        else bitstream(i+1) = -1;
        end
    end
end


%--------------------------------------------------------------------------
% N = 128
% initial seed: [true true false false false false false]
% taps: 7 6
if N == 128
    seed_scalar = b2d(flip(seed));
    %seed_scalar = bi2de(seed, 'right-msb'); %for comparison, binary to decimal conversion is performed
    
    %for the initial seed
    if scalar > seed_scalar %comparator
        bitstream(1) = 1;
    else bitstream(1) = -1;
    end
    
    for i = 1:1:127 % (2^7-1) Cycle
        insertion = xor(seed(7), seed(3)); %tap
        
        seed(7) = seed(6); %after the first cycle each LFSR value is obtained; I still keep to name it as "seed"
        seed(6) = seed(5);
        seed(5) = seed(4);
        seed(4) = seed(3);
        seed(3) = seed(2);
        seed(2) = seed(1);
        seed(1) = insertion;
        
        seed_scalar = b2d(flip(seed));
        %seed_scalar = bi2de(seed, 'right-msb'); %converting for the current decimal seed
        if scalar > seed_scalar %comparator
            bitstream(i+1) = 1;
        else bitstream(i+1) = -1;
        end
    end
end

%--------------------------------------------------------------------------
% N = 256
% initial seed: [true false true true true false false false]
% taps: 8 6 5 4
if N == 256
    seed_scalar = b2d(flip(seed)); %for comparison, binary to decimal conversion is performed
    
    %for the initial seed
    if scalar > seed_scalar %comparator
        bitstream(1) = 1;
    else bitstream(1) = -1;
    end
    
    for i = 1:1:255 % (2^8-1) Cycle
        insertion = xor(xor(xor(seed(8), seed(5)), seed(3)), seed(1));
                
        seed(8) = seed(7); %after the first cycle each LFSR value is obtained; I still keep to name it as "seed"
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

%--------------------------------------------------------------------------
% N = 512
% initial seed: [true false false false true false false false false]
% taps: 9 5
if N == 512
    seed_scalar = b2d(flip(seed)); %for comparison, binary to decimal conversion is performed
    
    %for the initial seed
    if scalar > seed_scalar %comparator
        bitstream(1) = 1;
    else bitstream(1) = -1;
    end
    
    for i = 1:1:511 % (2^9-1) Cycle
        insertion = xor(seed(9), seed(5)); %tap
        
        seed(9) = seed(8); %after the first cycle each LFSR value is obtained; I still keep to name it as "seed"
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

%--------------------------------------------------------------------------
% N = 1024
% initial seed: [true false false true false false false false false false]
% taps: 10 7

if N == 1024
    seed_scalar = b2d(flip(seed)); %for comparison, binary to decimal conversion is performed
    
    %for the initial seed
    if scalar > seed_scalar %comparator
        bitstream(1) = 1;
    else bitstream(1) = -1;
    end
    
    for i = 1:1:1023 % (2^10-1) Cycle
        insertion = xor(xor(xor(seed(10), seed(5)), seed(2)), seed(1)); %tap
        
        seed(10) = seed(9); %after the first cycle each LFSR value is obtained; I still keep to name it as "seed"
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


%--------------------------------------------------------------------------
% N = 2048
% taps: 1 11

if N == 2048
    seed_scalar = b2d(flip(seed)); %for comparison, binary to decimal conversion is performed
    
    %for the initial seed
    if scalar > seed_scalar %comparator
        bitstream(1) = 1;
    else bitstream(1) = -1;
    end
    
    for i = 1:1:2047 % (2^10-1) Cycle
        insertion = xor(xor(xor(seed(11), seed(4)), seed(2)), seed(1)); %tap
        seed(11) = seed(10); %after the first cycle each LFSR value is obtained; I still keep to name it as "seed"
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





%--------------------------------------------------------------------------
% N = 4096

if N == 4096
    seed_scalar = b2d(flip(seed)); %for comparison, binary to decimal conversion is performed
    
    %for the initial seed
    if scalar > seed_scalar %comparator
        bitstream(1) = true;
    else bitstream(1) = false;
    end
    
    for i = 1:1:4095 
        insertion = xor(xor(xor(seed(1), seed(4)), seed(6)), seed(12));

        seed(12) = seed(11);
        seed(11) = seed(10); %after the first cycle each LFSR value is obtained; I still keep to name it as "seed"
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
        insertion = xor(xor(xor(seed(1), seed(3)), seed(4)), seed(13)); %tap
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



