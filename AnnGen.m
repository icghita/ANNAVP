function varargout = AnnGen(varargin)
% AnnGen MATLAB code for AnnGen.fig
%      AnnGen, by itself, creates a new AnnGen or raises the existing
%      singleton*.
%
%      H = AnnGen returns the handle to a new AnnGen or the handle to
%      the existing singleton*.
%
%      AnnGen('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AnnGen.M with the given input arguments.
%
%      AnnGen('Property','Value',...) creates a new AnnGen or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the AnnGen before AnnGen_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AnnGen_OpeningFcn via varargin.
%
%      *See AnnGen Options on GUIDE's Tools menu.  Choose "AnnGen allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AnnGen

% Last Modified by GUIDE v2.5 10-Jul-2020 16:45:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AnnGen_OpeningFcn, ...
                   'gui_OutputFcn',  @AnnGen_OutputFcn, ...
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


% --- Executes just before AnnGen is made visible.
function AnnGen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AnnGen (see VARARGIN)

% Choose default command line output for AnnGen
handles.output = hObject;

setappdata(0,'hMainGUI', gcf);
setappdata(gcf,'mainHandles', handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AnnGen wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AnnGen_OutputFcn(hObject, eventdata, handles) 
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
    h = msgbox('File not found or not compatible','Error');
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
    localFastaData = fastareadCustom(localFastaFile);
    set(handles.virusListbox, 'string', {localFastaData.Header});
    handles = virusListbox_Callback(handles.virusListbox, eventdata, handles);
    handles.fastaData = localFastaData;
catch
    h = msgbox('File not found or not compatible','Error');
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


function networkName_Callback(hObject, eventdata, handles)
% hObject    handle to networkName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of networkName as text
%        str2double(get(hObject,'String')) returns contents of networkName as a double
handles = guidata(handles.output);
handles.networkNameString = get(hObject,'String');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function networkName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to networkName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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
switch handles.proteinCodificationValue
    case 'A (Numerical)'
        multiplierValue = 1;
    case 'A-6 (Properties codification)'
        multiplierValue = 6;
    case 'A-9 (Properties codification)'
        multiplierValue = 9;
    case 'B (Raw Properties)'
        multiplierValue = 6;
end
set(handles.multiplierText, 'String', strcat(num2str(multiplierValue),' x'));
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
tableData = {'ANN Name' selectedANN.NetworkName;
             'ANN Type' selectedANN.NetworkType;
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
    if ~isfield(handles,'networkNameString')
        networkNameStringParam = datestr(now);
    else
        if(isempty(handles.networkNameString))
            networkNameStringParam = datestr(now);
        else
            networkNameStringParam = handles.networkNameString;
        end
    end
    if(strcmp(handles.networkTypeValue, 'Feedforward Neural Network'))
        ANNStorage = generateFeedforwardNetwork(networkNameStringParam, handles.networkTypeValue, handles.proteinCodificationValue, handles.fastaData, handles.excelData, handles.noOfANNIterationsValue, handles.noOfHiddenNeuronsValue, handles.networkTrainingFunctionValue, handles.selectedAntibodyName, [handles.firstDataDivisionLimitValue handles.secondDataDivisionLimitValue], [handles.useParallelCheckboxValue handles.useGpuCheckboxValue], [handles.useClassesCheckBoxValue handles.firstI50ClassLimitValue handles.secondI50ClassLimitValue]);
    end
    if(strcmp(handles.networkTypeValue, 'Self Organizing Map'))
        ANNStorage = generateSelfOrganizingMap(networkNameStringParam, handles.networkTypeValue, handles.proteinCodificationValue, handles.fastaData, handles.mapTopologyValue, handles.mapWidthValue, handles.mapHeightValue, handles.trainingStepsValue, handles.neighborhoodSizeValue, handles.distanceFunctionValue);
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
    handles.noOfANNIterationsValue = get(hObject,'String');
    if ~all(ismember(handles.noOfANNIterationsValue, '1234567890'))
        h = msgbox('Value must be an integer');
        error();
    end
    handles.noOfANNIterationsValue = str2double(handles.noOfANNIterationsValue);
catch
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
    handles.noOfHiddenNeuronsValue = get(hObject,'String');
    if ~all(ismember(handles.noOfHiddenNeuronsValue, '1234567890'))
        h = msgbox('Value must be an integer');
        error();
    end
    handles.noOfHiddenNeuronsValue = str2double(handles.noOfHiddenNeuronsValue);
catch
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
    loadedANN = load(handles.ANNFile);
    selectedANN = loadedANN.ANNStorage(handles.SelectedANNIndex);
    outputArray = cell(length(handles.fastaData)+1, 3);
    outputArray(1,:) = {'Strain', 'Raw Output', 'Normalised Output'};
    for i=1:length(handles.fastaData)
        codifiedInput = codifyFasta(handles.fastaData(i), selectedANN.Codification);
        if(strcmp(selectedANN.NetworkType, 'Self Organizing Map') && strcmp(selectedANN.Codification, 'B (Raw Properties)'))
            codifiedInput = vertcat(codifiedInput{1}, codifiedInput{2}, codifiedInput{3}, codifiedInput{4}, codifiedInput{5}, codifiedInput{6});
        end
        try
            rawOutput = selectedANN.ANN(codifiedInput);
        catch
            outputArray(i+1,:) = {handles.fastaData(i).Header, '', ''};
            continue;
        end
        if(iscell(rawOutput))
           rawOutput = rawOutput{1};
        end
        if(strcmp(selectedANN.NetworkType, 'Self Organizing Map'))
           rawOutput = find(rawOutput);
           renormalizedOutput = 'NaN';
        else
            if(selectedANN.ClassArgs(1))
                renormalizedOutput = convertToClasses(rawOutput, selectedANN.ClassArgs(2), selectedANN.ClassArgs(3));
            else    
                renormalizedOutput = renormalize(rawOutput, selectedANN.AntibodySetLimits(1), selectedANN.AntibodySetLimits(2));
            end
        end
        outputArray(i+1,:) = {handles.fastaData(i).Header, num2str(rawOutput), num2str(renormalizedOutput)};
    %set(handles.ANNOutputText, 'String', num2str(rawOutput));
    %set(handles.renormalizedANNOutputText, 'String', num2str(renormalizedOutput));
    
    %if(strcmp(handles.selectedVirusName, handles.fastaData(i).Header))
    %        rawInput = handles.fastaData(i);
    %        break;
     %   end
    end
    outputTable = cell2table(outputArray(2:end,:),'VariableNames',outputArray(1,:));
    writetable(outputTable, handles.outputFile);
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
view(selectedANN.ANN);

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
[FileName,PathName] = uiputfile('*.mat','Select the Artificial Neural Network file');
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
try
    handles.firstI50ClassLimitValue = str2double(get(hObject,'String'));
    if isnan(handles.firstI50ClassLimitValue)
        h = msgbox('Value must be numeric');
        error();
    end
catch
end
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
try   
    handles.secondI50ClassLimitValue = str2double(get(hObject,'String'));
    if isnan(handles.secondI50ClassLimitValue)
        h = msgbox('Value must be numeric');
        error();
    end
catch
end
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


% --- Executes on button press in coveragePlotPushButton.
function coveragePlotPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to coveragePlotPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
try
    colors = colormap(jet);
    colorSpacing = floor(length(colors)/length(handles.antibodyNames));
    miuMLArray = logspace(-3,2,100);
    excelSize = size(handles.excelData);
    legendLabels = cell(length(handles.antibodyNames),1);
    figure('Name', 'Coverage Plot');
    for i=1:length(handles.antibodyNames)
        sortedData = sort(cell2mat(handles.excelData(2:excelSize(1), i+1)));
        coverageArray = linspace(0,0,length(miuMLArray));
        for j=1:length(miuMLArray)
            coverageArray(j) = length(sortedData(sortedData < miuMLArray(j)))/length(sortedData);
        end
        legendLabels{i} = handles.antibodyNames{i};
        semilogx(miuMLArray, coverageArray, 'Color', colors(i*colorSpacing,:)), hold on;
    end
    grid on;
    xlabel('Antibody concentration (ug/mL)');
    ylabel('% Coverage');
    legend(legendLabels);
catch
end

% --- Executes on button press in viewFastaPushButton.
function viewFastaPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to viewFastaPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
setappdata(0,'mainHandles', handles);
FastaGUI;
guidata(hObject, handles);


% --- Executes on button press in reggressionPlotPushButton.
function reggressionPlotPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to reggressionPlotPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

loadedANN = load(handles.ANNFile);
selectedANN = loadedANN.ANNStorage(handles.SelectedANNIndex);
if(strcmp(selectedANN.NetworkType, 'Feedforward Neural Network'))
    figure('Name', 'Regression Plot');
    plotregression(selectedANN.PlotData.RegressionPlot{1,1}, selectedANN.PlotData.RegressionPlot{1,2}, 'Train', selectedANN.PlotData.RegressionPlot{2,1}, selectedANN.PlotData.RegressionPlot{2,2}, 'Validation', selectedANN.PlotData.RegressionPlot{3,1}, selectedANN.PlotData.RegressionPlot{3,2}, 'Testing');
else
    h = msgbox('Regression Plot is available only for Feedforward Neural Networks', 'Warning');
end

set(handles.figure1, 'pointer', oldpointer);
drawnow;
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

loadedANN = load(handles.ANNFile);
selectedANN = loadedANN.ANNStorage(handles.SelectedANNIndex);
if(strcmp(selectedANN.NetworkType, 'Feedforward Neural Network'))
    try
        [inputNumbers, deltaPerf] = sensitivityAnalysis(selectedANN.ANN, handles.fastaData, handles.excelData, selectedANN.Codification, selectedANN.Antibody, selectedANN.ClassArgs);
        figure('Name', 'Sensitivity Analysis Plot');
        plot(inputNumbers, deltaPerf);%, 'parent', handles.sensitivityAnalysisPlot);
        xlabel('Input Index');
        ylabel('Delta Performance');
    catch
        h = msgbox('Make sure that the Fasta alignements are equal to the input of the Network and that both fasta and excel files have been provided', 'Error');
    end
else
    h = msgbox('Sensitivity Analysis is available only for Feedforward Neural Networks', 'Warning');
end

% try
%     setappdata(0,'mainHandles', handles);
%     sensitivityAnalysisGUI;
% catch
% end

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject, handles);


% --- Executes on button press in plotSomHitsPushButton.
function plotSomHitsPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to plotSomHitsPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

loadedANN = load(handles.ANNFile);
selectedANN = loadedANN.ANNStorage(handles.SelectedANNIndex);
figure('Name','SOM Sample Hits');
plotsomhits(selectedANN.ANN, selectedANN.PlotData.FastaData);

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject, handles);


