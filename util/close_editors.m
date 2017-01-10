function close_editors
%CLOSE_EDITORS Close all open editor windows from command prompt

Editor = com.mathworks.mlservices.MLEditorServices;
Editor.getEditorApplication.close

end