//::///////////////////////////////////////////////
//:: x2_s2_whirl.nss
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Performs a whirlwind or improved whirlwind
    attack.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-08-20
//:://////////////////////////////////////////////
//:: Updated By: GZ, Sept 09, 2003

/*----  Kaedrin PRC Content ---------*/


#include "_SCInclude_Class"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_TURNABLE;
    /* Play random battle cry */
    int nSwitch = d3();
    switch (nSwitch)
    {
        case 1: PlayVoiceChat(VOICE_CHAT_BATTLECRY1); break;
        case 2: PlayVoiceChat(VOICE_CHAT_BATTLECRY2); break;
        case 3: PlayVoiceChat(VOICE_CHAT_BATTLECRY3); break;
    }

    effect eVis = EffectVisualEffect(460);
    DelayCommand(1.0f,HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,OBJECT_SELF));

	//int nWpnType = GetWeaponType  
	effect eDamageBonus = EffectDamageIncrease(DAMAGE_BONUS_2d6,DAMAGE_TYPE_SLASHING);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDamageBonus,OBJECT_SELF, 3.0f);
    DoWhirlwindAttack(TRUE,TRUE);

}