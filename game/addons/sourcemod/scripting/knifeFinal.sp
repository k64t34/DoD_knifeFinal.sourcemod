#define DEBUG 1
#define PLUGIN_VERSION "1.1"
#define PLUGIN_NAME "Knife final"
#define GAME_DOD
#include "k64t"
#include "dodhooks"
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
int g_iDesiredPlayerClass;
int g_hPlayerRespawn;
Handle g_hGameConfig;
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

/*StartPrepSDKCall(SDKCall_Player);
PrepSDKCall_SetFromConf(g_hGameConfig, SDKConf_Signature, "DODRespawn");
if ((g_hPlayerRespawn = EndPrepSDKCall()) == INVALID_HANDLE)
	{
	SetFailState("Fatal Error: Unable to find signature \"DODRespawn\"!");
	}
if ((g_iDesiredPlayerClass = FindSendPropInfo("CDODPlayer", "m_iDesiredPlayerClass")) == -1)
	{
	SetFailState("Fatal Error: Unable to find offset \"m_iDesiredPlayerClass\"!");
	}	*/
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
	UnhookEvent("player_death",	Event_PlayerDeath,EventHookMode_Post);
}
public  Action knifeFinal (int args){
	#if defined DEBUG
	DebugPrint("knifeFinal");
	#endif 
	//g_knifeFinal=1;
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);
	HookEvent("player_death",		Event_PlayerDeath,EventHookMode_Post);
	//TODO: Убрать всё оружие с карты
	//TODO: На время победы в раунде прекратить мнговенное рождение
	//HookEvent("dod_round_win", PlayerRoundWinEvent);
	//public PlayerRoundWinEvent(Handle:event, const String:name[], bool:dontBroadcast) 
	//dod_round_active
	//Note: When the round becomes active after the "frozen" time
	for (int i=1;i!=MaxClients;i++)
	{
		int intBuff=GetClientTeam(i);
		if (intBuff==DOD_TEAM_ALLIES || intBuff==DOD_TEAM_AXIS)			
		if(IsPlayerAlive(i)) 
		RemoveWeaponFromPlayer(i);
		
	}
	
}
public void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast){
	#if defined DEBUG
	DebugPrint("Event_PlayerDeath");
	#endif 
	int client=GetClientOfUserId(event.GetInt("userid"));
    
	
	/*if (GetEntData(client, g_iDesiredPlayerClass) != -1)
	{
		SDKCall(g_hPlayerRespawn, client);
	}*/
	CreateTimer(0.1,PlayerSpawn,client,TIMER_FLAG_NO_MAPCHANGE);
}
public  Action PlayerSpawn(Handle timer,int client){
	#if defined DEBUG
	DebugPrint("PlayerSpawn");
	#endif 
	Event newevent = CreateEvent("player_spawn");
    if (newevent == null)
    {
		#if defined DEBUG
		DebugPrint("PlayerSpawn fail");
		#endif 
        return Plugin_Stop;		
    } 
    newevent.SetInt("userid",GetClientUserId(client) );    
    newevent.Fire();	
	DispatchSpawn(client);
	return Plugin_Stop;
}
public void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast){
	#if defined DEBUG
	DebugPrint("Event_PlayerSpawn");
	#endif 	
	int client=GetClientOfUserId(event.GetInt("userid"));	
	RemoveWeaponFromPlayer(client);
}
void RemoveWeaponFromPlayer(int client){
	RemoveWeaponBySlot(client, Slot_Grenade);
	RemoveWeaponBySlot(client, Slot_Primary);
	RemoveWeaponBySlot(client, Slot_Secondary);
	RemoveWeaponBySlot(client, Slot_Melee);
	
	
	
	//TODO:Switch active weapon to Melee
	//Client_SetActiveWeapon(client, GetPlayerWeaponSlot(client, 1)); 
	//https://forums.alliedmods.net/showthread.php?t=225180
	
	//SDKHook_WeaponSwitch,
	GivePlayerItem(client, "weapon_amerknife");	
	//GivePlayerItem(client, "weapon_spade");	
	
	//Client_SetActiveWeapon(client, GetPlayerWeaponSlot(client, 1)); FROM SMLIB
	//stock Client_SetActiveWeapon(client, weapon)
	//SetEntPropEnt(client, Prop_Data, "m_hActiveWeapon", weapon);
	//ChangeEdictState(client, FindDataMapOffs(client, "m_hActiveWeapon"));


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
//weapon list
//https://github.com/zadroot/GunMenu/blob/master/configs/weapons.ini
//https://github.com/zadroot/GunMenu/blob/master/scripting/dod_gunmenu.sp




bool:IsValidClient(client)
{
	return (1 <= client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) > TEAM_SPECTATOR) ? true : false;
}



//"weapon_smoke_us"  "US Smoke Grenade"
//"weapon_smoke_ger" "Stick Smoke Grenade"


// player class
//https://github.com/Bara/PlayerRespawn/blob/master/addons/sourcemod/scripting/include/dodhooks.inc