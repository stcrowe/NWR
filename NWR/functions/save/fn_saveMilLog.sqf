if (!isServer) exitwith {};

if(isNil "NWR_INI") exitWith {};

private ["_data", "_write", "_message"];

// Get data
_data = ALIVE_globalForcePool;

if (count (_data select 1) == 0) exitwith {};

// Write data
_write = ["write", ["MilLog", "ForcePool", _data]] call NWR_DB;


// Send message to clients

_message = "Saved Military Logistics";

if (!_write) then
{
	_message= "Failed to save Military Logistics";
};

[_message] call NWR_fnc_message;

