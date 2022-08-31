function message = SC_UPDATE_langRecognition
assignin('base','lookupItemMemeory',@lookupItemMemeory);
assignin('base','genRandomHV',@genRandomHV);
assignin('base','cosAngle',@cosAngle);
assignin('base','computeSumHV', @computeSumHV);
assignin('base','buildLanguageHV', @buildLanguageHV);
assignin('base','binarizeHV', @binarizeHV);
assignin('base','binarizeLanguageHV', @binarizeLanguageHV);
assignin('base','test', @test);
assignin('base','sobolproc', @sobolproc);
message='Done importing functions to workspace';
end

function [space, a, b, c, d, e, f, g, h, i1, j1, k1, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, other] = sobolproc(D)
sobolseq2 = net(sobolset(28),(D));
% % 
% space = (sobolseq2(:,825));
% a = (sobolseq2(:,1070));
% b = (sobolseq2(:,833));
% c = (sobolseq2(:,251));
% d = (sobolseq2(:,1064));
% e = (sobolseq2(:,623));
% f = (sobolseq2(:,827));
% g = (sobolseq2(:,317));
% h = (sobolseq2(:,353));
% i1 = (sobolseq2(:,296));
% j1 = (sobolseq2(:,503));
% k1 = (sobolseq2(:,586));
% l = (sobolseq2(:,851));
% m = (sobolseq2(:,1068));
% n = (sobolseq2(:,241));
% o = (sobolseq2(:,766));
% p = (sobolseq2(:,752));
% q = (sobolseq2(:,154));
% r = (sobolseq2(:,621));
% s = (sobolseq2(:,155));
% t = (sobolseq2(:,736));
% u = (sobolseq2(:,601));
% v = (sobolseq2(:,519));
% w = (sobolseq2(:,784));
% x = (sobolseq2(:,397));
% y = (sobolseq2(:,10));
% z = (sobolseq2(:,531));
% other = (sobolseq2(:,309));
% 
space = (sobolseq2(:,1));
a = (sobolseq2(:,2));
b = (sobolseq2(:,3));
c = (sobolseq2(:,4));
d = (sobolseq2(:,5));
e = (sobolseq2(:,6));
f = (sobolseq2(:,7));
g = (sobolseq2(:,8));
h = (sobolseq2(:,9));
i1 = (sobolseq2(:,10));
j1 = (sobolseq2(:,11));
k1 = (sobolseq2(:,12));
l = (sobolseq2(:,13));
m = (sobolseq2(:,14));
n = (sobolseq2(:,15));
o = (sobolseq2(:,16));
p = (sobolseq2(:,17));
q = (sobolseq2(:,18));
r = (sobolseq2(:,19));
s = (sobolseq2(:,20));
t = (sobolseq2(:,21));
u = (sobolseq2(:,22));
v = (sobolseq2(:,23));
w = (sobolseq2(:,24));
x = (sobolseq2(:,25));
y = (sobolseq2(:,26));
z = (sobolseq2(:,27));
other = (sobolseq2(:,28));

end

function randomHV = genRandomHV(threshold, D, space, a, b, c, d, e, f, g, h, i1, j1, k1, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, other, key)
if mod(D,2)
    disp ('Dimension is odd!!');
