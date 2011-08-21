// PUT IN ONSPAWN AND ONCONVERSATION OF ANY CREATURE TO MAKE A STATUE
// MAKE THEM UNBUMPABLE
// APPLY STATUE EFFECT
#include "_HkSpell"

void main() {
   SetFacing(GetFacing(OBJECT_SELF)); // FOR CONVERSATIONS - DON'T FACE THE SPEAKER
   if ( GetTag(OBJECT_SELF) == "strickenwatcher" )
   {
   	ChangeToStandardFaction( OBJECT_SELF,STANDARD_FACTION_DEFENDER  );
   }
   if (!GetLocalInt(OBJECT_SELF, "ISSTATUE"))
   {
      SetLocalInt(OBJECT_SELF, "ISSTATUE", TRUE);
      if (GetPlotFlag(OBJECT_SELF)) SetPlotFlag(OBJECT_SELF, FALSE); // CLEAR PLOT FLAG
      if (GetImmortal(OBJECT_SELF)) SetImmortal(OBJECT_SELF, FALSE); // CLEAR IMMORTAL FLAG
	  AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0, 10.0));
      DelayCommand(IntToFloat(d3()), HkApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION), OBJECT_SELF));
      SetPlotFlag(OBJECT_SELF, TRUE); // SET PLOT FLAG
      SetImmortal(OBJECT_SELF, TRUE); // SET IMMORTAL FLAG
   }
}