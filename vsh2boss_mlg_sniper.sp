#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <tf2_stocks>
#include <vsh2>

#undef REQUIRE_PLUGIN
#tryinclude <tf2attributes>
#define REQUIRE_PLUGIN

///Simple boss constructed on vsh2boss_template.sp
///VSH2 2.6.15

///Materials (only .bz2): https://yadi.sk/d/ASEDxuUPh9-tVw

#define MLGSniperModel    "models/freak_fortress_2/mlgsniper/mlgsniper.mdl"
#define MtnDewModel		"models/freak_fortress_2/mlgsniper/mountain_dew.mdl"

/// voicelines
char MLGSniperIntro[][] = {
	"freak_fortress_2/mlgsniper/mlgsniper_intro.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_intro2.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_intro3.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_intro4.mp3"
};

char MLGSniperJump[][] = {
	"freak_fortress_2/mlgsniper/mlgsniper_superjump.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_superjump2.mp3"
};

char MLGSniperStab[][] = {///Vanilla voicelines
	"vo/sniper_jeers01.wav",
	"vo/sniper_jeers03.wav",
	"vo/sniper_jeers07.wav",
	"vo/sniper_jeers08.wav"
};

char MLGSniperDeath[][] = {
	"freak_fortress_2/mlgsniper/mlgsniper_death.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_death2.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_death3.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_death4.mp3"
};

char MLGSniperLast[][] = {
	"freak_fortress_2/mlgsniper/mlgsniper_lastman.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_lastman2.mp3"
};

char MLGSniperRage[][] = {
	"freak_fortress_2/mlgsniper/mlgsniper_rage.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_rage2.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_rage3.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_rage4.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_rage5.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_rage6.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_rage7.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_rage8.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_rage9.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_rage10.mp3"
};

char MLGSniperKill[][] = {
	"freak_fortress_2/mlgsniper/mlgsniper_kill.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_kill2.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_kill3.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_kill4.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_kill5.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_kill6.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_kill7.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_kill8.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_kill9.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_kill10.mp3"
};

char MLGSniperSpree[][] = {
	"freak_fortress_2/mlgsniper/mlgsniper_kspree.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_kspree2.mp3"
};

char MLGSniperWin[][] = {
	"freak_fortress_2/mlgsniper/mlgsniper_win.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_win2.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_win3.mp3",
	"freak_fortress_2/mlgsniper/mlgsniper_win4.mp3"
};

char MLGSniperLostLive[][] = {
	"freak_fortress_2/mlgsniper/mlgsniper_lostlife.mp3"
};

char MLGSniperThemes[][] = {
	"freak_fortress_2/mlgsniper/mlgsniper_bgm.mp3"
};

float MLGSniperThemesTime[] = {
	76.0
};

char MLGSniperMaterial[][] = {
	"materials/models/player/mlgsniper/eyeball_l.vmt",
	"materials/models/player/mlgsniper/eyeball_l.vtf",
	"materials/models/player/mlgsniper/eyeball_r.vmt",
	"materials/models/player/mlgsniper/eyeball_r.vtf",
	"materials/models/player/mlgsniper/mlgsniper_fedora.vmt",
	"materials/models/player/mlgsniper/mlgsniper_fedora_blue.vmt",
	"materials/models/player/mlgsniper/mlgsniper_fedora_color.vtf",
	"materials/models/player/mlgsniper/mountain_dew.vmt",
	"materials/models/player/mlgsniper/mountain_dew.vtf",
	"materials/models/player/mlgsniper/mountain_dew_blue.vmt",
	"materials/models/player/mlgsniper/mountain_dew_blue.vtf",
	"materials/models/player/mlgsniper/spookness.vmt",
	"materials/models/player/mlgsniper/spookness.vtf"
};

public Plugin myinfo = {
	name = "VSH2 MLG Sniper",
	author = "FF2: MrYtem39; VSH2: PavelKom",
	description = "MLG Sniper boss plugin (ported from FF2)",
	version = "0.5",
	url = "bans.gamingfortress.ru"
};

/**
TODO:
	Add second live | DONE | Not tested!!!
	Add screamer	(rage_overlay)
	Add Mnt dew can ragdoll drop	(spawn model on kill) | DONE | Not tested!!!
	Add slowmo (maybe not)
**/

int g_iMLGSniperID;

enum struct VSH2CVars {
	ConVar scout_rage_gen;
	ConVar airblast_rage;
	ConVar jarate_rage;
}

VSH2CVars g_vsh2_cvars;


