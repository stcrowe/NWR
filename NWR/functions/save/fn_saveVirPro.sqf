if (!isServer) exitwith {false};

if(isNil "NWR_INI") exitWith {};

//Delete old entry
["deleteSection", "VirPro"] call NWR_DB;

// Get all the data [CBAHASE, [keys], [values], nil]
_profileData = [ALIVE_profileHandler, "exportProfileData"] call ALIVE_fnc_profileHandler;

// We only care about [values]
_profiles = _profileData select 2;

_profileCount = 0;

// Go through each value and save it to the database
for [{_i=0},{_i< (count _profiles)},{_i=_i+1}] do
{

	// We first strip the #CBA_HASH# and the nil from each value
    _data = _profiles select _i;
    _dataStripped = [];

    for [{_j=1},{_j < ((count _data) - 1)},{_j=_j+1}] do
    {
        _dataStripped append [_data select _j];
    };

    ["write", ["VirPro",format ["Profile-%1", _i], _dataStripped]] call NWR_DB;

    _profileCount = _profileCount + 1;

};

["write", ["VirPro", "Profile_Count", _profileCount]] call NWR_DB;

["Saved Profiles"] call NWR_fnc_message;

