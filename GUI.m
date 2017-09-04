function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 22-Aug-2017 11:43:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

setappdata(0,'hMainGUI', gcf);
setappdata(gcf,'mainHandles', handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function handles = antibodyFilePathText_Callback(hObject, eventdata, handles)
% hObject    handle to antibodyFilePathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of antibodyFilePathText as text
%        str2double(get(hObject,'String')) returns contents of antibodyFilePathText as a double
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

localExcelFile = get(hObject,'String');
try
    [num_excel, txt_excel, localexcelData] = xlsread(localExcelFile);
    format long g
    excelSize = size(localexcelData);
    localAntibodyNames = localexcelData(1, 2:excelSize(2));
    set(handles.antibodyListbox, 'string', localAntibodyNames);
    handles = antibodyListbox_Callback(handles.antibodyListbox, eventdata, handles);
    handles.excelData = localexcelData;
    handles.antibodyNames = localAntibodyNames;
catch
    h = msgbox('File not found','Error');
end
handles.excelFile = localExcelFile;

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function antibodyFilePathText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to antibodyFilePathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in antibodyBrowsePushButton.
function antibodyBrowsePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to antibodyBrowsePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
[FileName,PathName] = uigetfile('*.csv','Select the Excel antibodies file');
localExcelFile = strcat(PathName, FileName);
set(handles.antibodyFilePathText, 'String', localExcelFile);
handles = antibodyFilePathText_Callback(handles.antibodyFilePathText, eventdata, handles);
handles.excelFile = localExcelFile;
guidata(hObject,handles);


function antibodySearchText_Callback(hObject, eventdata, handles)
% hObject    handle to antibodySearchText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles = guidata(handles.output);
handles.antibodyFilterString = get(hObject,'String');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function antibodySearchText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to antibodySearchText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in antibodySearchPushButton.
function antibodySearchPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to antibodySearchPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
handles.antibodyFilterString = get(handles.antibodySearchText, 'String');
handles.filteredAntibodyNames = {};
for i=1:length(handles.antibodyNames)
    if(~isempty(regexpi(handles.antibodyNames{i}, handles.antibodyFilterString)) || isempty(handles.antibodyFilterString))
        handles.filteredAntibodyNames(end+1) = handles.antibodyNames(i);
    end
end
set(handles.antibodyListbox, 'string',  handles.filteredAntibodyNames);
guidata(hObject,handles);

function antibodySearchPushButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to antibodySearchPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on selection change in antibodyListbox.
function handles = antibodyListbox_Callback(hObject, eventdata, handles)
% hObject    handle to antibodyListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns antibodyListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from antibodyListbox
handles = guidata(handles.output);
contents = cellstr(get(hObject,'String'));
handles.selectedAntibodyName = contents{get(hObject,'Value')};
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function antibodyListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to antibodyListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function handles = virusFilePathText_Callback(hObject, eventdata, handles)
% hObject    handle to virusFilePathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of virusFilePathText as text
%        str2double(get(hObject,'String')) returns contents of virusFilePathText as a double
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

localFastaFile = get(hObject,'String');
try
    localFastaData = fastaread(localFastaFile,  'blockread', [1 Inf]);
    set(handles.virusListbox, 'string', {localFastaData.Header});
    handles = virusListbox_Callback(handles.virusListbox, eventdata, handles);
    handles.fastaData = localFastaData;
catch
    h = msgbox('File not found','Error');
end
handles.fastaFile = localFastaFile;

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function virusFilePathText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to virusFilePathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in virusBrowsePushButton.
function virusBrowsePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to virusBrowsePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
[FileName,PathName] = uigetfile('*.fasta','Select the Fasta virus file');
handles.fastaFile = strcat(PathName, FileName);
set(handles.virusFilePathText, 'String', handles.fastaFile);
handles = virusFilePathText_Callback(handles.virusFilePathText, eventdata, handles);
guidata(hObject,handles);


function virusSearchText_Callback(hObject, eventdata, handles)
% hObject    handle to virusSearchText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of virusSearchText as text
%        str2double(get(hObject,'String')) returns contents of virusSearchText as a double
handles = guidata(handles.output);
handles.virusFilterString = get(hObject,'String');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function virusSearchText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to virusSearchText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in virusSearchPushButton.
function virusSearchPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to virusSearchPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
handles.virusFilterString = get(handles.virusSearchText, 'String');
handles.filteredVirusNames = {};
convertedVirusNames = {handles.fastaData.Header};
for i=1:length(convertedVirusNames)
    if(~isempty(regexpi(convertedVirusNames{i}, handles.virusFilterString)) || isempty(handles.virusFilterString))
        handles.filteredVirusNames(end+1) = convertedVirusNames(i);
    end
end
set(handles.virusListbox, 'string',  handles.filteredVirusNames);
guidata(hObject,handles);


% --- Executes on selection change in virusListbox.
function handles = virusListbox_Callback(hObject, eventdata, handles)
% hObject    handle to virusListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns virusListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from virusListbox
handles = guidata(handles.output);
contents = cellstr(get(hObject,'String'));
handles.selectedVirusName = contents{get(hObject,'Value')};
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function virusListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to virusListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in proteinCodification.
function proteinCodification_Callback(hObject, eventdata, handles)
% hObject    handle to proteinCodification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns proteinCodification contents as cell array
%        contents{get(hObject,'Value')} returns selected item from proteinCodification
handles = guidata(handles.output);
contents = cellstr(get(hObject,'String'));
handles.proteinCodificationValue = contents{get(hObject,'Value')};
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function proteinCodification_CreateFcn(hObject, eventdata, handles)
% hObject    handle to proteinCodification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.proteinCodificationValue = 'A (Numerical)';
guidata(hObject,handles);


% --- Executes on selection change in annListbox.
function handles = annListbox_Callback(hObject, eventdata, handles)
% hObject    handle to annListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns annListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from annListbox
if ~isfield(handles, 'ANNFile')
    handles = guidata(handles.output);
end
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

contents = cellstr(get(hObject,'String'));
handles.SelectedANNIndex = str2num(contents{get(hObject,'Value')});
loadedANN = load(handles.ANNFile);
selectedANN = loadedANN.ANNStorage(handles.SelectedANNIndex);
selectedANNTR = selectedANN.TR;
if ~isfield(selectedANNTR, 'perf')
    perf = 'NaN';
else
    perf = num2str(min(selectedANN.TR.perf));
end
tableData = {'ANN Type' selectedANN.ANN.name;
             'Input Size' num2str(selectedANN.ANN.inputs{1}.size)
             'Performance' perf;
             'Codification' selectedANN.Codification;
             'Antibody' selectedANN.Antibody;
             'Classes' strcat(num2str(selectedANN.ClassArgs(2)),  ' / ', num2str(selectedANN.ClassArgs(3)));
             'I50Limits' strcat(num2str(selectedANN.AntibodySetLimits(1)), ' / ', num2str(selectedANN.AntibodySetLimits(2)))};
set(handles.annPropertiesTable, 'data', tableData);

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function annListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to annListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in createNewANNPushButton.
function createNewANNPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to createNewANNPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;
try
    if(strcmp(handles.networkTypeValue, 'Feedforward Neural Network'))
        ANNStorage = generateAnn(handles.networkTypeValue, handles.proteinCodificationValue, handles.fastaData, handles.excelData, handles.noOfANNIterationsValue, handles.noOfHiddenNeuronsValue, handles.selectedAntibodyName, [handles.useClassesCheckBoxValue handles.firstI50ClassLimitValue handles.secondI50ClassLimitValue]);
    end
    if(strcmp(handles.networkTypeValue, 'Self Organizing Map'))
        ANNStorage = generateAnn(handles.networkTypeValue, handles.proteinCodificationValue, handles.fastaData);
    end
    if(strcmp(ANNStorage.NetworkType, 'Self Organizing Map'))
        setappdata(0,'mainHandles', ANNStorage);
        somOutputGUI;
    end
    if(exist(handles.ANNFile, 'file') == 2)
        loadedANN = load(handles.ANNFile);
        ANNStorage = [loadedANN.ANNStorage; ANNStorage];
    end
    handles.ANNStorageIndexes = 1:length(ANNStorage);
    save(handles.ANNFile, 'ANNStorage');
    set(handles.annListbox, 'string', handles.ANNStorageIndexes);
    set(handles.annListbox, 'Value', length(ANNStorage));
    handles = annListbox_Callback(handles.annListbox, eventdata, handles);
catch
    h = msgbox('Error','Error');
end

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject,handles);


