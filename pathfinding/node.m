classdef node
    properties
        connections;
        weight = -1;
        prevNode;
        visited = false;
    end
    
    methods
        function obj = reset(obj)
            clear obj.prevNode;
            obj.visited = false;
            obj.weight = -1;
        end
    end
end
