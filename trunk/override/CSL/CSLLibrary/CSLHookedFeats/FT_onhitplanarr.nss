//::///////////////////////////////////////////////
//:: OnHit CastSpell: Planarrift
//:: x2_s3_planarrift
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-22
//:://////////////////////////////////////////////

#include "_HkSpell"
void main()
{
	//scSpellMetaData = SCMeta_FT_onhitplanarr();
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;

	object oItem;        // The item casting triggering this spellscript
	object oSpellTarget; // On a weapon: The one being hit. On an armor: The one hitting the armor
	object oSpellOrigin; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor

	// fill the variables
	oSpellOrigin = OBJECT_SELF;
	oSpellTarget = HkGetSpellTarget();
	oItem        =  GetSpellCastItem();
	object oFeedback = GetMaster(OBJECT_SELF);

	if (!GetIsObjectValid(oFeedback))
	{
			oFeedback = OBJECT_SELF;
	}

	if (GetIsPC(OBJECT_SELF))
	{
		// NONONO, player's are not supposed to use this
		effect eDeath = EffectDeath(TRUE);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,OBJECT_SELF);
	}

	int iDC = 10+HkGetSpellPower(oSpellOrigin);

	if (GetIsObjectValid(oItem))
	{
		if (GetIsObjectValid(oSpellTarget))
		{
			if ( !HkResistSpell(oFeedback,oSpellTarget) )
			{
				if( !FortitudeSave(oSpellTarget,iDC,SAVING_THROW_TYPE_DEATH,oFeedback) )
				{
					effect eDeath = EffectDeath(TRUE);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,oSpellTarget);
				}
			}
		}
	}
}