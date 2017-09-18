function varargout = somOutputGUI(varargin)
% SOMOUTPUTGUI MATLAB code for somOutputGUI.fig
%      SOMOUTPUTGUI, by itself, creates a new SOMOUTPUTGUI or raises the existing
%      singleton*.
%
%      H = SOMOUTPUTGUI returns the handle to a new SOMOUTPUTGUI or the handle to
%      the existing singleton*.
%
%      SOMOUTPUTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOMOUTPUTGUI.M with the given input arguments.
%
%      SOMOUTPUTGUI('Property','Value',...) creates a new SOMOUTPUTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before somOutputGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to somOutputGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help somOutputGUI

% Last Modified by GUIDE v2.5 08-Aug-2017 20:46:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @somOutputGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @somOutputGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before somOutputGUI is made visible.
function somOutputGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to somOutputGUI (see VARARGIN)

% Choose default command line output for somOutputGUI
handles.output = hObject;

selectedANN = getappdata(0, 'mainHandles');
if(strcmp(selectedANN.NetworkType, 'Self Organizing Map'))
    maxLength = length(selectedANN.PlotData.ClusterContents{1});
    data = {};
    for i=1:length(selectedANN.PlotData.ClusterContents)
        if(length(selectedANN.PlotData.ClusterContents{i}) < maxLength)
            for j=1:maxLength-length(selectedANN.PlotData.ClusterContents{i})
                selectedANN.PlotData.ClusterContents{i}{end+1} = '';
            end
        end
        data = [data selectedANN.PlotData.ClusterContents{i}'];
    end
    set(handles.somClustersTable, 'Data', data, 'ColumnName', selectedANN.PlotData.ClusterHeader);
else
    h = msgbox('Cluster View is available only for Self Organizing Maps', 'Warning');
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes somOutputGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = somOutputGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
