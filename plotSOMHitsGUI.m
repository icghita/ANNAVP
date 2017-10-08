function varargout = plotSOMHitsGUI(varargin)
% PLOTSOMHITSGUI MATLAB code for plotSOMHitsGUI.fig
%      PLOTSOMHITSGUI, by itself, creates a new PLOTSOMHITSGUI or raises the existing
%      singleton*.
%
%      H = PLOTSOMHITSGUI returns the handle to a new PLOTSOMHITSGUI or the handle to
%      the existing singleton*.
%
%      PLOTSOMHITSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTSOMHITSGUI.M with the given input arguments.
%
%      PLOTSOMHITSGUI('Property','Value',...) creates a new PLOTSOMHITSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotSOMHitsGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotSOMHitsGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotSOMHitsGUI

% Last Modified by GUIDE v2.5 18-Sep-2017 12:38:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotSOMHitsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @plotSOMHitsGUI_OutputFcn, ...
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


% --- Executes just before plotSOMHitsGUI is made visible.
function plotSOMHitsGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotSOMHitsGUI (see VARARGIN)

% Choose default command line output for plotSOMHitsGUI
handles.output = hObject;

selectedANN = getappdata(0, 'mainHandles');
axes(handles.plotSomHitsAxes);
if(strcmp(selectedANN.NetworkType, 'Self Organizing Map') && strcmp(selectedANN.Codification, 'A (Numerical)'))
    plotsomhits(selectedANN.ANN, selectedANN.PlotData.FastaData);
else
    h = msgbox('SOM Hits Plot is available only for Self Organizing Maps with single input layer', 'Warning');
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotSOMHitsGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plotSOMHitsGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