else
    %         randomIndex = randperm (D);
    %         randomHV (randomIndex(1 : D/2)) = 1;
    %         randomHV (randomIndex(D/2+1 : D)) = -1;
    
    %Old code:
    %
    %        random_1_1111 = randperm(1111);
    %        rand_index_sobol = random_1_1111(1); %random first indice
    %        sobolseq_rand = (sobolseq2(:,rand_index_sobol));
    
    %New code:
    %
    if key == ' '
        sobolseq_rand = space;
    elseif key == 'a'
        sobolseq_rand = a;
    elseif key == 'b'
        sobolseq_rand = b;
    elseif key == 'c'
        sobolseq_rand = c;
    elseif key == 'd'
        sobolseq_rand = d;
    elseif key == 'e'
        sobolseq_rand = e;
    elseif key == 'f'
        sobolseq_rand = f;
    elseif key == 'g'
        sobolseq_rand = g;
    elseif key == 'h'
        sobolseq_rand = h;
    elseif key == 'i'
        sobolseq_rand = i1;
    elseif key == 'j'
        sobolseq_rand = j1;
    elseif key == 'k'
        sobolseq_rand = k1;
    elseif key == 'l'
        sobolseq_rand = l;
    elseif key == 'm'
        sobolseq_rand = m;
    elseif key == 'n'
        sobolseq_rand = n;
    elseif key == 'o'
        sobolseq_rand = o;
    elseif key == 'p'
        sobolseq_rand = p;
    elseif key == 'q'
        sobolseq_rand = q;
    elseif key == 'r'
        sobolseq_rand = r;
    elseif key == 's'
        sobolseq_rand = s;
    elseif key == 't'
        sobolseq_rand = t;
    elseif key == 'u'
        sobolseq_rand = u;
    elseif key == 'v'
        sobolseq_rand = v;
    elseif key == 'w'
        sobolseq_rand = w;
    elseif key == 'x'
        sobolseq_rand = x;
    elseif key == 'y'
        sobolseq_rand = y;
    elseif key == 'z'
        sobolseq_rand = z;
    else
        sobolseq_rand = other;
    end
    
   
    tic %Timing Starts Timing Starts Timing Starts Timing Starts Timing Starts
    for i=1:1:(D)
        if threshold <= sobolseq_rand(i,1)
            randomHV(i) = -1; %BS is the bitstream
        end
        if threshold > sobolseq_rand(i,1)
            randomHV(i) = 1;
        end
    end
    
    
end
end

function [itemMemory, randomHV] = lookupItemMemeory(threshold, itemMemory, key, D, space, a, b, c, d, e, f, g, h, i1, j1, k1, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, other)
if itemMemory.isKey (key)
    randomHV = itemMemory (key);
    %disp ('found key');
else
    itemMemory(key) = genRandomHV (threshold, D, space, a, b, c, d, e, f, g, h, i1, j1, k1, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, other, key);
    randomHV = itemMemory (key);
end
end

function cosAngle = cosAngle (u, v)
cosAngle = dot(u,v)/(norm(u)*norm(v));
end

function [itemMemory, sumHV] = computeSumHV (threshold, buffer, itemMemory, N, D, space, a, b, c, d, e, f, g, h, i1, j1, k1, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, other)
%init
block = zeros (N,D);
sumHV = zeros (1,D);

for numItems =1:1:length(buffer)
    %read a key
    key = buffer(numItems);
    
    %while (isletter(char(key)) == 0 && isspace(char(key)) == 0)
    %    numItems = numItems + 1;
    %    key = buffer(numItems);
    %end
    
    %shift read vectors
    block = circshift (block, [1,1]);
    [itemMemory, block(1,:)] = lookupItemMemeory (threshold, itemMemory, key, D, space, a, b, c, d, e, f, g, h, i1, j1, k1, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, other);
    
    %
    if numItems >= N
        nGrams = block(1,:);
        for i = 2:1:N
            nGrams = nGrams .* block(i,:); %element-wise multiplication
        end
        sumHV = sumHV + nGrams;
    end
end

end

function v = binarizeHV (v)
threshold = 0;
for i = 1 : 1 : length (v)
    if v (i) > threshold
        v (i) = 1;
    else
        v (i) = -1;
    end
end
end

function langAM = binarizeLanguageHV (langAM)
langLabels = {'afr', 'bul', 'ces', 'dan', 'nld', 'deu', 'eng', 'est', 'fin', 'fra', 'ell', 'hun', 'ita', 'lav', 'lit', 'pol', 'por', 'ron', 'slk', 'slv', 'spa', 'swe'};

for j = 1 : 1 : length (langLabels)
    v = langAM (char(langLabels (j)));
    langAM (char(langLabels (j))) = binarizeHV (v);
end

end

