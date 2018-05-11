function [shortestPath] = shortestPath (graph, currentPath, remainingNodes, shortestPath)

    if (isEmpty(remainingNodes))
        currentPath = [currentPath, graph(1)];
        if (isEmpty(shortestPath))
            shortestPath = currentPath;
        elseif (pathLength(graph,currentPath) < pathLength(graph,shortestPath))
            shortestPath = currentPath;
        end
    else
        for i = 1:length(remainingNodes)
            nextNode = remainingNodes(i);
            nextRemainingNodes = remainingNodes;
            nextRemainingNodes(i) = [];
            currentPath = [currentPath; nextNode];
            shortestPath = shortestPath(graph, currentPath, nextRemainingNodes, shortestPath);
        end
    end
    
end