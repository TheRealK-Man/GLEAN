function GLEAN = setup(glean_name,data,settings)
% Sets up a GLEAN analysis with particular filename, settings and data.
%
% GLEAN = glean.setup(glean_name,data,settings)
%
% REQUIRED INPUTS:
%
%   glean_name  - full path and filename for the GLEAN analysis. The 
%                 metadata and results will be saved in a .mat file by this 
%                 name. Any data created by GLEAN will be saved in 
%                 subfolders within the same directory as filename. Note 
%                 that it is possible to create multiple GLEANs with 
%                 different names within the same directory. GLEAN analyses 
%                 may be run with different  settings may be contained in 
%                 the same directory but the data must NOT change.
%
%   data        - list of SPM12 MEEG files. If your data are not in this 
%                 format you can convert using glean_convert2spm
%
%   settings    - list of settings for the GLEAN analysis with subfields:
%                 [envelope, subspace, model, results]
%
% Type "help glean_check" for a list of options for each of these fields
% 
% OUTPUTS:
%   GLEAN       - Newly created GLEAN structure
%
% Adam Baker 2015


% GLEAN name
[pathstr,filestr,extstr] = fileparts(glean_name);
if isempty(extstr)
    extstr = '.mat';
elseif ~strcmp(extstr,'.mat')
    error('glean_name extension should be .mat');
end

if isempty(pathstr)
    error('glean_name should specify the full path and filename')
end

GLEAN.name = GetFullPath(fullfile(pathstr,[filestr,extstr]));
GLEAN.data = GetFullPath(data);


% Copy settings to GLEAN structure:
for stage = {'envelope','subspace','model','results'}
    try
        GLEAN.(char(stage)).settings = settings.(char(stage));
    catch 
        GLEAN.(char(stage)).settings = [];
    end
end

% Run glean_check, which checks all settings and sets up the directory and data fields:
GLEAN = glean.check(GLEAN);

% Save GLEAN
save(GLEAN.name,'GLEAN');
























