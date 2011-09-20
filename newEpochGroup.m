function epochGroup = newEpochGroup(parentGroup, sources)
    handles.epochGroup = [];
    
    handles.parentGroup = parentGroup;
    handles.sourceRoot = sources;
    
    handles.rigNames = {'A', 'B', 'C'};
    lastChosenRig = getpref('SymphonyEpochGroup', 'LastChosenRigName', 'A');
    rigValue = find(strcmp(handles.rigNames, lastChosenRig));
    if isempty(rigValue)
        rigValue = 1;
    end
    
    handles.figure = dialog(...
        'Units', 'points', ...
        'Name', 'New Epoch Group', ...
        'Position', centerWindowOnScreen(450, 400), ...
        'WindowKeyPressFcn', @(hObject, eventdata)keyPressCallback(hObject, eventdata, guidata(hObject)), ...
        'Tag', 'figure');
    
    % Parent group controls
    uicontrol(...
        'Parent', handles.figure,...
        'Units', 'points', ...
        'FontSize', 12,...
        'HorizontalAlignment', 'right', ...
        'Position', [10 360 100 18], ...
        'String',  'Parent group:',...
        'Style', 'text');
    handles.parentGroupText = uicontrol(...
        'Parent', handles.figure,...
        'Units', 'points', ...
        'FontSize', 12,...
        'HorizontalAlignment', 'left', ...
        'Position', [115 360 325 18], ...
        'String',  '', ...
        'Style', 'text', ...
        'Tag', 'parentGroupText');
    
    % Output path controls
    uicontrol(...
        'Parent', handles.figure,...
        'Units', 'points', ...
        'FontSize', 12,...
        'HorizontalAlignment', 'right', ...
        'Position', [10 330 100 18], ...
        'String',  'Output path:',...
        'Style', 'text');
    handles.outputPathEdit = uicontrol(...
        'Parent', handles.figure,...
        'Units', 'points', ...
        'FontSize', 12,...
        'HorizontalAlignment', 'left', ...
        'Position', [115 330 295 26], ...
        'String',  getpref('SymphonyEpochGroup', 'LastChosenOutputPath', ''),...
        'Style', 'edit', ...
        'Tag', 'outputPathEdit');
    handles.outputPathButton = uicontrol(...
        'Parent', handles.figure,...
        'Units', 'points', ...
        'Callback', @(hObject,eventdata)pickOutputPath(hObject,eventdata,guidata(hObject)), ...
        'Position', [412 333 25 20], ...
        'String', '...', ...
        'Tag', 'cancelButton');
    
    % Label controls
    uicontrol(...
        'Parent', handles.figure,...
        'Units', 'points', ...
        'FontSize', 12,...
        'HorizontalAlignment', 'right', ...
        'Position', [10 300 100 18], ...
        'String',  'Label:',...
        'Style', 'text');
    handles.labelEdit = uicontrol(...
        'Parent', handles.figure,...
        'Units', 'points', ...
        'FontSize', 12,...
        'HorizontalAlignment', 'left', ...
        'Position', [115 300 325 26], ...
        'String',  getpref('SymphonyEpochGroup', 'LastChosenLabel', ''),...
        'Style', 'edit', ...
        'Tag', 'labelEdit');
    
    % Keyword controls
    uicontrol(...
        'Parent', handles.figure,...
        'Units', 'points', ...
        'FontSize', 12,...
        'HorizontalAlignment', 'right', ...
        'Position', [10 270 100 18], ...
        'String',  'Keywords:',...
        'Style', 'text');
    handles.keywordsEdit = uicontrol(...
        'Parent', handles.figure,...
        'Units', 'points', ...
        'FontSize', 12,...
        'HorizontalAlignment', 'left', ...
        'Position', [115 270 325 26], ...
        'String',  getpref('SymphonyEpochGroup', 'LastChosenKeywords', ''),...
        'Style', 'edit', ...
        'Tag', 'keywordsEdit');
    
    % Source controls
    uicontrol(...
        'Parent', handles.figure, ...
        'Units', 'points', ...
        'FontSize', 12, ...
        'HorizontalAlignment', 'right', ...
        'Position', [10 242 100 18], ...
        'String',  'Source:', ...
        'Style', 'text');
    rootNode = uitreenode('v0', handles.sourceRoot.path(), handles.sourceRoot.name, [], false);
    rootNode.UserData = handles.sourceRoot;
    [handles.sourceTree, treeContainer] = uitree('v0', ...
        'Parent', handles.figure, ...
        'Position', [119 100 319 160], ...
        'Root', rootNode, ...
        'ExpandFcn', {@sourceHierarchyExpandFcn, handles}, ...
        'SelectionChangeFcn', {@sourceHierarchySelectFcn, handles});
    set(treeContainer, 'Units', 'points', ...
        'Position', [119 100 319 160]);
    
    handles.mouseIDText = uicontrol(...
        'Parent', handles.figure, ...
        'Units', 'points', ...
        'FontSize', 12, ...
        'HorizontalAlignment', 'right', ...
        'Position', [10 70 100 18], ...
        'String', 'Mouse ID:', ...
        'Style', 'text', ...
        'Tag', 'text9');
    
    handles.mouseIDEdit = uicontrol(...
        'Parent', handles.figure, ...
        'Units', 'points', ...
        'FontSize', 12, ...
        'HorizontalAlignment', 'left', ...
        'Position', [115 70 125 22], ...
        'String', getpref('SymphonyEpochGroup', 'LastChosenMouseID', ''), ...
        'Style', 'edit', ...
        'Tag', 'mouseIDEdit');
    
    handles.cellIDText = uicontrol(...
        'Parent', handles.figure, ...
        'Units', 'points', ...
        'FontSize', 12, ...
        'HorizontalAlignment', 'right', ...
        'Position', [250 70 60 18], ...
        'String', 'Cell ID:', ...
        'Style', 'text', ...
        'Tag', 'text9');
    
    handles.cellIDEdit = uicontrol(...
        'Parent', handles.figure, ...
        'Units', 'points', ...
        'FontSize', 12, ...
        'HorizontalAlignment', 'left', ...
        'Position', [315 70 125 22], ...
        'String', getpref('SymphonyEpochGroup', 'LastChosenCellID', ''), ...
        'Style', 'edit', ...
        'Tag', 'cellIDEdit');
    
    handles.rigText = uicontrol(...
        'Parent', handles.figure, ...
        'Units', 'points', ...
        'FontSize', 12, ...
        'HorizontalAlignment', 'right', ...
        'Position', [10 40 100 18], ...
        'String', 'Rig:', ...
        'Style', 'text', ...
        'Tag', 'mouseIDText');
    
    handles.rigPopup = uicontrol(...
        'Parent', handles.figure, ...
        'Units', 'points', ...
        'Position', [115 40 75 22], ...
        'String', handles.rigNames, ...
        'Style', 'popupmenu', ...
        'Value', rigValue, ...
        'Tag', 'rigPopup');
 
    handles.cancelButton = uicontrol(...
        'Parent', handles.figure,...
        'Units', 'points', ...
        'Callback', @(hObject,eventdata)cancelNewGroup(hObject,eventdata,guidata(hObject)), ...
        'Position', [450-10-56-10-56 10 56 20], ...
        'String', 'Cancel', ...
        'Tag', 'cancelButton');
    
    handles.saveButton = uicontrol(...
        'Parent', handles.figure,...
        'Units', 'points', ...
        'Callback', @(hObject,eventdata)saveNewGroup(hObject,eventdata,guidata(hObject)), ...
        'Position', [450-10-56 10 56 20], ...
        'String', 'Save', ...
        'Tag', 'saveButton');
    
    guidata(handles.figure, handles);
    
    % Restore the last chosen source if it's still available.
    sourcePath = getpref('SymphonyEpochGroup', 'LastChosenSourcePath', '');
    if isempty(sourcePath)
        lastChosenSource = handles.sourceRoot;
    else
        index = find([sourcePath ':'] == ':', 1, 'first');
        lastChosenSource = handles.sourceRoot.descendantAtPath(sourcePath(index + 1:end));
    end
    
    % Pre-expand all of the sources in the tree.
    % TODO: remember which ones the user closes?
    tree = handles.sourceTree.getTree;
    row = 0;
    while row < tree.getRowCount()
        tree.expandRow(row);
        
        % Select this row if it was the last one chosen.
        rowSource = tree.getPathForRow(row).getLastPathComponent.handle.UserData;
        if isequal(rowSource, lastChosenSource)
            tree.setSelectionRow(row);
        end
        
        row = row + 1;
        drawnow;
    end
    
    if isempty(parentGroup)
        set(handles.parentGroupText, 'String', '(None)');
    else
        set(handles.parentGroupText, 'String', parentGroup.label);
        
        % A child group can only define a label and keywords.
        set(handles.outputPathEdit, 'Enable', 'off');
        set(handles.outputPathButton, 'Enable', 'off');
        set(handles.mouseIDEdit, 'Enable', 'off');
        set(handles.cellIDEdit, 'Enable', 'off');
        set(handles.rigPopup, 'Enable', 'off');
    end
    
    % Wait until the user clicks the cancel or save button.
    uiwait
    
    handles = guidata(handles.figure);
    epochGroup = handles.epochGroup;
    
    close(handles.figure);
