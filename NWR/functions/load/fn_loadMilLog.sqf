if (!isServer) exitwith {false};

if(isNil "NWR_INI") exitWith {};

// Read data
_data = ["read", ["MilLog", "ForcePool", nil]] call NWR_DB;

if (isNil "_data") exitWith {["Failed to load Military Logistics"] call NWR_fnc_message;};

// Set the logistics
ALIVE_globalForcePool = _data;

["Loaded Military Logistics"] call NWR_fnc_message;