function shortestPath = findShortestPath (graph, currentPath, remainingNodes, shortestPath)

    if (isempty(remainingNodes))
        currentPath = [currentPath; 1];
        if (isempty(shortestPath))
            shortestPath = currentPath;
        elseif (pathLength(graph,currentPath) < pathLength(graph,shortestPath))
            shortestPath = currentPath;
        end
    else
        for i = 1:length(remainingNodes)
            nextNode = remainingNodes(i);
            nextRemainingNodes = remainingNodes;
            nextRemainingNodes(i) = [];
            nextCurrentPath = [currentPath; nextNode];
            shortestPath = findShortestPath(graph, nextCurrentPath, nextRemainingNodes, shortestPath);
        end
    end
    
end