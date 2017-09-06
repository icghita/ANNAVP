function varargout = FastaGUI(varargin)
% FASTAGUI MATLAB code for FastaGUI.fig
%      FASTAGUI, by itself, creates a new FASTAGUI or raises the existing
%      singleton*.
%
%      H = FASTAGUI returns the handle to a new FASTAGUI or the handle to
%      the existing singleton*.
%
%      FASTAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FASTAGUI.M with the given input arguments.
%
%      FASTAGUI('Property','Value',...) creates a new FASTAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FastaGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FastaGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FastaGUI

% Last Modified by GUIDE v2.5 06-Sep-2017 16:02:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FastaGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @FastaGUI_OutputFcn, ...
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


% --- Executes just before FastaGUI is made visible.
function FastaGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FastaGUI (see VARARGIN)

% Choose default command line output for FastaGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FastaGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FastaGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in showGlycosylationSites.
function showGlycosylationSites_Callback(hObject, eventdata, handles)
% hObject    handle to showGlycosylationSites (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showGlycosylationSites
handles = guidata(handles.output);
handles.showGlycosylationSitesValue = get(hObject,'Value');
handles.GlycosylationSites = [];
if(handles.showGlycosylationSitesValue)
    for i=1:length(handles.localFastaSequence)-2
        if(handles.localFastaSequence(i) == 'N' && handles.localFastaSequence(i+1) ~= 'P' && (handles.localFastaSequence(i+2) == 'S' || handles.localFastaSequence(i+2) == 'T'))
            handles.GlycosylationSites(end+1) = i;
        end
    end
else
    handles.GlycosylationSites = [];
end
set(handles.glycosylationSitesListbox, 'String', handles.GlycosylationSites);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function showGlycosylationSites_CreateFcn(hObject, eventdata, handles)
% hObject    handle to showGlycosylationSites (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.output = hObject;
handles.showGlycosylationSitesValue = 0;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function fastaText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fastaText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.output = hObject;
mainHandles = getappdata(0, 'mainHandles');
try
    for i=1:length(mainHandles.fastaData)
        if(strcmp(mainHandles.fastaData(i).Header, mainHandles.selectedVirusName))
            j=i;
            handles.localFastaSequence = mainHandles.fastaData(j).Sequence;
            break;
        end
    end
    set(handles.output, 'String', handles.localFastaSequence);   
catch
end
guidata(hObject,handles);


% --- Executes on selection change in glycosylationSitesListbox.
function glycosylationSitesListbox_Callback(hObject, eventdata, handles)
% hObject    handle to glycosylationSitesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns glycosylationSitesListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from glycosylationSitesListbox


% --- Executes during object creation, after setting all properties.
function glycosylationSitesListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to glycosylationSitesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fastaLengthText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fastaLengthText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.output = hObject;
mainHandles = getappdata(0, 'mainHandles');
try
    for i=1:length(mainHandles.fastaData)
        if(strcmp(mainHandles.fastaData(i).Header, mainHandles.selectedVirusName))
            j=i;
            handles.localFastaSequence = mainHandles.fastaData(j).Sequence;
            break;
        end
    end
    set(handles.output, 'String', length(handles.localFastaSequence));
catch
end
guidata(hObject,handles);
