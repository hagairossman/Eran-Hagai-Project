function varargout = GUI_ImageCorrection(varargin)
% GUI_IMAGECORRECTION MATLAB code for GUI_ImageCorrection.fig
%      GUI_IMAGECORRECTION, by itself, creates a new GUI_IMAGECORRECTION or raises the existing
%      singleton*.
%
%      H = GUI_IMAGECORRECTION returns the handle to a new GUI_IMAGECORRECTION or the handle to
%      the existing singleton*.
%
%      GUI_IMAGECORRECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_IMAGECORRECTION.M with the given input arguments.
%
%      GUI_IMAGECORRECTION('Property','Value',...) creates a new GUI_IMAGECORRECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_ImageCorrection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_ImageCorrection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_ImageCorrection

% Last Modified by GUIDE v2.5 29-Aug-2016 12:04:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_ImageCorrection_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_ImageCorrection_OutputFcn, ...
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


% --- Executes just before GUI_ImageCorrection is made visible.
function GUI_ImageCorrection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_ImageCorrection (see VARARGIN)
% clc;
EnableStuff(hObject, handles, [1 1 0 0 1 0 0]);
handles.parentpath = cd(cd('..'));
addpath(genpath('..')); % add all relevent folders to path
NumPixels = 512; FrameRate = 5.04;
set(handles.NumPixels,'string',num2str(NumPixels));
set(handles.FrameRate,'string',num2str(FrameRate));
handles.fix_params = [round(NumPixels/4), 1.025, 25, 1, 0.6]; %[mid_amp, thresh, smooth_span, stretch, gaussfiltsigma];
% Choose default command line output for GUI_ImageCorrection
handles.output = hObject;

axes(handles.axes1); imshow(zeros(512)); colormap(jet(255));
title('Before - Original Image'); 
axes(handles.axes2); imshow(zeros(512)); colormap(jet(255));
title('After - Corrected Image');


axes(handles.axes4); image(imread('blinderlab.JPG')); axis off; box on; ax = gca; ax.BoxStyle = 'back';
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_ImageCorrection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_ImageCorrection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in PerformCorrectionCheck.
function PerformCorrectionCheck_Callback(hObject, eventdata, handles)
% hObject    handle to PerformCorrectionCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PerformCorrectionCheck


% --- Executes on button press in SemiPixelShiftCheck.
function SemiPixelShiftCheck_Callback(hObject, eventdata, handles)
% hObject    handle to SemiPixelShiftCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SemiPixelShiftCheck
if (get(hObject,'Value') == get(hObject,'Max'))
% 	display('Selected');
    set(handles.ManualPixelShiftCheck, 'Value', 0);
    set(handles.ManualShiftText, 'enable', 'off');
else
% 	display('Not selected');
end


% --- Executes on button press in StretchCheck.
function StretchCheck_Callback(hObject, eventdata, handles)
% hObject    handle to StretchCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of StretchCheck
if (get(hObject,'Value') == get(hObject,'Max'))
% 	display('Selected');
    handles.fix_params(4) = 1;
else
% 	display('Not selected');
    handles.fix_params(4) = 0;
end
guidata(hObject, handles);


% --- Executes on button press in FinTuningButton.
function FinTuningButton_Callback(hObject, eventdata, handles)
% hObject    handle to FinTuningButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'mid amplitutude:','threshold:','smoothing span','Gausian Filter Sigma'};
dlg_title = 'Fine Tuning inputs';
num_lines = 1;
defaultans = {num2str(handles.fix_params(1)),num2str(handles.fix_params(2)),num2str(handles.fix_params(3)),num2str(handles.fix_params(4))};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
if isempty(answer) 
    return;
else
    handles.fix_params(1) = str2double(answer{1});
    handles.fix_params(2) = str2double(answer{2});
    handles.fix_params(3) = str2double(answer{3});
    handles.fix_params(5) = str2double(answer{4});