function noOfANNIterations_Callback(hObject, eventdata, handles)
% hObject    handle to noOfANNIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noOfANNIterations as text
%        str2double(get(hObject,'String')) returns contents of noOfANNIterations as a double
handles = guidata(handles.output);
try
    handles.noOfANNIterationsValue = str2double(get(hObject,'String'));
catch
    h = msgbox('Integer Required','Error');
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function noOfANNIterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noOfANNIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function noOfHiddenNeurons_Callback(hObject, eventdata, handles)
% hObject    handle to noOfHiddenNeurons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noOfHiddenNeurons as text
%        str2double(get(hObject,'String')) returns contents of noOfHiddenNeurons as a double
handles = guidata(handles.output);
try
    handles.noOfHiddenNeuronsValue = str2double(get(hObject,'String'));
catch
    h = msgbox('Integer Required','Error');
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function noOfHiddenNeurons_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noOfHiddenNeurons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in useANNPushButton.
function useANNPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to useANNPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

try
    for i=1:length(handles.fastaData)
        if(strcmp(handles.selectedVirusName, handles.fastaData(i).Header))
            rawInput = handles.fastaData(i);
            break;
        end
    end
    loadedANN = load(handles.ANNFile);
    selectedANN = loadedANN.ANNStorage(handles.SelectedANNIndex);
    codifiedInput = codifyFasta(rawInput, selectedANN.Codification);
    if(strcmp(selectedANN.NetworkType, 'Self Organizing Map') && strcmp(selectedANN.Codification, 'B (Properties)'))
        codifiedInput = vertcat(codifiedInput{1}, codifiedInput{2}, codifiedInput{3}, codifiedInput{4}, codifiedInput{5}, codifiedInput{6});
    end
    rawOutput = selectedANN.ANN(codifiedInput);
    if(iscell(rawOutput))
        rawOutput = rawOutput{1};
    end
    if(strcmp(selectedANN.NetworkType, 'Self Organizing Map'))
        rawOutput = find(rawOutput);
        renormalizedOutput = 'NaN';
    else
        if(selectedANN.ClassArgs(1))
            renormalizedOutput = convertToClasses(rawOutput, 0.25, 0.75);
        else    
            renormalizedOutput = renormalize(rawOutput, selectedANN.AntibodySetLimits(1), selectedANN.AntibodySetLimits(2));
        end
    end
    set(handles.ANNOutputText, 'String', num2str(rawOutput));
    set(handles.renormalizedANNOutputText, 'String', num2str(renormalizedOutput));