end


function nodes = sourceHierarchyExpandFcn(~, sourcePath, handles)
    index = find([sourcePath ':'] == ':', 1, 'first');
    node = handles.sourceRoot.descendantAtPath(sourcePath(index + 1:end));
    for i = 1:length(node.childSources)
        child = node.childSources(i);
        if isempty(node.parentSource)% || isempty(node.parentSource.parentSource)
            nodes(i) = uitreenode('v0', child.path(), child.name, [], isempty(child.childSources)); %#ok<AGROW>
        else
            nodes(i) = uitreenode('v0', child.path(), ['<html><font color="gray">' child.name '</font></html>'], [], isempty(child.childSources)); %#ok<AGROW>
        end
        nodes(i).UserData = child; %#ok<AGROW>
    end
end


function sourceHierarchySelectFcn(tree, ~, ~)
    selectedNodes = tree.getSelectedNodes;
    if ~isempty(selectedNodes)
        if selectedNodes(1).getLevel == 2
            beep
            tree.setSelectedNode(selectedNodes(1).getParent());
        end
    end
end

function keyPressCallback(hObject, eventdata, handles)
    if strcmp(eventdata.Key, 'return')
        % Move focus off of any edit text so the changes can be seen.
        uicontrol(handles.saveButton);
        
        saveNewGroup(hObject, eventdata, handles);
    elseif strcmp(eventdata.Key, 'escape')
        cancelNewGroup(hObject, eventdata, handles);
    end
