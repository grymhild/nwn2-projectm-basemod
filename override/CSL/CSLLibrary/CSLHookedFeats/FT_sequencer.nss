//::///////////////////////////////////////////////
//:: x2_s3_sequencer
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Fires the spells stored on this sequencer.
	GZ: - Also handles clearing off spells if the
			item has the clear sequencer property
			- added feedback strings
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2003
//:: Updated By: Georg
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_CSLCore_Items"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_TURNABLE;
	object oItem = GetSpellCastItem();
	object oPC =   OBJECT_SELF;

	int i = 0;
	int iSpellId = -1;
	int nMode = GetSpellId();

	int iMax = CSLGetItemSequencerProperty(oItem);

	if (iMax ==0) // Should never happen unless you added clear sequencer to a non sequencer item
	{
			return;
	}
	if (nMode == 720 ) // clear seqencer
	{
			for (i = 1; i <= iMax; i++)
			{
				DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER" + IntToString(i));
			}
			DeleteLocalInt(oItem, "X2_L_NUMTRIGGERS");
			effect eClear = EffectVisualEffect(VFX_IMP_BREACH);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT,eClear,OBJECT_SELF);
			FloatingTextStrRefOnCreature(83882,OBJECT_SELF); // sequencer cleared
	}
	else
	{
			int bSuccess = FALSE;
			for (i = 1; i <= iMax; i++)
			{
				iSpellId = GetLocalInt(oItem, "X2_L_SPELLTRIGGER" + IntToString(i));
				if (iSpellId>0)
				{
					bSuccess = TRUE;
					iSpellId --; // I added +1 to the spellID when the sequencer was created, so I have to remove it here
					ActionCastSpellAtObject(iSpellId, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
				}
			}
			if (!bSuccess)
			{
				FloatingTextStrRefOnCreature(83886,OBJECT_SELF); // no spells stored
			}
	}
}