public void OnLibraryAdded(const char[] name) {
	if( StrEqual(name, "VSH2") ) {
		g_vsh2_cvars.scout_rage_gen = FindConVar("vsh2_scout_rage_gen");
		g_vsh2_cvars.airblast_rage = FindConVar("vsh2_airblast_rage");
		g_vsh2_cvars.jarate_rage = FindConVar("vsh2_jarate_rage");
		g_iMLGSniperID = VSH2_RegisterPlugin("mlg_sniper");
		LoadVSH2Hooks();
	}
}

public void LoadVSH2Hooks()
{
	if( !VSH2_HookEx(OnCallDownloads, MLGSniper_OnCallDownloads) )
		LogError("Error loading OnCallDownloads forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnBossMenu, MLGSniper_OnBossMenu) )
		LogError("Error loading OnBossMenu forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnBossSelected, MLGSniper_OnBossSelected) )
		LogError("Error loading OnBossSelected forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnBossThink, MLGSniper_OnBossThink) )
		LogError("Error loading OnBossThink forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnBossModelTimer, MLGSniper_OnBossModelTimer) )
		LogError("Error loading OnBossModelTimer forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnBossEquipped, MLGSniper_OnBossEquipped) )
		LogError("Error loading OnBossEquipped forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnBossInitialized, MLGSniper_OnBossInitialized) )
		LogError("Error loading OnBossInitialized forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnBossPlayIntro, MLGSniper_OnBossPlayIntro) )
		LogError("Error loading OnBossPlayIntro forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnPlayerKilled, MLGSniper_OnPlayerKilled) )
		LogError("Error loading OnPlayerKilled forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnPlayerHurt, MLGSniper_OnPlayerHurt) )
		LogError("Error loading OnPlayerHurt forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnPlayerAirblasted, MLGSniper_OnPlayerAirblasted) )
		LogError("Error loading OnPlayerAirblasted forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnBossMedicCall, MLGSniper_OnBossMedicCall) )
		LogError("Error loading OnBossMedicCall forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnBossTaunt, MLGSniper_OnBossMedicCall) )
		LogError("Error loading OnBossTaunt forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnBossJarated, MLGSniper_OnBossJarated) )
		LogError("Error loading OnBossJarated forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnRoundEndInfo, MLGSniper_OnRoundEndInfo) )
		LogError("Error loading OnRoundEndInfo forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnMusic, MLGSniper_Music) )
		LogError("Error loading OnBossDealDamage forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnBossDeath, MLGSniper_OnBossDeath) )
		LogError("Error loading OnBossDeath forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnBossTakeDamage_OnStabbed, MLGSniper_OnStabbed) )
		LogError("Error loading OnBossTakeDamage_OnStabbed forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnLastPlayer, MLGSniper_OnLastPlayer) )
		LogError("Error loading OnLastPlayer forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnSoundHook, MLGSniper_OnSoundHook) )
		LogError("Error loading OnSoundHook forwards for MLGSniper subplugin.");
	
	if( !VSH2_HookEx(OnBossCalcHealth, MLGSniper_OnBossCalcHealth) )
		LogError("Error loading OnBossCalcHealth forwards for MLGSniper subplugin.");
}



stock bool IsMLGSniper(const VSH2Player player) {
	return player.GetPropInt("iBossType") == g_iMLGSniperID;
}


public void MLGSniper_OnCallDownloads()
{
	PrepareModel(MLGSniperModel);
	PrepareModel(MtnDewModel);
	DownloadSoundList(MLGSniperIntro, sizeof(MLGSniperIntro));
	DownloadSoundList(MLGSniperJump, sizeof(MLGSniperJump));
	//DownloadSoundList(MLGSniperStab, sizeof(MLGSniperStab));
	DownloadSoundList(MLGSniperDeath, sizeof(MLGSniperDeath));
	DownloadSoundList(MLGSniperLast, sizeof(MLGSniperLast));
	DownloadSoundList(MLGSniperRage, sizeof(MLGSniperRage));
	DownloadSoundList(MLGSniperKill, sizeof(MLGSniperKill));
	DownloadSoundList(MLGSniperSpree, sizeof(MLGSniperSpree));
	DownloadSoundList(MLGSniperWin, sizeof(MLGSniperWin));
	DownloadSoundList(MLGSniperLostLive, sizeof(MLGSniperLostLive));
	DownloadSoundList(MLGSniperThemes, sizeof(MLGSniperThemes));
	
	PrecacheSoundList(MLGSniperStab, sizeof(MLGSniperStab));
	
	DownloadMaterialList(MLGSniperMaterial, sizeof(MLGSniperMaterial));
}

public void MLGSniper_OnBossMenu(Menu &menu)
{
	char tostr[10]; IntToString(g_iMLGSniperID, tostr, sizeof(tostr));
	menu.AddItem(tostr, "MLG Sniper");
}

public void MLGSniper_OnBossSelected(const VSH2Player player)
{
	if( !IsMLGSniper(player) )
		return;
	
	player.SetPropInt("iCustomProp", 0);
	player.SetPropFloat("flCustomProp", 0.0);
	player.SetPropAny("hCustomProp", player);
	
	Panel panel = new Panel();
	panel.SetTitle("MLG Sniper:\n'God save the Weed!'\nSuper Jump: alt-fire, look up and stand up.\nWeigh-Down: in midair, look down and crouch.\nRage (MLG Spooks and Awper Hand): call for Medic when the Rage Meter is full.\nLoomynarty and Skeletons will spook the enemies for you, and you grab an Awper Hand.\nAim for the head if you are MLG enough!\nLostlife (Weed): Slows down enemies, but also your brain, making you fast like Sanic.\nAim at an enemy, then press M1 to lunge instantly at the scrub.");
	panel.DrawItem("Exit");
	panel.Send(player.index, HintPanel, 50);
	delete panel;
}

public void MLGSniper_OnBossThink(const VSH2Player player)
{
	int client = player.index;
	if( !IsPlayerAlive(client) || !IsMLGSniper(player) )
		return;
	
	VSH2_SpeedThink(player, 340.0);
	VSH2_GlowThink(player, 0.1);
	if( VSH2_SuperJumpThink(player, 2.5, 25.0) ) {
		player.PlayVoiceClip(MLGSniperJump[GetRandomInt(0, sizeof(MLGSniperJump)-1)], VSH2_VOICE_ABILITY);
		player.SuperJump(player.GetPropFloat("flCharge"), -100.0);
	}
	
	if( OnlyScoutsLeft(VSH2Team_Red) )
		player.SetPropFloat("flRAGE", player.GetPropFloat("flRAGE") + g_vsh2_cvars.scout_rage_gen.FloatValue);
	
	VSH2_WeighDownThink(player, 2.0, 0.1);
	
	/// hud code
	SetHudTextParams(-1.0, 0.77, 0.35, 255, 255, 255, 255);
	Handle hud = VSH2GameMode_GetHUDHandle();
	float jmp = player.GetPropFloat("flCharge");
	float rage = player.GetPropFloat("flRAGE");
	if( rage >= 100.0 )
		ShowSyncHudText(client, hud, "Jump: %i%% | Rage: FULL - Call Medic (default: E) to activate", player.GetPropInt("bSuperCharge") ? 1000 : RoundFloat(jmp) * 4);
	else ShowSyncHudText(client, hud, "Jump: %i%% | Rage: %0.1f", player.GetPropInt("bSuperCharge") ? 1000 : RoundFloat(jmp) * 4, rage);
}

public void MLGSniper_OnBossModelTimer(const VSH2Player player)
{
	if( !IsMLGSniper(player) )
		return;
	int client = player.index;
	SetVariantString(MLGSniperModel);
	AcceptEntityInput(client, "SetCustomModel");
	SetEntProp(client, Prop_Send, "m_bUseClassAnimations", 1);
}

public void MLGSniper_OnBossEquipped(const VSH2Player player)
{
	if( !IsMLGSniper(player) )
		return;
	
	player.SetName("MLG Sniper");
	player.RemoveAllItems();
	///68; 2.0	- Capture speed (+2)
	///2; 3.1	- Damage mult (*3.1) = 201.5
	///259; 1.0	- Boots stomp
	///81; 0.0	- Max metal mult (*0)
	///214; random	- Kill eater (?)
	char attribs[128]; Format(attribs, sizeof(attribs), "68; 2.0; 2; 3.1; 259; 1.0; 252; 0.6; 214; %d", GetRandomInt(999, 9999));
	int wep = player.SpawnWeapon("tf_weapon_club", 193, 100, 5, attribs);
	SetEntPropEnt(player.index, Prop_Send, "m_hActiveWeapon", wep);
}

public void MLGSniper_OnBossInitialized(const VSH2Player player)
{
	if( !IsMLGSniper(player) )
		return;
	SetEntProp(player.index, Prop_Send, "m_iClass", view_as<int>(TFClass_Sniper));
}

public Action MLGSniper_OnBossCalcHealth(const VSH2Player player, int& max_health, const int boss_count, const int red_players)
{
	if( !IsMLGSniper(player) )
		return Plugin_Continue;
	player.SetPropInt("iLives", 2);
	
	max_health = RoundFloat( Pow((((240.0)+red_players)*(red_players)), 1.0341)+1023 ) / (boss_count);
	
	if (max_health < 1500 && boss_count == 1)
		max_health = 1500;
	return Plugin_Changed;
}

public void MLGSniper_OnBossPlayIntro(const VSH2Player player)
{
	if( !IsMLGSniper(player) )
		return;
	player.PlayVoiceClip(MLGSniperIntro[GetRandomInt(0, sizeof(MLGSniperIntro)-1)], VSH2_VOICE_INTRO);
}

public void MLGSniper_OnPlayerKilled(const VSH2Player attacker, const VSH2Player victim, Event event)
{
	if( !IsMLGSniper(attacker) )
		return;
	
	float curtime = GetGameTime();
	if( curtime <= attacker.GetPropFloat("flKillSpree") )
		attacker.SetPropInt("iKills", attacker.GetPropInt("iKills") + 1);
	else attacker.SetPropInt("iKills", 0);
	attacker.PlayVoiceClip(MLGSniperKill[GetRandomInt(0, sizeof(MLGSniperKill)-1)], VSH2_VOICE_SPREE);
	
	if( attacker.GetPropInt("iKills") == 3 && VSH2GameMode_GetTotalRedPlayers() != 1 ) {
		attacker.PlayVoiceClip(MLGSniperSpree[GetRandomInt(0, sizeof(MLGSniperSpree)-1)], VSH2_VOICE_SPREE);
		attacker.SetPropInt("iKills", 0);
	}
	else attacker.SetPropFloat("flKillSpree", curtime+5.0);
	
	SpawnModelOnKill(victim, event);
}

public void MLGSniper_OnPlayerHurt(const VSH2Player attacker, const VSH2Player victim, Event event)
{
	int damage = event.GetInt("damageamount");
	
	if( IsMLGSniper(victim) && victim.GetPropInt("bIsBoss") )
	{
		victim.GiveRage(damage);
		
		///Multilive logic (NOT TESTED!!!)
		
		if (damage >= victim.GetPropInt("iHealth") && victim.GetPropInt("iLives") > 1)
		{
			victim.PlayVoiceClip(MLGSniperLostLive[GetRandomInt(0, sizeof(MLGSniperLostLive)-1)], VSH2_VOICE_ALL);
			
			//TF2_AddCondition(victim.index, TFCond_Ubercharged, 4.0);
			TF2_AddCondition(victim.index, TFCond_DefenseBuffed, 4.0);
			TF2_AddCondition(victim.index, TFCond_SpeedBuffAlly, 4.0);
			
			victim.SetPropInt("iLives", victim.GetPropInt("iLives") - 1);
			victim.SetPropInt("iHealth", victim.GetPropInt("iMaxHealth"));
		}
	}
}
public void MLGSniper_OnPlayerAirblasted(const VSH2Player airblaster, const VSH2Player airblasted, Event event)
{
	if( !IsMLGSniper(airblasted) )
		return;
	float rage = airblasted.GetPropFloat("flRAGE");
	airblasted.SetPropFloat("flRAGE", rage + g_vsh2_cvars.airblast_rage.FloatValue);
}
public void MLGSniper_OnBossMedicCall(const VSH2Player player)
{
	if( !IsMLGSniper(player) || player.GetPropFloat("flRAGE") < 100.0 )
		return;
	
	player.DoGenericStun(350.0);
	/*VSH2Player[] players = new VSH2Player[MaxClients];
	int in_range = player.GetPlayersInRange(players, 350.0);
	for( int i; i<in_range; i++ ) {
		if( players[i].GetPropAny("bIsBoss") || players[i].GetPropAny("bIsMinion") )
			continue;
		/// do a distance based thing here.
	}*/
	player.PlayVoiceClip(MLGSniperRage[GetRandomInt(0, sizeof(MLGSniperRage)-1)], VSH2_VOICE_RAGE);
	TF2_RemoveWeaponSlot(player.index, TFWeaponSlot_Primary);
	///37; 0.0	- Max ammo bonus (hidden)
	///40; 1.0	- Normal move while scoped
	///390; 5.0	- Headshot damage mult (*5.0) = from 750 to 2250
	///392; 0.2	- Bodyshot damage mult (*0.2) = from 30 to 90
	///305; 1.0	- Traced bullets
	///376; 1.0	- Aiming no flitch
	///377; 0.9	- Aiming knockback resistance
	///637; 1.0	- Sniper independent zoom DISPLAY ONLY
	///636; 1.0	- Sniper crit no scope
	///144; 3.0	- Lunchbox adds minicrits (?)
	int awp = player.SpawnWeapon("tf_weapon_sniperrifle_classic", 851, 100, 5, "37 ; 0.0 ; 40 ; 1.0 ; 390 ; 5.0; 392 ; 0.2 ; 305 ; 1.0 ; 376 ; 1.0 ; 377 ; 0.9 ; 637 ; 1.0 ; 636 ; 1.0; 144 ; 3.0");
	SetEntPropEnt(player.index, Prop_Send, "m_hActiveWeapon", awp);
		
	int living = GetLivingPlayers(VSH2Team_Red);
	SetWeaponAmmo(awp, ((living >= 5) ? 5 : living));
	
	player.SetPropFloat("flRAGE", 0.0);
}

public void MLGSniper_OnBossJarated(const VSH2Player victim, const VSH2Player thrower)
{
	if( !IsMLGSniper(victim) )
		return;
	float rage = victim.GetPropFloat("flRAGE");
	victim.SetPropFloat("flRAGE", rage - g_vsh2_cvars.jarate_rage.FloatValue);
}


public void MLGSniper_OnRoundEndInfo(const VSH2Player player, bool bossBool, char message[MAXMESSAGE])
{
	if( !IsMLGSniper(player) )
		return;
	else if( bossBool )
		player.PlayVoiceClip(MLGSniperWin[GetRandomInt(0, sizeof(MLGSniperWin)-1)], VSH2_VOICE_WIN);
}


public void MLGSniper_Music(char song[PLATFORM_MAX_PATH], float &time, const VSH2Player player)
{
	if( !IsMLGSniper(player) )
		return;
	
	int theme = GetRandomInt(0, sizeof(MLGSniperThemes)-1);
	Format(song, sizeof(song), "%s", MLGSniperThemes[theme]);
	time = MLGSniperThemesTime[theme];
}

public void MLGSniper_OnBossDeath(const VSH2Player player)
{
	if( !IsMLGSniper(player) )
		return;
	
	player.PlayVoiceClip(MLGSniperDeath[GetRandomInt(0, sizeof(MLGSniperDeath)-1)], VSH2_VOICE_LOSE);
}

public Action MLGSniper_OnStabbed(VSH2Player victim, int& attacker, int& inflictor, float& damage, int& damagetype, int& weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	if( !IsMLGSniper(victim) )
		return Plugin_Continue;
	
	victim.PlayVoiceClip(MLGSniperStab[GetRandomInt(0, sizeof(MLGSniperStab)-1)], VSH2_VOICE_STABBED);
	return Plugin_Continue;
}

public void MLGSniper_OnLastPlayer(const VSH2Player player)
{
	if( !IsMLGSniper(player) )
		return;
	player.PlayVoiceClip(MLGSniperLast[GetRandomInt(0, sizeof(MLGSniperLast)-1)], VSH2_VOICE_LASTGUY);
}

public Action MLGSniper_OnSoundHook(const VSH2Player player, char sample[PLATFORM_MAX_PATH], int& channel, float& volume, int& level, int& pitch, int& flags)
{
	if( !IsMLGSniper(player) )
		return Plugin_Continue;
	//else if( IsVoiceLine(sample) )    
	/// this code: returning Plugin_Handled blocks the sound, a voiceline in this case.
	//	return Plugin_Handled;
	
	return Plugin_Continue;
}

/// Stocks =============================================
stock bool IsValidClient(const int client, bool nobots=false)
{ 
	if( client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)) )
		return false; 
	return IsClientInGame(client); 
}

stock int GetSlotFromWeapon(const int iClient, const int iWeapon)
{
	for( int i; i<5; i++ )
		if( iWeapon == GetPlayerWeaponSlot(iClient, i) )
			return i;
	
	return -1;
}

stock bool OnlyScoutsLeft(const int team)
{
	for( int i=MaxClients; i; --i ) {
		if( !IsValidClient(i) || !IsPlayerAlive(i) )
			continue;
		else if( GetClientTeam(i) == team && TF2_GetPlayerClass(i) != TFClass_Scout )
			return false;
	}
	return true;
}

stock void SetPawnTimer(Function func, float thinktime = 0.1, any param1 = -999, any param2 = -999)
{
	DataPack thinkpack = new DataPack();
	thinkpack.WriteFunction(func);
	thinkpack.WriteCell(param1);
	thinkpack.WriteCell(param2);
	CreateTimer(thinktime, DoThink, thinkpack, TIMER_DATA_HNDL_CLOSE);
}

public Action DoThink(Handle hTimer, DataPack hndl)
{
	hndl.Reset();
	
	Function pFunc = hndl.ReadFunction();
	Call_StartFunction(null, pFunc);
	
	any param1 = hndl.ReadCell();
	if( param1 != -999 )
		Call_PushCell(param1);
	
	any param2 = hndl.ReadCell();
	if( param2 != -999 )
		Call_PushCell(param2);
	
	Call_Finish();
	return Plugin_Continue;
}
stock int SetWeaponClip(const int weapon, const int ammo)
{
	if( IsValidEntity(weapon) ) {
		int iAmmoTable = FindSendPropInfo("CTFWeaponBase", "m_iClip1");
		SetEntData(weapon, iAmmoTable, ammo, 4, true);
	}
	return 0;
}

///From VHS2 (modules/stocks.inc)
stock int GetLivingPlayers(const int team)
{
	int AlivePlayers = 0;
	for (int i=MaxClients; i; --i) {
		if( IsValidClient(i) && IsPlayerAlive(i) && GetClientTeam(i) == team )
			++AlivePlayers;
	}
	return AlivePlayers;
}

///From VHS2 (modules/stocks.inc)
stock int SetWeaponAmmo(const int weapon, const int ammo)
{
	int owner = GetEntPropEnt(weapon, Prop_Send, "m_hOwnerEntity");
	if (owner <= 0)
		return 0;
	if (IsValidEntity(weapon)) {
		int iOffset = GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType", 1)*4;
		int iAmmoTable = FindSendPropInfo("CTFPlayer", "m_iAmmo");
		SetEntData(owner, iAmmoTable+iOffset, ammo, 4, true);
	}
	return 0;
}

public int HintPanel(Menu menu, MenuAction action, int param1, int param2)
{
	return;
}

///From FF2 plugin ff2_1st_set_abilities
stock void SpawnModelOnKill(const VSH2Player victim, Event event)
{
	/*
	if(model[0]!='\0')
	{
		
		LogError("[MLG Sniper] SpawnModelOnKill: Empty model name!");
		return;
	}*/
	if(!IsModelPrecached(MtnDewModel))
	{
		if(!FileExists(MtnDewModel, true))
		{
			LogError("[MLG Sniper] SpawnModelOnKill: Model '%s' doesn't exist!", MtnDewModel);
			return;
		}
		LogError("[MLG Sniper] SpawnModelOnKill: Model '%s' isn't precached!", MtnDewModel);
		return;
	}
	CreateTimer(0.01, Timer_RemoveRagdoll, GetEventInt(event, "userid"), TIMER_FLAG_NO_MAPCHANGE);
	
	int client=GetClientOfUserId(GetEventInt(event, "userid"));
	int prop=CreateEntityByName("prop_physics_override");
	if(IsValidEntity(prop))
	{
		SetEntityModel(prop, MtnDewModel);
		SetEntityMoveType(prop, MOVETYPE_VPHYSICS);
		SetEntProp(prop, Prop_Send, "m_CollisionGroup", 1);
		SetEntProp(prop, Prop_Send, "m_usSolidFlags", 16);
		DispatchSpawn(prop);
		
		float position[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", position);
		position[2]+=20;
		TeleportEntity(prop, position, NULL_VECTOR, NULL_VECTOR);
		//CreateTimer(duration, Timer_RemoveEntity, EntIndexToEntRef(prop), TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action Timer_RemoveRagdoll(Handle timer, any userid)
{
	int client=GetClientOfUserId(userid);
	int ragdoll;
	if(client>0 && (ragdoll=GetEntPropEnt(client, Prop_Send, "m_hRagdoll"))>MaxClients)
	{
		AcceptEntityInput(ragdoll, "Kill");
	}
}
/*
public Action Timer_RemoveEntity(Handle timer, any entid)
{
	int entity=EntRefToEntIndex(entid);
	if(IsValidEntity(entity) && entity>MaxClients)
	{
		AcceptEntityInput(entity, "Kill");
	}
}
*/