end


function pickOutputPath(~, ~, handles)
    pickedDir = uigetdir();
    
    if pickedDir ~= 0
        set(handles.outputPathEdit, 'String', pickedDir)
    end
end


function cancelNewGroup(~, ~, ~)
    uiresume
end


function saveNewGroup(~, ~, handles)
    % TODO: validate inputs
    
    epochGroup = EpochGroup(handles.parentGroup);
    epochGroup.outputPath = get(handles.outputPathEdit, 'String');
    epochGroup.label = get(handles.labelEdit, 'String');
    epochGroup.keywords = get(handles.keywordsEdit, 'String');
    if isempty(handles.parentGroup)
        rigName = handles.rigNames{get(handles.rigPopup, 'Value')};
        cellID = get(handles.cellIDEdit, 'String');
        cellName = [datestr(now, 'mmddyy') rigName 'c' cellID];
        selectedSourceNode = handles.sourceTree.getSelectedNodes();
        cellSource = Source(cellName, selectedSourceNode(1).handle.UserData);
        
        epochGroup.source = cellSource;
        epochGroup.setUserProperty('mouseID', get(handles.mouseIDEdit, 'String'));
        epochGroup.setUserProperty('cellID', cellID);
        epochGroup.setUserProperty('rigName', rigName);
    else
        epochGroup.source = [];
    end
    
    handles.epochGroup = epochGroup;
    guidata(handles.figure, handles);
    
    % Remember these settings for the next time a group is created.
    setpref('SymphonyEpochGroup', 'LastChosenLabel', handles.epochGroup.label)
    setpref('SymphonyEpochGroup', 'LastChosenKeywords', handles.epochGroup.keywords)
    if isempty(handles.parentGroup)
        setpref('SymphonyEpochGroup', 'LastChosenOutputPath', handles.epochGroup.outputPath)
        setpref('SymphonyEpochGroup', 'LastChosenSourcePath', handles.epochGroup.source.parentSource.path())    % remember the tissue, not the cell (?)
        setpref('SymphonyEpochGroup', 'LastChosenMouseID', handles.epochGroup.userProperty('mouseID'))
        setpref('SymphonyEpochGroup', 'LastChosenCellID', handles.epochGroup.userProperty('cellID'))
        setpref('SymphonyEpochGroup', 'LastChosenRigName', handles.epochGroup.userProperty('rigName'))
    end
    
    uiresume
end
