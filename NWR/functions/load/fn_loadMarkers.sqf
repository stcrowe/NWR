if (!isServer) exitwith {false};

if(isNil "NWR_INI") exitWith {};

// Get old markers and delete - may need to be localized
_data = [ALIVE_sys_marker,"state"] call ALiVE_fnc_marker;

_oldMarkerIds = _data select 1;

{
	[ALIVE_sys_marker, "removeMarker", [_x]] call ALiVE_fnc_marker;
} forEach _oldMarkerIds;


// Get stored markers
_markerCount= ["read", ["Markers", "Marker_Count", 0]] call NWR_DB;

if (_markerCount == 0) exitWith {["No Markers Found"] call NWR_fnc_message;};

_markerIds = [];
_markerDatas = [];

for [{_i = 0},{_i < _markerCount},{_i = _i+1}] do
{
	_idKey = format["MarkerId-%1", _i];
	_dataKey = format["MarkerData-%1", _i];

	_markerID = ["read", ["Markers", _idKey , ""]] call NWR_DB;
	_markerData = ["read", ["Markers", _dataKey , ""]] call NWR_DB;


	_markerIds append [_markerID];

	_markerDataHash = ["#CBA_HASH#"];

	for [{_j = 0},{_j < count _markerData},{_j = _j+1}] do
	{

		_markerDataHash append [(_markerData select _j)];

	};

	_markerDataHash append [nil];


	_markerDatas append [_markerDataHash];
};


_markerDataSync = ["#CBA_HASH#", _markerIds, _markerDatas, nil];


ALiVE_sys_marker_store = _markerDataSync;

// Restore markers so they appear on may - may need to be localized
[ALiVE_sys_marker, "restoreMarkers", [ALiVE_sys_marker_store]] call ALiVE_fnc_marker;

["Markers Loaded"] call NWR_fnc_message;
