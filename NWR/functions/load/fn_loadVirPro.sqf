if (!isServer) exitwith {false};

if(isNil "NWR_INI") exitWith {};

_profileCount= ["read", ["VirPro", "Profile_Count", 0]] call NWR_DB;

if (_profileCount == 0) exitWith {["No Profiles Found"] call NWR_fnc_message;};

_importProfiles = [];


for [{_i = 0},{_i < _profileCount},{_i = _i+1}] do
{
		_key = format["Profile-%1", _i];

		_data = ["read", ["VirPro", _key, []]] call NWR_DB;

		if (count _data > 0) then
		{
			_newProfile = ["#CBA_HASH#", _data select 0, _data select 1, nil];
			_importProfiles append [_newProfile];
		};
};


if ((count _importProfiles) > 0) then
{

	_importProfiles = ["#CBA_HASH#", nil, _importProfiles];

	[ALIVE_profileHandler,"reset"] call ALIVE_fnc_profileHandler;

	[ALIVE_profileHandler,"importProfileData",_importProfiles] call ALIVE_fnc_profileHandler;

	["Loaded Profiles"] call NWR_fnc_message;
};