function [iM, langAM] = buildLanguageHV (threshold, N, D, space, a, b, c, d, e, f, g, h, i1, j1, k1, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, other)
iM = containers.Map;
langAM = containers.Map;
langLabels = {'afr', 'bul', 'ces', 'dan', 'nld', 'deu', 'eng', 'est', 'fin', 'fra', 'ell', 'hun', 'ita', 'lav', 'lit', 'pol', 'por', 'ron', 'slk', 'slv', 'spa', 'swe'};

currentFile = mfilename( 'fullpath' );
[pathstr,~,~] = fileparts( currentFile );
%addpath( fullfile( pathstr, 'Sub' ) );


for i = 1:1:length(langLabels)
    fileAddress = strcat(pathstr, '\training_texts_SC\', langLabels (i),'.txt');    fileID = fopen (char(fileAddress), 'r');
    buffer = fscanf (fileID,'%c');
    fclose (fileID);
    %fprintf('Loaded traning language file %s\n',char(fileAddress));
    
    [iM, langHV] = computeSumHV (threshold, buffer, iM, N, D, space, a, b, c, d, e, f, g, h, i1, j1, k1, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, other);
    langAM (char(langLabels (i))) = langHV;
end
end

function accuracy = test (threshold, iM, langAM, N, D, space, a, b, c, d, e, f, g, h, i1, j1, k1, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, other)
total = 0;
correct = 0;
langLabels = {'afr', 'bul', 'ces', 'dan', 'nld', 'deu', 'eng', 'est', 'fin', 'fra', 'ell', 'hun', 'ita', 'lav', 'lit', 'pol', 'por', 'ron', 'slk', 'slv', 'spa', 'swe'};
langMap = containers.Map;
langMap ('af') = 'afr';
langMap ('bg') = 'bul';
langMap ('cs') = 'ces';
langMap ('da') = 'dan';
langMap ('nl') = 'nld';
langMap ('de') = 'deu';
langMap ('en') = 'eng';
langMap ('et') = 'est';
langMap ('fi') = 'fin';
langMap ('fr') = 'fra';
langMap ('el') = 'ell';
langMap ('hu') = 'hun';
langMap ('it') = 'ita';
langMap ('lv') = 'lav';
langMap ('lt') = 'lit';
langMap ('pl') = 'pol';
langMap ('pt') = 'por';
langMap ('ro') = 'ron';
langMap ('sk') = 'slk';
langMap ('sl') = 'slv';
langMap ('es') = 'spa';
langMap ('sv') = 'swe';

currentFile = mfilename( 'fullpath' );
[pathstr,~,~] = fileparts( currentFile );

fileList = dir (strcat(pathstr, '\testing_texts_SC\*.txt'));
for i=1: 1: length(fileList)
    actualLabel = char (fileList(i).name);
    actualLabel = actualLabel(1:2);
    
    fileAddress = strcat(pathstr, '\testing_texts_SC\', fileList(i).name);
    fileID = fopen (char(fileAddress), 'r');
    buffer = fscanf (fileID, '%c');
    fclose (fileID);
    %fprintf ('Loaded testing text file %s\n', char(fileAddress));
    
    [iMn, textHV] = computeSumHV (threshold, buffer, iM, N, D, space, a, b, c, d, e, f, g, h, i1, j1, k1, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, other);
    textHV = binarizeHV (textHV);
    if iM ~= iMn
        %fprintf ('\n>>>>>   NEW UNSEEN ITEM IN TEST FILE   <<<<\n');
        exit;
    else
        maxAngle = -1;
        for l = 1:1:length(langLabels)
            angle = cosAngle(langAM (char(langLabels (l))), textHV);
            if (angle > maxAngle)
                maxAngle = angle;
                predicLang = char (langLabels (l));
            end
        end
        if predicLang == langMap(actualLabel)
            correct = correct + 1;
        else
            %fprintf ('%s --> %s\n', langMap(actualLabel), predicLang);
        end
        total = total + 1;
    end
end
accuracy = correct / total;
end
