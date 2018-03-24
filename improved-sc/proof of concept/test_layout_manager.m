clc
close all
clear classes

viewer = DummyHandle;

str_panel = {'Dummy'};
str_control = {{'popupmenu', 'x', @(x) num2str(x.x), @(x) x.x, @st_x, 200, 400}};

fig_mgr = sc_layout.FigureLayoutManager(gcf);

i = 1;
j = 1;

panel = uipanel('Title', str_panel{i});
panel_mgr = sc_layout.PanelLayoutManager(panel);

tmp_control = str_control{i};

ui_object = sc_tool.GuiManager.create_ui_object(tmp_control{1});
sc_tool.ViewerListener(viewer, ui_object, tmp_control{2:5});

panel_mgr.add(ui_object, 400);

panel_mgr.trim();
fig_mgr.add(panel, 400);

