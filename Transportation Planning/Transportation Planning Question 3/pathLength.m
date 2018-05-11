function pathLength = pathLength(graph, path)

    pathLength = 0;
    
    for i = 1:(length(path) - 1)
        currentNode = path(i);
        nextNode = path(i+1);
        pathLength = pathLength + graph(currentNode,nextNode);
    end

end