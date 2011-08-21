//::////////////////////////////////////////////////////////////////////////:://
//:: Chat Handler Script                                                    :://
//::////////////////////////////////////////////////////////////////////////:://
#include "_SCInclude_Chat"
#include "_SCInclude_Language"
#include "_CSLCore_Player"

void main()
{
	object oDM = CSLGetChatSender();
	//object oTarget = CSLGetChatTarget();
	string sParameters = CSLGetChatParameters();
	string sMessage;
	if ( !CSLCheckPermissions( oDM, CSL_PERM_DMONLY ) )
	{
		DisplayMessageBox(oDM, -1, "You don't have sufficient privileges to run this feature.");
		return;
	}
	
	//SetLocalString( oTarget, "CSL_LANG_PARAMS", sParameters );
	//SCBook_Display( oTarget, oDM );
	
	/*
	const int CSLBOOK_SPREADTYPE_FULL = 0;
const int CSLBOOK_SPREADTYPE_FACING = 1;

const int CSLBOOK_BOOKTYPE_PARCHMENT = 0;
const int CSLBOOK_BOOKTYPE_SCROLL = 1;
const int CSLBOOK_BOOKTYPE_TABLET = 2;
const int CSLBOOK_BOOKTYPE_CODEX = 3;


const int CSLBOOK_PAGETYPE_LEFT = 0;
const int CSLBOOK_PAGETYPE_LEFTHIDDEN = 1;
const int CSLBOOK_PAGETYPE_RIGHT = 2;
const int CSLBOOK_PAGETYPE_RIGHTHIDDEN = 3;



csl_v_dragoncrytstal.tga
csl_v_thayansymbol.tga
csl_v_dragonradiant.tga
csl_h_dragonbrass.tga
csl_h_dexmap.tga
csl_v_summoning.tga
csl_v_wizard.tga
csl_h_swords.tga
csl_h_correlion.tga
csl_v_succubus2.tga
csl_v_demonlord.tga
csl_v_demon.tga
csl_v_demon3.tga
csl_v_gnollgod.tga
csl_v_battleaxe.tga
csl_v_chaos.tga
csl_h_dragonsilver.tga
csl_v_demon2.tga
csl_h_dragonbronze.tga
csl_v_balorlord.tga
csl_h_crownbones.tga
csl_v_succubus1.tga
csl_v_iconicsorceress.tga
csl_h_skull.tga
csl_h_dragongold.tga
csl_v_sorcery.tga
csl_v_hellschaos.tga
csl_h_dragonpyro.tga
csl_v_demonlord3.tga
csl_h_dragoncopper.tga
csl_v_planescape.tga
csl_h_spider.tga
csl_v_demonlord2.tga
csl_v_tiefling.tga
csl_h_dragonchaos.tga
csl_v_balor.tga
csl_h_dragonstyx.tga

	*/
	
	
// this is just  implementing the functions, the actual functions need to store variables in an efficent manner and then access them on the finished book
// variation to allow database, based edit, but storage in the object db should be doable, or exporting out via chat log to nwscript which can be used to create a given book
object oBook = CSLBookCreate( CSLBOOK_BOOKTYPE_CODEX, 1, "The Amazing Book About Something" ); // need to figure out the icons here

	
	
string sBookText;


CSLBookSetPage( oBook, 0,  "", CSLBOOK_PAGETYPE_LEFT, "common", "csl_v_summoning.tga" );

sBookText = "";	
sBookText += "This haunted grove is the chief landmark in the Conyberry area. The ghost of Neverwinter Wood is actually a banshee, known as Agatha. This name is almost certainly a corruption of the elven surname Auglathla, which means 'Winterbreeze' in one of the older elven dialects. She lairs in a grove in Neverwinter Wood, northwest of Conyberry. Her haunt is at the end of a path whose entrance is marked by a strand of birch trees.\n\nAt one time Agatha's lair was guarded. by a magic mirror spell.\n";
sBookText += "This was set up to hide her real location, and give her time to hurl spells at intruders. The heroes Drizzt Do'Urden and Wulfgar son of Beornegar shattered these defenses. The two adventurers then stole her treasure.\n\nThe banshee had amassed her treasure hoard by thieving in the night, slaying travelers, and pillaging old tombs and ruins. Since her wealth was stolen, she has taken to looting the\n";
sBookText += "Dessarin again, trying to rebuild her riches. She also seeks revenge for the theft, and so considers any adventurers fitting recipients of death.\n\nAgatha's lair has new defenses now. Her spells enable her to charm the people of Conyberry into digging pitfall traps along the path to her lair. These servants have also been seen guarding her haunt. Other than this, Agatha does not bother the folk of Conyberry. Rather, she views them as allies.\n";
CSLBookSetPage( oBook, 0,  sBookText, CSLBOOK_PAGETYPE_RIGHT, "common", "" );

sBookText = "";	
sBookText += "Agatha often uses her spells to bring them beasts for food in the worst winter weather. She also slaughters orcs and brigands who venture too near to the village. Folk in Conyberry regard Agatha almost affectionately as their guardian and friend. They often talk about her, and speculate on what she's up to. Popular legends tell of sylvan creatures luring men within trees, where exists entire kingdoms, known as the faerie realms.\n";
sBookText += "A less-popular legend tells of a similarly mischievous group of imps.\n\nAccording to the tale, these imps lure people into their realms by taunting them with something that they may desire, such as wealth or pleasure. Once the person follows, entranced by the whisperings of the imps, he finds himself within a twisted abyss, bereft of hope or the possibility of escape The city of Neverwinter was originally founded by Lord Halueth Never.\n";
sBookText += "This great lord was laid to rest - so local tavern tales swear - on a huge slab of stone encircled by a ring of naked swords laid with their points radiating outward. These magic blades animate to attack all intruders if the precise instructions graven in cryptic verses on the flagstones are not followed.\n\nToday Neverwinter is ruled by Lord Nasher Alagondar, an amiable and balding warrior who keeps his city firmly in the Lords' Alliance.\n";
CSLBookSetPage( oBook, 1,  sBookText, CSLBOOK_PAGETYPE_LEFT, "common", "" );

sBookText = "";	
sBookText += "Lord Nasher has laid many intrigues and magical preparations against attacks from Neverwinter's warlike rival town, Luskan. Nasher doesn't allow maps of the city to be made. This is to keep the spies of Luskan busy and add a minor measure of difficulty to any Luskanite invasion plans. \n\nThe royal badge of the city is a white swirl - a sideways 'M,' with points to the right.\n";
sBookText += "It connects three white snowflakes each flake is different, but all are encircled by silver and blue halos.\n\nLord Nasher is always accompanied by his bodyguard, the Neverwinter Nine. These warriors are entrusted with the many magic items Nasher accumulated over a very successful decade of adventuring. Long ago, an unknown adventurer discovered a set of magic writings that held vast secrets of magic.\n";
sBookText += "These writings came to be called the Nether Scrolls. Taken together, they granted insight into the mysteries of spellcasting, the creation of magic items and constructs, the relations and structure of the planes, and even the making of artifacts. Although all of the Nether Scrolls were lost or stolen over the following 2,000 years, by then the information they contained had changed Netherese society forever.\n";
CSLBookSetPage( oBook, 1,  sBookText, CSLBOOK_PAGETYPE_RIGHT, "common", "" );


CSLBookSetPage( oBook, 2,  "", CSLBOOK_PAGETYPE_LEFT, "common", "csl_v_battleaxe.tga" );

sBookText = "";	
sBookText += "The lords of Netheril developed forms of magic never before seen in the world. The mythallar was a invention by the Netherese wizard Ioulaum that gave power to nearby items, negating the need for expenditure of a spellcaster's energy to create magic items. The mythallar also allowed the creation of flying cities, formed by slicing off and inverting the top of a mountain.\n";
sBookText += "Netheril's people took to the skies in these flying enclaves of magic, safe from human barbarians and hordes of evil humanoids. Every citizen wielded minor magic, and the Netherese traded with nearby elven and dwarven nations, expanding the reach of their empire greatly. This hefty tome attempts a complete history of the Neverwinter Wood, but the crux of what is known is summed up in the following passage:\n";
sBookText += "While many a tale has suggested that there are dark forces that call the wood their home, there is yet no definite answer as to what truly hides within. Many a glade has a guardian force watching over it, but never one so malevolent as is supposedly in residence there.\n";
CSLBookSetPage( oBook, 2,  sBookText, CSLBOOK_PAGETYPE_RIGHT, "common", "csl_h_spider.tga" );




sBookText = "";	
sBookText += "These woods have never been logged by men, for they are feared and shunned by locals, and even orc hordes alter their course around and never through, though usually only after suffering a goodly number of stubborn casualties. The Northern Four is the name of a band of adventurers that have each gone on to become key citizens of the Sword Coast.\n";
sBookText += "Led by Nasher Alagondar, who became Lord of Neverwinter, the group also consisted of Dumal Erard, who went on to found and watch over Helm's Hold, Ophala Cheldarstorn, matron of the Moonstone Mask who was thought to be an important figure among the mages of the Many-Starred Cloak, and Kurth, who has become a High Captain of Luskan.\n";
sBookText += "The band adventured together successfully for many years, and spawned many tales in their adventures around the region. One popular tale depicts the successful rescue of the Black Raven Tribe from a foul white dragon. As a symbol of gratitude from the tribe, Nasher was gifted with the noted Neverwintan Morregence as a 'debt-child.'\n";
CSLBookSetPage( oBook, 3,  sBookText, CSLBOOK_PAGETYPE_LEFT, "common", "" );

sBookText = "";	
sBookText += "The success of the troupe eventually came to an end with a leadership struggle between Nasher and Kurth. Ophala was torn between her love for Kurth and her loyalty to Nasher, but after Kurth left, Ophala settled in Neverwinter, unwilling to compromise her hatred for Luskan and its Arcane Brotherhood; many assume that she still bears resentment against Nasher for the way things turned out.\n";
sBookText += "Regardless, Nasher and Erard have remained close, and Ophala still serves her Lord loyally. The same cannot be said of Kurth, who has joined forces with an army that would love nothing more than to see Neverwinter destroyed. Long ago, magic was more raw and potent than it is today. The great civilizations of the creator races were based on endless experimentation with these energies, and during their long rules they created many new forms of life.\n";
sBookText += "The cruel and decadent creator races chose to release their monstrous mistakes rather than destroy them. Most died in the jungles, yet many lived and - as thought awakened in them - they hid from their creators. When the end came at last, it was they - not the old races - who seized control of Faer�n. \n\nAnd so it was that the first of the elves, the dragons, the goblin races, and an endless list of creatures of a new age took possession of their heritage.\n";
CSLBookSetPage( oBook, 3,  sBookText, CSLBOOK_PAGETYPE_RIGHT, "Thorass", "" );

sBookText = "";	
sBookText += "Their creators - the ancestors of the lizardfolk, bullywugs, and aarakocra - declined into savage barbarism, never to rise again.\n\nSages speculate about the 'overnight' destruction of the creator races. There are wildly diverging theories, but all agree that a rapid climate change occurred, creating a world unsuitable to them. Many believe the change resulted from a cataclysm the races unleashed upon themselves.\n";
sBookText += "Proponents of this theory point to the Star Mounts in the High Forest, whose origins are most likely magical and otherworldly. The elves believe that around this time the greater and lesser powers manifested themselves, aiding the new races and confounding the survivors of the creator races. There was civilization in the North during this time period, yet little more than tantalizingly vague myths survive.\n";
sBookText += "I can smell your feet.\nTheir odor lingers even these many years\nafter you last tread here.\nNow there is only dust and shadows,\nas my belly\nscrapes\nthe ground...\n\nDagget Filth\nYear 832 after The Fall\n\nDamn, I'm bored... To the east, on the sandy shores of the calm and shining Narrow Sea, human fishing villages grew into small towns and then joined together as the nation of Netheril.\n";
CSLBookSetPage( oBook, 4,  sBookText, CSLBOOK_PAGETYPE_LEFT, "Thorass", "csl_v_tiefling.tga" );

sBookText = "";	
sBookText += "Sages believe the fishing towns were unified by a powerful human wizard who had discovered a book of great magic power that had survived from the Days of Thunder - a book that legend calls the Nether Scrolls. Under this nameless wizard and those who followed, Netheril rose in power and glory becoming both the first human land in the North and the most powerful.\n";
sBookText += "Some say this discovery marked the birth of human wizardry, since before this time mankind had only shamans and witch doctors. For over 3,000 years Netheril dominated the North, but even its legendary wizards were unable to stop their final doom.\n\nDoom for Netheril came in the form of a desert, devouring the Narrow Sea and spreading to fills its banks with dry dust and blowing sand.\n";
sBookText += "Legend states when the great wizards of Netheril realized their land was lost, they abandoned it and their countrymen, fleeing to all corners of the world and taking the secrets of wizardry with them. More likely, this was a slow migration that began 3,000 years ago and reached its conclusion 1,500 years later.\n\nWhatever the truth, wizards no longer dwelled in Netheril.\n";
CSLBookSetPage( oBook, 4,  sBookText, CSLBOOK_PAGETYPE_RIGHT, "Thorass", "csl_h_dragonchaos.tga" );

sBookText = "";	
sBookText += "To the north, the once-majestic dwarven stronghold of Delzoun fell upon hard days. Then the orcs struck. Orcs have always been foes in the North, surging out of their holes every few tens of generations when their normal haunts can no longer support their burgeoning numbers.\n";
sBookText += "This time they charged out of their caverns in the Spine of the World, poured out of abandoned mines in the Graypeaks, screamed out of lost dwarfholds in the Ice Mountains, raged forth from crypt complexes in the Nether Mountains, and stormed upward from the bowels of the High Moon Mountains.\n";
sBookText += "Never before or since has then been such an outpouring of orcs.\n\nDelzoun crumbled before this onslaught and was driven in on itself. Netheril, without its wizards, was wiped from the face of history. The Eaerlann elves alone withstood the onslaught, and with the aid of treants of Turlang and other unnamed allies, were able to stave off the final days of their land for yet a few centuries more.\n";
CSLBookSetPage( oBook, 5,  sBookText, CSLBOOK_PAGETYPE_LEFT, "Logos", "csl_h_crownbones.tga" );

sBookText = "";	
sBookText += "In the east, Eaerlann built the fortress of Ascalhorn and turned it over to refugees from Netheril as Netherese followers built the town of Karse in the High Forest. The fleeing Netherese founded Llorkh and Loudwater. Others wandered the mountains, hills, and moors north and west of the High Forest, becoming ancestors of the Uthgardt and founders of Silverymoon, Everlund, and Sundabar.\n";
sBookText += "One portal opened by Mulhorand's rebellious wizards led to a world populated by savage orcs. These orcs used the portal to invade Faer�n, overrunning many northern settlements and slaying thousands. The manifestations of the god-kings of both Mulhorand and Unther battled the orcs, and the orcs retaliated by summoning divine avatars of their own deities.\n";
sBookText += "During these conflicts, known as the Orcgate Wars, the orc god Gruumsh slew the Mulhorandi sun god Re the first known deicide in the Realms. Many of the Untheric deities were slain as well. The human deities eventually prevailed and the orcs were slain or driven northward.\n\nThe deities Set and Osiris battled to succeed Re, and Set murdered his rival.\n";
CSLBookSetPage( oBook, 5,  sBookText, CSLBOOK_PAGETYPE_RIGHT, "Pathos", "" );

sBookText = "";	
sBookText += "Horus absorbed the divine power of Re and became Horus-Re, defeated Set, and cast the evil god into the desert. Isis resurrected Osiris. All of the Mulhorandi pantheon but Set united in support of Horus-Re. The two old nations paused to rebuild their power and lick their wounds. During this time the empires of Raumathar and Narfell rose in the battlefield territories to the north.\n";
sBookText += "In Unther, their chief god Enlil abdicated in favor of his son Gilgeam and vanished, and Ishtar, the only other surviving Untheric deity, gave the power of her manifestation to Isis and vanished as well. Gilgeam began his 2,000-year decline into despotic tyranny as the ruler of Unther\n";
CSLBookSetPage( oBook, 6,  sBookText, CSLBOOK_PAGETYPE_LEFT, "Pathos", "" );

CSLBookActivate( oBook, oDM ); 	
	return;	
}