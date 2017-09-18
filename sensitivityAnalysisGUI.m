function varargout = sensitivityAnalysisGUI(varargin)
% SENSITIVITYANALYSISGUI MATLAB code for sensitivityAnalysisGUI.fig
%      SENSITIVITYANALYSISGUI, by itself, creates a new SENSITIVITYANALYSISGUI or raises the existing
%      singleton*.
%
%      H = SENSITIVITYANALYSISGUI returns the handle to a new SENSITIVITYANALYSISGUI or the handle to
%      the existing singleton*.
%
%      SENSITIVITYANALYSISGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SENSITIVITYANALYSISGUI.M with the given input arguments.
%
%      SENSITIVITYANALYSISGUI('Property','Value',...) creates a new SENSITIVITYANALYSISGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sensitivityAnalysisGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sensitivityAnalysisGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sensitivityAnalysisGUI

% Last Modified by GUIDE v2.5 03-Aug-2017 14:56:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sensitivityAnalysisGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @sensitivityAnalysisGUI_OutputFcn, ...
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


% --- Executes just before sensitivityAnalysisGUI is made visible.
function sensitivityAnalysisGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sensitivityAnalysisGUI (see VARARGIN)

% Choose default command line output for sensitivityAnalysisGUI
handles.output = hObject;

mainHandles = getappdata(0, 'mainHandles');
loadedANN = load(mainHandles.ANNFile);
selectedANN = loadedANN.ANNStorage(mainHandles.SelectedANNIndex);
if(strcmp(selectedANN.NetworkType, 'Feedforward Neural Network'))
    try
        [inputNumbers, deltaPerf] = sensitivityAnalysis(selectedANN.ANN, mainHandles.fastaData, mainHandles.excelData, selectedANN.Codification, selectedANN.Antibody, selectedANN.ClassArgs);
        plot(inputNumbers, deltaPerf, 'parent', handles.sensitivityAnalysisPlot);
        xlabel('Input Index');
        ylabel('Delta Performance');
    catch
        h = msgbox('Make sure that the Fasta alignements are equal to the input of the Network and that both fasta and excel files have been provided', 'Error');
    end
else
    h = msgbox('Sensitivity Analysis is available only for Feedforward Neural Networks', 'Warning');
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sensitivityAnalysisGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sensitivityAnalysisGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function sensitivityAnalysisPlot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sensitivityAnalysisPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate sensitivityAnalysisPlot
