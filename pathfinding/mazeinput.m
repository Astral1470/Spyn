file = fopen('maze.bin', 'w');

a = [uint8(240), uint8(176), uint8(146), uint8(193), uint8(128), uint8(224), uint8(144), uint8(32), uint8(48), uint8(240), uint8(16), uint8(160), uint8(80), uint8(64), uint8(66), uint8(193), uint8(96), uint8(112), uint8(24), uint8(5), uint8(20)];
fwrite(file, a)

fclose(file);