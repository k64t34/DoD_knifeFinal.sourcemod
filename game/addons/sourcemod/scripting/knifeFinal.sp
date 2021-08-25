#define DEBUG 1
#define PLUGIN_VERSION "1.0"
#define PLUGIN_NAME "Knife final"
#include "k64t"
//#define SND_hour	"k64t\\knifeFinal\\.mp3"
enum Slots
{
	Slot_Primary,
	Slot_Secondary,
	Slot_Melee,
	Slot_Grenade
};
// Global Var
//int g_knifeFinal=0; //0 - normal, 1- knife only
public Plugin myinfo =
{
    name = PLUGIN_NAME,
    author = "Kom64t",
    description = "Knife final",
    version = PLUGIN_VERSION,
    url = "https://github.com/k64t34/DoD_knifeFinal.sourcemod"
};
//***********************************************
public void OnPluginStart(){
//***********************************************
#if defined DEBUG
DebugPrint("OnPluginStart");
#endif 
LoadTranslations("knifeFinal.phrases");
#if defined DEBUG	
RegServerCmd("knifeFinal",knifeFinal);	
#endif 
//char buffer[MAX_FILENAME_LENGHT];
//Format(buffer, MAX_FILENAME_LENGHT, "download\\sound\\%s",SND_hour);	
//AddFileToDownloadsTable(buffer);
//PrecacheSound(SND_hour,true);
//AutoExecConfig(true, "knifeFinal");
}
#if defined DEBUG
//***********************************************
public void OnMapStart(){
//***********************************************
DebugPrint("OnMapStart");
}
#endif 
public void OnMapEnd() {
	#if defined DEBUG
	DebugPrint("OnMapEnd");
	#endif 
	//g_knifeFinal=0;
	UnhookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);
}
public  Action knifeFinal (int args){
	#if defined DEBUG
	DebugPrint("knifeFinal");
	#endif 
	//g_knifeFinal=1;
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);
}
public void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast){
	#if defined DEBUG
	DebugPrint("Event_PlayerSpawn");
	#endif 	
	int client=GetClientOfUserId(event.GetInt("userid"));
	RemoveWeaponBySlot(client, Slot_Primary);
	RemoveWeaponBySlot(client, Slot_Secondary);
	RemoveWeaponBySlot(client, Slot_Grenade);	
}
void RemoveWeaponBySlot(int client, Slots slot){
	int weapon = GetPlayerWeaponSlot(client, slot);	
	if (IsValidEdict(weapon))
	{		
		RemovePlayerItem(client, weapon);
		AcceptEntityInput(weapon, "Kill");
	}
}
#endinput
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
//https://github.com/zadroot/GunMenu/blob/master/scripting/dod_gunmenu.sp
