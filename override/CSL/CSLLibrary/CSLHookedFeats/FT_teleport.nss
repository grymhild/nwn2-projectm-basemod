//::///////////////////////////////////////////////
//:: x2_s3_teleport
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	If hit, the opponent teleports to the player

	GZ:
			Added Will Save Vs Spells DC 10 + Casterlevel
			Added Plot Check
			Added Reaction Hostile Check

*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: 27/06/03
//:: Updated On: 2003/10/11 GZ
//:://////////////////////////////////////////////

#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//declare major variables
	effect eVis = EffectVisualEffect(VFX_IMP_TORNADO);
	object oArrow = GetSpellCastItem();
	object oHitter = OBJECT_SELF;
	object oTarget = HkGetSpellTarget();
	if (!GetIsObjectValid(oTarget))
	{
			return;
	}
	if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
	{
			return;
	}


	if (! GetPlotFlag(oTarget) && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oHitter) )
	{

			int iDC = 10 + HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
			if (HkSavingThrow(SAVING_THROW_WILL,oTarget,iDC,SAVING_THROW_TYPE_SPELL,oHitter) ==0)
			{
				AssignCommand(oTarget, ClearAllActions(TRUE));
				AssignCommand(oTarget, JumpToObject(oHitter));
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			}
	}

}