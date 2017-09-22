function varargout = I50GUI(varargin)
% I50GUI MATLAB code for I50GUI.fig
%      I50GUI, by itself, creates a new I50GUI or raises the existing
%      singleton*.
%
%      H = I50GUI returns the handle to a new I50GUI or the handle to
%      the existing singleton*.
%
%      I50GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in I50GUI.M with the given input arguments.
%
%      I50GUI('Property','Value',...) creates a new I50GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before I50GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to I50GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help I50GUI

% Last Modified by GUIDE v2.5 20-Sep-2017 19:54:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @I50GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @I50GUI_OutputFcn, ...
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


% --- Executes just before I50GUI is made visible.
function I50GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to I50GUI (see VARARGIN)

% Choose default command line output for I50GUI
handles.output = hObject;

mainHandles = getappdata(0, 'mainHandles');
try
    excelSize = size(mainHandles.excelData);
    for i=1:excelSize(2)-1
        if(strcmp(mainHandles.antibodyNames(i), mainHandles.selectedAntibodyName))
            j=i;
            break;
        end
    end
    data = mainHandles.excelData(2:excelSize(1), j+1);
catch
end
axes(handles.i50DistributionAxes);
plot([1:length(data)], cell2mat(data), '.'), grid on;
xlabel('HIV-1 Strain');
ylabel(mainHandles.selectedAntibodyName);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes I50GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = I50GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function I50Table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to I50Table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.output = hObject;
mainHandles = getappdata(0, 'mainHandles');
colNames = {'Virus', ''};
try
    colNames = {'Virus', mainHandles.selectedAntibodyName};
    excelSize = size(mainHandles.excelData);
    for i=1:excelSize(2)-1
        if(strcmp(mainHandles.antibodyNames(i), mainHandles.selectedAntibodyName))
            j=i;
            break;
        end
    end
    data = [mainHandles.excelData(2:excelSize(1), 1) mainHandles.excelData(2:excelSize(1), j+1)];
catch
end
set(handles.output, 'Data', data, 'ColumnName', colNames);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function i50DistributionAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to i50DistributionAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate i50DistributionAxes