end
guidata(hObject, handles);


% --- Executes on button press in PerformCorrectionButton.
function PerformCorrectionButton_Callback(hObject, eventdata, handles)
% hObject    handle to PerformCorrectionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Perform Pixel Shift
if (get(handles.SemiPixelShiftCheck, 'Value')) == 1 
    [ X_ShiftVal, Y_ShiftVal ] = SemiAutoFindPixelShift( handles.S.ImageMat );
    [ RasterMat ] = Mat2Raster( handles.S.ImageMat );
    [ OutMatRastered ] = PixelShiftX( RasterMat, X_ShiftVal );
    [ OutMat ] = Raster2Mat( OutMatRastered );
    set(handles.ManualShiftText,'String',num2str(X_ShiftVal));
elseif ((get(handles.SemiPixelShiftCheck, 'Value')) == 0) && ((get(handles.ManualPixelShiftCheck, 'Value')) == 1)
    X_ShiftVal = str2double(get(handles.ManualShiftText, 'String'));
    [ RasterMat ] = Mat2Raster( handles.S.ImageMat );
    [ OutMatRastered ] = PixelShiftX( RasterMat, X_ShiftVal );
    [ OutMat ] = Raster2Mat( OutMatRastered );
else
    OutMat = handles.S.ImageMat;
end
if (get(handles.PerformCorrectionCheck, 'Value')) == 1 %Perform Correction
    handles.fix_params(4) = get(handles.StretchCheck,'Value');
    [ NewMat ] = CorrectImage2( OutMat, handles.S.NumPixels, handles.S.CorrRise, handles.S.CorrFall, handles.fix_params);
else
    NewMat = OutMat;
end
% CLEANUP the fixed Mat
NewMat(NewMat < mean(mean((NewMat)))) = 0;
NewMat(NewMat > 255) = 255;
handles.S.CorrectedMat = NewMat;

% LightsShow
axes(handles.axes1);
for i = 1:5
    pause(0.2); colormap(jet(255)); pause(0.2); colormap(gray(255));
end

imshow(handles.S.CorrectedMat,'Colormap',jet(255),'Parent', handles.axes2);
allCmaps = get(handles.ColormapMenu,'string');
selectedIndex = get(handles.ColormapMenu,'Value');
Cmap = [allCmaps{selectedIndex}, '(255)'];
axes(handles.axes2); colormap(Cmap);
title('After - Corrected Image');

EnableStuff(hObject, handles, [2 2 2 2 2 1 1]);
guidata(hObject, handles);

% --- Executes on button press in LoadImage.
function LoadImage_Callback(hObject, eventdata, handles)
% hObject    handle to LoadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ImageMat = LoadImageFile( );
handles.S.ImageMat = ImageMat;
% imshow(ImageMat,'Colormap',jet(255),'Parent', handles.axes1);
imshow(ImageMat,'Parent', handles.axes1);

allCmaps = get(handles.ColormapMenu,'string');
selectedIndex = get(handles.ColormapMenu,'Value');
Cmap = [allCmaps{selectedIndex}, '(255)'];
axes(handles.axes1); colormap(Cmap);
title('Before - Original Image'); %axis equal; 

EnableStuff(hObject, handles, [2 2 1 2 2 2 2]);

guidata(hObject, handles);



% --- Executes on button press in LoadCorrectionButton.
function LoadCorrectionButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadCorrectionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Correctionfilename = ['C:\Users\HR\Desktop\Eran&Hagai_FinalProject\Data\CorrectionData\5_04.mat'];
[file,path] = uigetfile('*.mat','Open Correction Data', Correctionfilename);
Correctionfilename = fullfile(path, file);
S = load(Correctionfilename);
handles.S = S;
EnableStuff(hObject, handles, [2 2 2 1 2 2 2]);
guidata(hObject, handles);



