function [tests, names] = make_synthetic_tests()
    tests = {};
    names = {};

    tests{end+1} = uint8(0);                  names{end+1} = "1x1 black";
    tests{end+1} = uint8(255);                names{end+1} = "1x1 white";
    tests{end+1} = uint8([0 255; 255 0]);     names{end+1} = "2x2 checker";

    tests{end+1} = uint8(zeros(257,513));     names{end+1} = "odd uniform black";
    tests{end+1} = uint8(128*ones(257,513));  names{end+1} = "odd uniform 128";

    tests{end+1} = uint8([zeros(256,256), 255*ones(256,256)]);
    names{end+1} = "half black half white";

    tests{end+1} = uint8(repmat([0 255], 256, 256));
    names{end+1} = "1px stripes";

    tests{end+1} = uint8(randi([0,255], 256, 256));
    names{end+1} = "random noise";

    tests{end+1} = uint8(repmat(uint8(0:255), 256, 1));
    names{end+1} = "horizontal gradient";

    tests{end+1} = uint8(repmat(uint8((0:255)'), 1, 256));
    names{end+1} = "vertical gradient";
end