catch
    if(iscell(codifiedInput))
        codifiedInput = codifiedInput{1};
    end
    if(length(codifiedInput) ~= selectedANN.ANN.inputs{1}.size)
        h = msgbox(strcat('Fasta alignement length is:', num2str(length(codifiedInput)), ',it should be:', num2str(selectedANN.ANN.inputs{1}.size)), 'Error');
    else
        h = msgbox('Error', 'Error');
    end
end

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject,handles);


% --- Executes on button press in viewANNPushButton.
function viewANNPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to viewANNPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

loadedANN = load(handles.ANNFile);
selectedANN = loadedANN.ANNStorage(handles.SelectedANNIndex);
setappdata(0,'mainHandles', selectedANN);
viewANNGUI;

if(strcmp(selectedANN.NetworkType, 'Self Organizing Map'))
    somOutputGUI;
end

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject, handles);


function handles = annFilePathText_Callback(hObject, eventdata, handles)
% hObject    handle to annFilePathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of annFilePathText as text
%        str2double(get(hObject,'String')) returns contents of annFilePathText as a double
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

localANNFile = get(hObject,'String');
if(exist(localANNFile, 'file') == 2)
    loadedANN = load(localANNFile);
    localANNStorageIndexes = 1:length(loadedANN.ANNStorage);
    set(handles.annListbox, 'string', localANNStorageIndexes);
    handles.ANNFile = localANNFile;
    handles = annListbox_Callback(handles.annListbox, eventdata, handles);
    handles.ANNStorageIndexes = localANNStorageIndexes;
