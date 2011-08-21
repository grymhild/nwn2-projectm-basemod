
#include "_HkSpell"

void main()
{	
	
object oPC = OBJECT_SELF;
int		nStackSize = (HkGetCasterLevel(oPC));
CreateItemOnObject("sh_i_flask_water",oPC,nStackSize,"",TRUE);
}