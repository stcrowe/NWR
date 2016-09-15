class NWR
{
	tag = "NWR";

	class common
	{
		file = "NWR\functions"
		class initNWR {postInit = 1;}
		class message {};
	};


	class save
	{
		file = "NWR\functions\save";

		class saveVirPro {};
		class saveMilLog {};
		class saveMilObj {};
	};

	class load
	{
		file = "NWR\functions\load";

		class loadVirPro {};
		class loadMilLog {};
		class loadMilObj {};

	};
};
