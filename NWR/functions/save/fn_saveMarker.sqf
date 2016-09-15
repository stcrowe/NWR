if (!isServer) exitwith {false};

if(isNil "NWR_INI") exitWith {};

//Delete old entry
["deleteSection", "Markers"] call NWR_DB;

_data = [ALIVE_sys_marker,"state"] call ALiVE_fnc_marker;

_markerIDs = _data select 1;


if (count _markerIDs > 0) then
{
	{
		_markerDataHash = (_data select 2);

		// We first strip the #CBA_HASH# and the nil from each value
	    _markerData = _markerDataHash select _forEachIndex;
	    _markerDataStripped = [];

	    for [{_j=1},{_j < ((count _markerData) - 1)},{_j=_j+1}] do
	    {
	        _markerDataStripped append [_markerData select _j];
	    };

		["write", ["Markers",format ["MarkerId-%1", _forEachIndex], _x]] call NWR_DB;
		["write", ["Markers",format ["MarkerData-%1", _forEachIndex], _markerDataStripped ]] call NWR_DB;

	} forEach _markerIDs;

};

["write", ["Markers", "Marker_Count", (count _markerIDs) ]] call NWR_DB;


["Markers Saved"] call NWR_fnc_message;