function [p,tab,chi2,labels] = mediantest(varargin)

% [p,tab,chi2,labels] = mediantest(varargin) performes Mood's mediantest: Mood's Median Test compares the medians of
% two or more groups. The test counts how many observations in each group
% are greater than the global median for all groups together and
% calculuates Chi-square statistics on those obervations.
% Less powerful than Kruskal-Wallis test, but require fewer assumptions.
%
% Inputs can be entered in several ways:
%     - individual data groups [e.g. mediantest(dataset1,dataset2,dataset3)] in which each dataset is a vector of continous responses, or data vector and group
%     - 2-column matrix containing responses (data) and groups identifier
%     - table containing columns 'data' and 'group'


inputClass = class(varargin{1});

inputData = varargin;

switch inputClass
    case 'table'
        t = inputData{1};
        data = t.data;
        groups = t.groups;
    case 'double'  
        if numel(inputData)<2 % NOT ENOUGH GROUPS
        warning('Please specify at least two groups.'), return
        elseif numel(inputData)>2 % assume data entered as several input arguments
            % SORT DATA
            [data, groups] = sortData(inputData);      
        elseif numel(inputData) == 2 % COULD BE TWO GROUPS OR DATA/GROUP
            isCat = cellfun(@iscategorical, inputData);
            if any(isCat) % IF ONE VECTOR IS CATEGORICAL ONE INPUT ARE DATA SECOND IS GROUP
                data = inputData{~isCat};
                groups = inputData{isCat};
            else
                [data, groups] = sortData(inputData);
            end
        end     
end

[tab,chi2,p,labels] = crosstab(data>median(data),groups);

end

function [data,groups] = sortData(inputData)
nGroups = numel(inputData);
g = cell(nGroups,1);
d = cell(nGroups,1);

for iG=1:nGroups
    g{iG} = repmat(iG,size(inputData{iG}(:)));
    d{iG} = inputData{iG}(:);
end

groups = cell2mat(g);
data = cell2mat(d);

end

