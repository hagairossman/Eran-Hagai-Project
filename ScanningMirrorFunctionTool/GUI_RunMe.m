function varargout = GUI_RunMe(varargin)
% GUI_RunMe MATLAB code for GUI_RunMe.fig
%      GUI_RunMe, by itself, creates a new GUI_RunMe or raises the existing
%      singleton*.
%
%      H = GUI_RunMe returns the handle to a new GUI_RunMe or the handle to
%      the existing singleton*.
%
%      GUI_RunMe('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_RunMe.M with the given input arguments.
%
%      GUI_RunMe('Property','Value',...) creates a new GUI_RunMe or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_RunMe_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_RunMe_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_RunMe

% Last Modified by GUIDE v2.5 15-Aug-2016 13:25:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_RunMe_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_RunMe_OutputFcn, ...
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


% --- Executes just before GUI_RunMe is made visible.
function GUI_RunMe_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_RunMe (see VARARGIN)
% clc;
EnableStuff(hObject, handles, [1 1 1 0 0 1]);
handles.parentpath = cd(cd('..'));
addpath(genpath('..')); % add all relevent folders to path
NumPixels = 512; FrameRate = 5.04;
set(handles.NumPixels,'string',num2str(NumPixels));
set(handles.FrameRate,'string',num2str(FrameRate));
handles.fix_params = [round(NumPixels/4), 1.025, 25, 1, 0.6]; %[mid_amp, thresh, smooth_span, stretch, gaussfiltsigma];

% Choose default command line output for GUI_RunMe
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_RunMe wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_RunMe_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadCsvButton.
function LoadCsvButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadCsvButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% importfile
[ handles.CSVfilename ] = LoadCsvFile( );
if handles.CSVfilename ~= '0'
    [sdata.x,sdata.val,sdata.start,sdata.inc] = importfile(handles.CSVfilename, 2);
    sdata.x(1) = [];  sdata.val(1) = [];
    sx = str2double(cell2mat(sdata.inc))*(sdata.x);
    sy = smooth(sdata.val);
    %Plot data
    plot(handles.axes1,sx,sy,'.'); 
    axes(handles.axes1); title('Fast Scan Galvo measurement'); ylabel('Voltage [V]'); xlabel('time [sec]');
    EnableStuff(hObject, handles, [0 0 0 1 1 1]);

end
guidata(hObject, handles);


% --- Executes on button press in LoadExistingData.
function LoadExistingData_Callback(hObject, eventdata, handles)
% hObject    handle to LoadExistingData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LoadCsvButton.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to LoadCsvButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LoadExistingButton.
function LoadExistingButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadExistingButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Correctionfilename = [handles.parentpath, '\Data\CorrectionData'];
uiopen(Correctionfilename);

%Save to struct:
handles.S = struct('CorrVecRiseRaw', CorrVecRiseRaw,  'CorrVecFallRaw', CorrVecFallRaw, ...
    'CorrVecRise', CorrVecRise, 'CorrVecFall', CorrVecFall, 'CorrVecBoth', CorrVecBoth,...
    'CorrVecSymRise', CorrVecSymRise, 'CorrVecSymFall', CorrVecSymFall,...
    'LinVecRise', LinVecRise, 'LinVecFall', LinVecFall,...
    'RiseVec', RiseVec, 'FallVec',  FallVec, 'TimeVec', TimeVec,...
    'CorrRise', CorrRise, 'CorrFall', CorrFall, ...
    'NumPixels', NumPixels, 'userFrameRate', userFrameRate, 'ResonantFreq', ResonantFreq,  ...
    'fix_params', fix_params );
disp(handles.S)

% Plots
PlotVecs(hObject, handles, TimeVec, RiseVec, LinVecRise, CorrVecRise, FallVec, LinVecFall, CorrVecFall);

guidata(hObject, handles);


% --- Executes on button press in CalculateCorrectionButton.
function CalculateCorrectionButton_Callback(hObject, eventdata, handles)
% hObject    handle to CalculateCorrectionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[ ~, ~, handles.R_time, handles.R_voltage, handles.F_time, handles.F_voltage ] = GetFastScan( handles.CSVfilename );

NumPixels = str2double(get(handles.NumPixels,'string'));
userFrameRate = str2double(get(handles.FrameRate,'string'));
fix_params = handles.fix_params;


% % Load matrices:
% matfilename = [parentpath, '\Data\GalvoMatrices\', strrep(num2str(userFrameRate), '.', '_'), '.mat'];
% load(matfilename); % Load galvo scope data

% Make Rise and Fall vecs:
[ RiseVec, FallVec, TimeVec ] = MakeScanVectors( handles.R_time, handles.R_voltage, handles.F_time, handles.F_voltage, NumPixels );

% Make Linear  and Correction vectors
[ CorrVecRiseRaw, CorrVecFallRaw, CorrVecRise, CorrVecFall, CorrVecBoth, CorrVecSymRise, CorrVecSymFall, LinVecRise, LinVecFall ] = MakeCorrectionVectors( RiseVec, FallVec, TimeVec, NumPixels, fix_params );

valR = get(handles.RiseVecStyle,'Value');
switch valR
    case 1
        CorrRise = CorrVecRise;
    case 2 
        CorrRise = CorrVecSymRise;
    case 3 
        CorrRise = CorrVecBoth;
    case 4
        CorrRise = CorrVecRiseRaw;
end

valF = get(handles.FallVecStyle,'Value');
switch valF
    case 1
        CorrFall = CorrVecFall;
    case 2 
        CorrFall = CorrVecSymFall;
    case 3 
        CorrFall = CorrVecBoth;
    case 4
        CorrFall = CorrVecFallRaw;
end

%Save to struct:
handles.S = struct('CorrVecRiseRaw', CorrVecRiseRaw,  'CorrVecFallRaw', CorrVecFallRaw, ...
    'CorrVecRise', CorrVecRise, 'CorrVecFall', CorrVecFall, 'CorrVecBoth', CorrVecBoth,...
    'CorrVecSymRise', CorrVecSymRise, 'CorrVecSymFall', CorrVecSymFall,...
    'LinVecRise', LinVecRise, 'LinVecFall', LinVecFall,...
    'RiseVec', RiseVec, 'FallVec',  FallVec, 'TimeVec', TimeVec,...
    'CorrRise', CorrRise, 'CorrFall', CorrFall, ...
    'NumPixels', NumPixels, 'userFrameRate', userFrameRate, 'ResonantFreq', 0,  ...
    'fix_params', fix_params );

% Plots
PlotVecs(hObject, handles,  handles.S.TimeVec,  handles.S.RiseVec,  handles.S.LinVecRise,  handles.S.CorrRise,  handles.S.FallVec,  handles.S.LinVecFall,  handles.S.CorrFall);


guidata(hObject, handles);


% --- Executes on button press in ResonantScannerButton.
function ResonantScannerButton_Callback(hObject, eventdata, handles)
% hObject    handle to ResonantScannerButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

NumPixels = str2double(get(handles.NumPixels,'string'));
fix_params = handles.fix_params; %[mid_amp, thresh, smooth_span, stretch, gaussfiltsigma];
[ handles.R_time, handles.R_voltage, handles.F_time, handles.F_voltage, userFreq ] = MakeResonantScanner( );
[ RiseVec, FallVec, TimeVec ] = MakeScanVectors( handles.R_time, handles.R_voltage, handles.F_time, handles.F_voltage, NumPixels );
FallVec = fliplr(FallVec);
ResonantFreq = userFreq*10^3;
T = 1/ResonantFreq; 
x = TimeVec*(pi/(2*T));
LinVecRise = x; LinVecFall = x;
CorrVecRise =  x./sin(x); CorrVecFall =  x./sin(x);

%Save to struct:
handles.S = struct('CorrVecRiseRaw', CorrVecRise,  'CorrVecFallRaw', CorrVecFall, ...
    'CorrVecRise', CorrVecRise, 'CorrVecFall', CorrVecFall, 'CorrVecBoth', CorrVecRise,...
    'CorrVecSymRise', CorrVecRise, 'CorrVecSymFall', CorrVecFall,...
    'LinVecRise', LinVecRise, 'LinVecFall', LinVecFall,...
    'RiseVec', RiseVec, 'FallVec',  FallVec, 'TimeVec', TimeVec,...
    'CorrRise', CorrVecRise, 'CorrFall', CorrVecFall, ...
    'NumPixels', NumPixels, 'userFrameRate', 0, 'ResonantFreq', ResonantFreq,  ...
    'fix_params', fix_params );

% Plots
PlotVecs(hObject, handles, TimeVec, RiseVec, LinVecRise, CorrVecRise, FallVec, LinVecFall, CorrVecFall);

EnableStuff(hObject, handles, [0 0 0 0 1 1]);
guidata(hObject, handles);


function NumPixels_Callback(hObject, eventdata, handles)
% hObject    handle to NumPixels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumPixels as text
%        str2double(get(hObject,'String')) returns contents of NumPixels as a double


% --- Executes during object creation, after setting all properties.
function NumPixels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumPixels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FrameRate_Callback(hObject, eventdata, handles)
% hObject    handle to FrameRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FrameRate as text
%        str2double(get(hObject,'String')) returns contents of FrameRate as a double


% --- Executes during object creation, after setting all properties.
function FrameRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in RiseVecStyle.
function RiseVecStyle_Callback(hObject, eventdata, handles)
% hObject    handle to RiseVecStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RiseVecStyle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RiseVecStyle
valR = get(handles.RiseVecStyle,'Value');
switch valR
    case 1
        handles.S.CorrRise = handles.S.CorrVecRise;
    case 2 
        handles.S.CorrRise = handles.S.CorrVecSymRise;
    case 3 
        handles.S.CorrRise = handles.S.CorrVecBoth;
    case 4
        handles.S.CorrRise = handles.S.CorrVecRiseRaw;
end

% Plots
PlotVecs(hObject, handles,  handles.S.TimeVec,  handles.S.RiseVec,  handles.S.LinVecRise,  handles.S.CorrRise,  handles.S.FallVec,  handles.S.LinVecFall,  handles.S.CorrFall);

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function RiseVecStyle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RiseVecStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',{'Regular';'Symmetric';'Rise+Fall'; 'Raw'});



% --- Executes on button press in FineTuneOptionsButton.
function FineTuneOptionsButton_Callback(hObject, eventdata, handles)
% hObject    handle to FineTuneOptionsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'mid amplitutude:','threshold:','smoothing span'};
dlg_title = 'Fine Tuning inputs';
num_lines = 1;
defaultans = {num2str(handles.fix_params(1)),num2str(handles.fix_params(2)),num2str(handles.fix_params(3))};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
if isempty(answer) 
    return;
else
    handles.fix_params(1) = str2double(answer{1});
    handles.fix_params(2) = str2double(answer{2});
    handles.fix_params(3) = str2double(answer{3});
end
guidata(hObject, handles);


% --- Executes on selection change in FallVecStyle.
function FallVecStyle_Callback(hObject, eventdata, handles)
% hObject    handle to FallVecStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FallVecStyle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FallVecStyle
valF = get(handles.FallVecStyle,'Value');
switch valF
    case 1
        handles.S.CorrFall = handles.S.CorrVecFall;
    case 2 
        handles.S.CorrFall = handles.S.CorrVecSymFall;
    case 3 
        handles.S.CorrFall = handles.S.CorrVecBoth;
    case 4
        handles.S.CorrFall = handles.S.CorrVecFallRaw;
end
% Plots
PlotVecs(hObject, handles,  handles.S.TimeVec,  handles.S.RiseVec,  handles.S.LinVecRise,  handles.S.CorrRise,  handles.S.FallVec,  handles.S.LinVecFall,  handles.S.CorrFall);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function FallVecStyle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FallVecStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',{'Regular';'Symmetric';'Rise+Fall'; 'Raw'});


% --- Executes on button press in SaveCorrectionButton.
function SaveCorrectionButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveCorrectionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Correctionfilename = [handles.parentpath, '\Data\CorrectionData\', strrep(get(handles.FrameRate,'string'), '.', '_'), '.mat'];
[file,path] = uiputfile('*.mat','Save CorrectionVectors As', Correctionfilename);
Correctionfilename = fullfile(path, file);
S = handles.S;
save(Correctionfilename, '-struct', 'S');

guidata(hObject, handles);


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ResetButton.
function ResetButton_Callback(hObject, eventdata, handles)
% hObject    handle to ResetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcbf);
GUI_RunMe

function EnableStuff(hObject, handles, EnableVec)
% hObject    handle to LoadCorrectionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if EnableVec(1) == 1 
    set(handles.LoadCsvButton, 'Enable', 'on');
elseif EnableVec(1) == 0 
    set(handles.LoadCsvButton, 'Enable', 'off');
end

if EnableVec(2) == 1 
    set(handles.ResonantScannerButton, 'Enable', 'on');
elseif EnableVec(2) == 0 
    set(handles.ResonantScannerButton, 'Enable', 'off');
end

if EnableVec(3) == 1 
    set(handles.LoadExistingButton, 'Enable', 'on');
elseif EnableVec(3) ==0 
    set(handles.LoadExistingButton, 'Enable', 'off');
end

if EnableVec(4) == 1 
    set(handles.CalculateCorrectionButton, 'Enable', 'on');
elseif EnableVec(4) == 0 
    set(handles.CalculateCorrectionButton, 'Enable', 'off');
end

if EnableVec(5) == 1 
    set(handles.SaveCorrectionButton, 'Enable', 'on');
elseif EnableVec(5) == 0
    set(handles.SaveCorrectionButton, 'Enable', 'off');
end

if EnableVec(6) == 1 
    set(handles.ResetButton, 'Enable', 'on');
elseif EnableVec(6) == 0
    set(handles.ResetButton, 'Enable', 'off');
end

guidata(hObject, handles);

function PlotVecs(hObject, handles, TimeVec, RiseVec, LinVecRise, CorrVecRise, FallVec, LinVecFall, CorrVecFall)
% hObject    handle to LoadCorrectionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Plots
plot( handles.axes1, TimeVec, RiseVec, '.', TimeVec, LinVecRise, 'r');
axes(handles.axes1); title('Rising Segment');
xlabel('time [sec]'); ylabel('Voltage [V]');
plot( handles.axes3, TimeVec, CorrVecRise, '.');
axes(handles.axes3); title('Correction');
xlabel('time [sec]'); ylabel('Factor');
plot( handles.axes2, TimeVec, fliplr(FallVec), '.', TimeVec, fliplr(LinVecFall), 'r');
axes(handles.axes2); title('Falling Segment');
xlabel('time [sec]'); ylabel('Voltage [V]');
plot( handles.axes4, TimeVec, CorrVecFall, '.'); 
axes(handles.axes4); title('Correction');
xlabel('time [sec]'); ylabel('Factor');

guidata(hObject, handles);
