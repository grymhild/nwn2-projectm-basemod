//::///////////////////////////////////////////////
//:: Delayed Blast Fireball
//:: NW_S0_DelFirebal.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The caster creates a trapped area which detects
	the entrance of enemy creatures into 3 m area
	around the spell location.  When tripped it
	causes a fiery explosion that does 1d6 per
	caster level up to a max of 20d6 damage.
	
	
	This spell functions like fireball, except that it is more powerful and can detonate up to 5
	rounds after the spell is cast. The burst of flame deals 1d6 points of fire damage per caster
	level (maximum 20d6).

	The glowing bead created by delayed blast fireball can detonate immediately if you desire, or
	you can choose to delay the burst for as many as 5 rounds. You select the amount of delay upon
	completing the spell, and that time cannot change once it has been set unless someone touches
	the bead (see below). If you choose a delay, the glowing bead sits at its destination until it
	detonates. A creature can pick up and hurl the bead as a thrown weapon (range increment 10
	feet). If a creature handles and moves the bead within 1 round of its detonation, there is a 25%
	chance that the bead detonates while being handled.

const int SPELL_DELAYED_BLAST_FIREBALL1 = 5832;
const int SPELL_DELAYED_BLAST_FIREBALL2 = 5833;
const int SPELL_DELAYED_BLAST_FIREBALL3 = 5834;
const int SPELL_DELAYED_BLAST_FIREBALL4 = 5835;
const int SPELL_DELAYED_BLAST_FIREBALL5 = 5836;

	
	
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 27, 2001
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_SP_delblstfireb();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DELAYED_BLAST_FIREBALL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_EVOCATION;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	if ( GetSpellId() == SPELL_SHADES_TARGET_CREATURE )
	{
		iSpellSchool = SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool = SPELL_SUBSCHOOL_SHADOW;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_EVOCATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int iDelayRounds = 0;

	int iTrueSpellId = GetSpellId();
	switch(iTrueSpellId)
	{
		case SPELL_DELAYED_BLAST_FIREBALL5:
			iDelayRounds = 5;
			break;
		case SPELL_DELAYED_BLAST_FIREBALL4:
			iDelayRounds = 4;
			break;
		case SPELL_DELAYED_BLAST_FIREBALL3:
			iDelayRounds = 3;
			break;
		case SPELL_DELAYED_BLAST_FIREBALL2:
			iDelayRounds = 2;
			break;
		default:
			iDelayRounds = 1;
			break;
	}
	
	//SendMessageToPC( oCaster, "Setting Delay for "+ IntToString(iDelayRounds )+" many rounds." );


	
	int iSpellPower = HkGetSpellPower( oCaster );
	
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = CSLGetMax( 1, HkGetSpellDuration(OBJECT_SELF) / 2 );
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );

	//Declare major variables including Area of Effect Object
	effect eAOE = EffectAreaOfEffect(AOE_PER_DELAY_BLAST_FIREBALL, "SP_delblstfirebA", "SP_delblstfirebC", "", sAOETag);
	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	//Create an instance of the AOE Object using the Apply Effect function
	DelayCommand( 0.1f, HkApplyEffectAtLocation( iDurType, eAOE, lTarget, fDuration ) );
	
	
	DelayCommand( 0.5f, SetLocalInt( GetObjectByTag( sAOETag ), "CSL_DELAYROUNDS", iDelayRounds ) );
	
	HkPostCast(oCaster);
}
