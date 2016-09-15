if (!isServer) exitwith {false};

if(isNil "NWR_INI") exitWith {};

if (!(ALIVE_sys_data_DISABLED)) exitWith {};

_data = [MOD(SYS_patrolrep),"state"] call ALiVE_fnc_patrolrep;

if (count (_data select 1) == 0) exitwith {

// Write data
_write = ["write", ["Reps", "RepData", _data]] call NWR_DB;