end
handles.ANNFile = localANNFile;

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function annFilePathText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to annFilePathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in annBrowsePushButton.
function annBrowsePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to annBrowsePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
[FileName,PathName] = uigetfile('*.mat','Select the Artificial Neural Network file');
localANNFile = strcat(PathName, FileName);
set(handles.annFilePathText, 'String', localANNFile);
handles = annFilePathText_Callback(handles.annFilePathText, eventdata, handles);
handles.ANNFile = localANNFile;
guidata(hObject,handles);


% --- Executes on selection change in networkType.
function networkType_Callback(hObject, eventdata, handles)
% hObject    handle to networkType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns networkType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from networkType
handles = guidata(handles.output);
contents = cellstr(get(hObject,'String'));
handles.networkTypeValue = contents{get(hObject,'Value')};
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function networkType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to networkType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.networkTypeValue = 'Feedforward Neural Network';
guidata(hObject,handles);


% --- Executes on button press in useClassesCheckBox.
function useClassesCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to useClassesCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of useClassesCheckBox
handles = guidata(handles.output);
handles.useClassesCheckBoxValue = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function useClassesCheckBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to useClassesCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.useClassesCheckBoxValue = 0;
guidata(hObject,handles);


function firstI50ClassLimit_Callback(hObject, eventdata, handles)
% hObject    handle to firstI50ClassLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of firstI50ClassLimit as text
%        str2double(get(hObject,'String')) returns contents of firstI50ClassLimit as a double
handles = guidata(handles.output);
handles.firstI50ClassLimitValue = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function firstI50ClassLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to firstI50ClassLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.firstI50ClassLimitValue = 0;
guidata(hObject,handles);


function secondI50ClassLimit_Callback(hObject, eventdata, handles)
% hObject    handle to secondI50ClassLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of secondI50ClassLimit as text
%        str2double(get(hObject,'String')) returns contents of secondI50ClassLimit as a double
handles = guidata(handles.output);
handles.secondI50ClassLimitValue = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function secondI50ClassLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to secondI50ClassLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.secondI50ClassLimitValue = 0;
guidata(hObject,handles);


% --- Executes on button press in viewI50PushButton.
function viewI50PushButton_Callback(hObject, eventdata, handles)
% hObject    handle to viewI50PushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
setappdata(0,'mainHandles', handles);
I50GUI;
guidata(hObject, handles);

% --- Executes on button press in viewFastaPushButton.
function viewFastaPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to viewFastaPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
setappdata(0,'mainHandles', handles);
FastaGUI;
guidata(hObject, handles);


% --- Executes on button press in sensitivityAnalysisPushButton.
function sensitivityAnalysisPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to sensitivityAnalysisPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)111
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

try
    setappdata(0,'mainHandles', handles);
    sensitivityAnalysisGUI;
catch
end

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject, handles);


% --- Executes on button press in DebugButton.
function DebugButton_Callback(hObject, eventdata, handles)
% hObject    handle to DebugButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
keyboard