% --- Executes on button press in SaveCorrectedImageButton.
function SaveCorrectedImageButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveCorrectedImageButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uiputfile('*.tif','Save Data As', [pwd, '\Results'] );
imwrite(handles.S.CorrectedMat,fullfile(path,file));


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


% --- Executes on selection change in RiseVecStyleMenu.
function RiseVecStyleMenu_Callback(hObject, eventdata, handles)
% hObject    handle to RiseVecStyleMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RiseVecStyleMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RiseVecStyleMenu
valR = get(handles.RiseVecStyleMenu,'Value');
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
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function RiseVecStyleMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RiseVecStyleMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',{'Regular';'Symmetric';'Rise+Fall'; 'Raw'});

% --- Executes on selection change in FallVecStyleMenu.
function FallVecStyleMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FallVecStyleMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FallVecStyleMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FallVecStyleMenu
valF = get(handles.FallVecStyleMenu,'Value');
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
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function FallVecStyleMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FallVecStyleMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',{'Regular';'Symmetric';'Rise+Fall'; 'Raw'});


% --- Executes on button press in ShowCorrectionDataButton.
function ShowCorrectionDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to ShowCorrectionDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Plots
figure;
subplot(2,2,1); plot( handles.S.TimeVec, handles.S.RiseVec, '.', handles.S.TimeVec, handles.S.LinVecRise, 'r');
title('Rising Segment'); xlabel('time [sec]');
subplot(2,2,3); plot( handles.S.TimeVec, handles.S.CorrRise, '.');
title('Correction'); xlabel('time [sec]');
subplot(2,2,2); plot( handles.S.TimeVec, fliplr(handles.S.FallVec), '.', handles.S.TimeVec, fliplr(handles.S.LinVecFall), 'r');
title('Falling Segment'); xlabel('time [sec]');
subplot(2,2,4); plot( handles.S.TimeVec, handles.S.CorrFall, '.'); 
title('Correction'); xlabel('time [sec]');


% --- Executes on button press in RunSimulationButton.
function RunSimulationButton_Callback(hObject, eventdata, handles)
% hObject    handle to RunSimulationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% [ ImageMat ] = CreateRealSimulationMat(512);
handles.S.ImageMat = CreateSimulationMat(512);

imshow(handles.S.ImageMat,'Colormap',jet(255),'Parent', handles.axes1);
axes(handles.axes1); title('After Correction treatment'); %axis equal; 
guidata(hObject, handles);


% --- Executes on button press in SaveAllDataButton.
function SaveAllDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveAllDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = handles.S;
[file,path] = uiputfile('*.mat','Save Data As', [pwd, '\Results'] );
save(fullfile(path,file), '-struct', 'S');


% --- Executes on button press in ManualPixelShiftCheck.
function ManualPixelShiftCheck_Callback(hObject, eventdata, handles)
% hObject    handle to ManualPixelShiftCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ManualPixelShiftCheck
if (get(hObject,'Value') == get(hObject,'Max'))
% 	display('Selected');
    set(handles.SemiPixelShiftCheck, 'Value', 0);
    set(handles.ManualShiftText, 'enable', 'on');
    
else
% 	display('Not selected');
    set(handles.ManualShiftText, 'enable', 'off');
end



function ManualShiftText_Callback(hObject, eventdata, handles)
% hObject    handle to ManualShiftText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ManualShiftText as text
%        str2double(get(hObject,'String')) returns contents of ManualShiftText as a double


% --- Executes during object creation, after setting all properties.
function ManualShiftText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ManualShiftText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ColormapMenu.
function ColormapMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ColormapMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ColormapMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ColormapMenu
allCmaps = get(handles.ColormapMenu,'string');
selectedIndex = get(handles.ColormapMenu,'Value');
Cmap = [allCmaps{selectedIndex}, '(255)'];
axes(handles.axes1); colormap(Cmap);
axes(handles.axes2); colormap(Cmap);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function ColormapMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ColormapMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',{'jet';'gray';'parula'});