% --- Executes on button press in viewClustersPushButton.
function viewClustersPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to viewClustersPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

loadedANN = load(handles.ANNFile);
selectedANN = loadedANN.ANNStorage(handles.SelectedANNIndex);
setappdata(0,'mainHandles', selectedANN);
somOutputGUI;

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject, handles);


% --- Executes on selection change in mapTopology.
function mapTopology_Callback(hObject, eventdata, handles)
% hObject    handle to mapTopology (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mapTopology contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mapTopology
handles = guidata(handles.output);
contents = cellstr(get(hObject,'String'));
handles.mapTopologyValue = contents{get(hObject,'Value')};
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function mapTopology_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapTopology (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.mapTopologyValue = 'Hexagonal';
guidata(hObject,handles);


% --- Executes on selection change in distanceFunction.
function distanceFunction_Callback(hObject, eventdata, handles)
% hObject    handle to distanceFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns distanceFunction contents as cell array
%        contents{get(hObject,'Value')} returns selected item from distanceFunction
handles = guidata(handles.output);
contents = cellstr(get(hObject,'String'));
handles.distanceFunctionValue = contents{get(hObject,'Value')};
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function distanceFunction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distanceFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.distanceFunctionValue = 'linkdist';
guidata(hObject,handles);


function mapWidth_Callback(hObject, eventdata, handles)
% hObject    handle to mapWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mapWidth as text
%        str2double(get(hObject,'String')) returns contents of mapWidth as a double
handles = guidata(handles.output);
try
    handles.mapWidthValue = get(hObject,'String');
    if ~all(ismember(handles.mapWidthValue, '1234567890'))
        h = msgbox('Value must be an integer');
        error();
    end
    handles.mapWidthValue = str2double(handles.mapWidthValue);
catch
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function mapWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function mapHeight_Callback(hObject, eventdata, handles)
% hObject    handle to mapHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mapHeight as text
%        str2double(get(hObject,'String')) returns contents of mapHeight as a double
handles = guidata(handles.output);
try
    handles.mapHeightValue = get(hObject,'String');
    if ~all(ismember(handles.mapHeightValue, '1234567890'))
        h = msgbox('Value must be an integer');
        error();
    end
    handles.mapHeightValue = str2double(handles.mapHeightValue);
catch
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function mapHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function trainingSteps_Callback(hObject, eventdata, handles)
% hObject    handle to trainingSteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trainingSteps as text
%        str2double(get(hObject,'String')) returns contents of trainingSteps as a double
handles = guidata(handles.output);
try
    handles.trainingStepsValue = get(hObject,'String');
    if ~all(ismember(handles.trainingStepsValue, '1234567890'))
        h = msgbox('Value must be an integer');
        error();
    end
    handles.trainingStepsValue = str2double(handles.trainingStepsValue);
catch
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function trainingSteps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trainingSteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function neighborhoodSize_Callback(hObject, eventdata, handles)
% hObject    handle to neighborhoodSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neighborhoodSize as text
%        str2double(get(hObject,'String')) returns contents of neighborhoodSize as a double
handles = guidata(handles.output);
try
    handles.neighborhoodSizeValue = get(hObject,'String');
    if ~all(ismember(handles.neighborhoodSizeValue, '1234567890'))
        h = msgbox('Value must be an integer');
        error();
    end
    handles.neighborhoodSizeValue = str2double(handles.neighborhoodSizeValue);
catch
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function neighborhoodSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neighborhoodSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function firstDataDivisionLimit_Callback(hObject, eventdata, handles)
% hObject    handle to firstDataDivisionLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of firstDataDivisionLimit as text
%        str2double(get(hObject,'String')) returns contents of firstDataDivisionLimit as a double
handles = guidata(handles.output);
try
    handles.firstDataDivisionLimitValue = str2double(get(hObject,'String'));
    if isnan(handles.firstDataDivisionLimitValue)
        h = msgbox('Value must be an integer');
        error();
    end
    if(handles.firstDataDivisionLimitValue < 0 || handles.firstDataDivisionLimitValue > 100)
        h = msgbox('Value must be from 0 to 100');
        error();
    end
    if isfield(handles,'secondDataDivisionLimitValue')
        if(handles.firstDataDivisionLimitValue > handles.secondDataDivisionLimitValue)
            error();
            h = msgbox('The first value must be less than the second');
        end
    end
catch
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function firstDataDivisionLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to firstDataDivisionLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function secondDataDivisionLimit_Callback(hObject, eventdata, handles)
% hObject    handle to secondDataDivisionLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of secondDataDivisionLimit as text
%        str2double(get(hObject,'String')) returns contents of secondDataDivisionLimit as a double
handles = guidata(handles.output);
try
    handles.secondDataDivisionLimitValue = str2double(get(hObject,'String'));
    if isnan(handles.secondDataDivisionLimitValue)
        h = msgbox('Value must be an integer');
        error();
    end
    if(handles.secondDataDivisionLimitValue < 0 || handles.secondDataDivisionLimitValue > 100)
        h = msgbox('Value must be from 0 to 100');
        error();
    end
    if isfield(handles,'firstDataDivisionLimitValue')
        if(handles.firstDataDivisionLimitValue > handles.secondDataDivisionLimitValue)
            error();
            h = msgbox('The first value must be less than the second');
        end
    end
catch
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function secondDataDivisionLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to secondDataDivisionLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in networkTrainingFunction.
function networkTrainingFunction_Callback(hObject, eventdata, handles)
% hObject    handle to networkTrainingFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns networkTrainingFunction contents as cell array
%        contents{get(hObject,'Value')} returns selected item from networkTrainingFunction
handles = guidata(handles.output);
contents = cellstr(get(hObject,'String'));
handles.networkTrainingFunctionValue = contents{get(hObject,'Value')};
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function networkTrainingFunction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to networkTrainingFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.networkTrainingFunctionValue = 'Levenberg-Marquardt';
guidata(hObject,handles);


% --- Executes on button press in useParallelCheckbox.
function useParallelCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to useParallelCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of useParallelCheckbox
handles = guidata(handles.output);
handles.useParallelCheckboxValue = get(hObject,'Value');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function useParallelCheckbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to useParallelCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.useParallelCheckboxValue = 0;
guidata(hObject,handles);


% --- Executes on button press in useGpuCheckbox.
function useGpuCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to useGpuCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of useGpuCheckbox
handles = guidata(handles.output);
handles.useGpuCheckboxValue = get(hObject,'Value');
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function useGpuCheckbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to useGpuCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.useGpuCheckboxValue = 0;
guidata(hObject,handles);



% --- Executes on button press in DebugButton.
function DebugButton_Callback(hObject, eventdata, handles)
% hObject    handle to DebugButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
keyboard


% --- Executes on key press with focus on useANNPushButton and none of its controls.
function useANNPushButton_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to useANNPushButton (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function renormalizedANNOutputText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to renormalizedANNOutputText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over renormalizedANNOutputText.
function renormalizedANNOutputText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to renormalizedANNOutputText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in outputBrowsePushButton.
function outputBrowsePushButton_Callback(hObject, eventdata, handles)
% hObject    handle to outputBrowsePushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.output);
[FileName,PathName] = uiputfile('*','Select the output file');
handles.outputFile = strcat(PathName, FileName);
set(handles.outputFilePathText, 'String', handles.outputFile);
handles = outputFilePathText_Callback(handles.outputFilePathText, eventdata, handles);
guidata(hObject,handles);


function handles = outputFilePathText_Callback(hObject, eventdata, handles)
% hObject    handle to outputFilePathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outputFilePathText as text
%        str2double(get(hObject,'String')) returns contents of outputFilePathText as a double
handles = guidata(handles.output);
oldpointer = get(handles.figure1, 'pointer');
set(handles.figure1, 'pointer', 'watch');
drawnow;

localOutputFile = get(hObject,'String');
handles.outputFile = localOutputFile;

set(handles.figure1, 'pointer', oldpointer);
drawnow;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function outputFilePathText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputFilePathText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
