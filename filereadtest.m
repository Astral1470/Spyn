file = fopen('maze.bin');
mazeSize = [6,3];

maze = fread(file, 18);
maze = reshape(maze, mazeSize);
tiles = fread(file);

a = de2bi(maze(1, 1), 8, 'left-msb'); % n s e w walls, n s e w stops

for i=1:size(maze, 1)
    for j=1:size(maze, 2)
        
    end
end


fclose(file);