function EnableStuff(hObject, handles, EnableVec)
% hObject    handle to LoadCorrectionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if EnableVec(1) == 1 
    set(handles.LoadCorrectionButton, 'Enable', 'on');
elseif EnableVec(1) == 0 
    set(handles.LoadCorrectionButton, 'Enable', 'off');
end

if EnableVec(2) == 1 
    set(handles.LoadImage, 'Enable', 'on');
elseif EnableVec(2) == 0 
    set(handles.LoadImage, 'Enable', 'off');
end

if EnableVec(3) == 1 
    set(handles.PerformCorrectionButton, 'Enable', 'on');
elseif EnableVec(3) ==0 
    set(handles.PerformCorrectionButton, 'Enable', 'off');
end

if EnableVec(4) == 1 
    set(handles.ShowCorrectionDataButton, 'Enable', 'on');
elseif EnableVec(4) == 0
    set(handles.ShowCorrectionDataButton, 'Enable', 'off');
end

if EnableVec(5) == 1 
    set(handles.RunSimulationButton, 'Enable', 'on');
elseif EnableVec(5) == 0 
    set(handles.RunSimulationButton, 'Enable', 'off');
end

if EnableVec(6) == 1 
    set(handles.SaveAllDataButton, 'Enable', 'on');
elseif EnableVec(6) == 0
    set(handles.SaveAllDataButton, 'Enable', 'off');
end

if EnableVec(7) == 1 
    set(handles.SaveCorrectedImageButton, 'Enable', 'on');
elseif EnableVec(7) == 0 
    set(handles.SaveCorrectedImageButton, 'Enable', 'off');
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ManualPixelShiftCheck_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ManualPixelShiftCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes4
% axes(handles.axes4);
% image(imread('PBlab-logo-TAU1.png'));
% imshow(imread('PBlab-logo-TAU1.png'),'Parent', handles.axes4);
guidata(hObject, handles);


% --- Executes on button press in ResetButton.
function ResetButton_Callback(hObject, eventdata, handles)
% hObject    handle to ResetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcbf);
GUI_ImageCorrection


% --- Executes on button press in ShowOddEvenLinesButton.
function ShowOddEvenLinesButton_Callback(hObject, eventdata, handles)
% hObject    handle to ShowOddEvenLinesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RasterMat = Mat2Raster( handles.S.ImageMat );
figure; imshow(RasterMat); hold on;
allCmaps = get(handles.ColormapMenu,'string');
selectedIndex = get(handles.ColormapMenu,'Value');
Cmap = [allCmaps{selectedIndex}, '(255)'];
colormap(Cmap);

x = size(RasterMat,2)/2; y = size(RasterMat,1);
plot([x, x], [0, y], 'r--'); hold off;

title('Raster Matrix - Odd lines left, Even lines right'); %axis equal; 


% --- Executes on button press in LineSwitchButton.
function LineSwitchButton_Callback(hObject, eventdata, handles)
% hObject    handle to LineSwitchButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% load stack matrix
[StackFileName,StackPathName] = uigetfile('*.mat','Select  Stack mat file', [handles.parentpath, '\Data\SampleImages\StackMatrices\Pablo1.mat'] );
stackFileName = fullfile(StackPathName,StackFileName);
load(stackFileName); % the stackfile should include an I var with the stack
% open new movie file
[Vidfilename,vidpath] = uiputfile('*.avi','Save Output Video as',[handles.parentpath,'\ImageCorrection\Results\StackVid.avi']);
vidFileName = fullfile(vidpath, Vidfilename);

userDefinedReps = 30;

StackVideoCorrection( I, vidFileName,  handles.S.NumPixels, handles.S.CorrRise, handles.S.CorrFall, handles.S.fix_params, userDefinedReps );
implay(vidFileName)


% --- Executes on button press in NewCorrectionButton.
function NewCorrectionButton_Callback(hObject, eventdata, handles)
% hObject    handle to NewCorrectionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_RunMe;
