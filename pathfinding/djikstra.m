allNodes = [];
currentNode = startNode;
startNode.weight = 0;


while currentNode ~= endNode
    for connect = currentNode.connections
        if(~linkedNode.visited)
            linkedNode = unvisitedNodes(unvisitedNodes == connect);
            linkedNode.weight = Min(connect.weight + currentNode.weight, linkedNode.weight);
        end
    end
    currentNode.visited = true;
    currentNode = min(allNodes);
    
end 




function minDistanceNode = min(nodes)
    minDistanceNode = nodes(0);
    for n = nodes
        if n.visited == false
            if n.weight ~= -1 && n.weight < minDistanceNode.weight || minDistanceNode.weight == -1
               minDistanceNode = n;
            end
        end
    end
end