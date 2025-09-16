-- name: Character Custom Dialog
-- description: Changes the word mario in dialog to the player you play as \nBy: \\#00faf6\\k\\#00b3fa\\i\\#0075fa\\k\\#af00fa\\w\\#cc00fa\\e\\#f200fa\\e

local CHARACTER_NAMES = {
    [CT_MARIO] = "Mario",
    [CT_LUIGI] = "Luigi", 
    [CT_WARIO] = "Wario",
    [CT_WALUIGI] = "Waluigi",
    [CT_TOAD] = "Toad",
}

local YOSHI = {
    [DIALOG_161] = true,
}

local DIALOGS = {
    [DIALOG_003] = "Thank you, Mario! The Big\nBob-omb is nothing but a\nbig dud now! But the\nbattle for the castle has\njust begun.\nOther enemies are holding\nthe other Power Stars. If\nyou recover more Stars,\nyou can open new doors\nthat lead to new worlds!\nMy Bob-omb Buddies are\nwaiting for you. Be sure\nto talk to them--they'll\nset up cannons for you.",
    [DIALOG_005] = "Hey, Mario! Is it true\nthat you beat the Big\nBob-omb? Cool!\nYou must be strong and\npretty fast. So, how fast\nare you anyway?\nFast enough to beat me...\nKoopa the Quick? I don't\nthink so. Just try me.\nHow about a race to the\nmountaintop, where the\nBig Bob-omb was?\nWhaddya say? When I say\nGo, let the race begin!\n\nReady....\n\n//Go!////Don't Go",
    [DIALOG_011] = "You've just stepped on\nthe Metal Cap Switch!\nThe Metal Cap makes\nMario invincible.\nNow Metal Caps will\npop out of all of the\ngreen blocks you find.\n\nWould you like to Save?\n\n//Yes////No",
    [DIALOG_012] = "You've just stepped on\nthe Vanish Cap Switch.\nThe Vanish Cap makes\nMario disappear.\nNow Vanish Caps will pop\nfrom all of the blue\nblocks you find.\n\nWould you like to Save?\n\n//Yes////No",
    [DIALOG_013] = "You've collected 100\ncoins! Mario gains more\npower from the castle.\nDo you want to Save?\n//Yes////No",
    [DIALOG_014] = "Wow! Another Power Star!\nMario gains more courage\nfrom the power of the\ncastle.\nDo you want to Save?\n\n//You Bet//Not Now",
    [DIALOG_017] = "I'm the Big Bob-omb, lord\nof all blasting matter,\nking of ka-booms the\nworld over!\nHow dare you scale my\nmountain? By what right\ndo you set foot on my\nimperial mountaintop?\nYou may have eluded my\nguards, but you'll never\nescape my grasp...\n\n...and you'll never take\naway my Power Star. I\nhereby challenge you,\nMario!\nIf you want the Star I\nhold, you must prove\nyourself in battle.\n\nCan you pick me up from\nthe back and hurl me to\nthis royal turf? I think\nthat you cannot!",
    [DIALOG_020] = "Dear Mario:\nPlease come to the\ncastle. I've baked\na cake for you.\nYours truly--\nPrincess Toadstool",
    [DIALOG_030] = "Hello! The Lakitu Bros.,\ncutting in with a live\nupdate on Mario's\nprogress. He's about to\nlearn a technique for\nsneaking up on enemies.\nThe trick is this: He has\nto walk very slowly in\norder to walk quietly.\n\n\n\nAnd wrapping up filming\ntechniques reported on\nearlier, you can take a\nlook around using [C]▶ and\n[C]◀. Press [C]▼ to view the\naction from a distance.\nWhen you can't move the\ncamera any farther, the\nbuzzer will sound. This is\nthe Lakitu Bros.,\nsigning off.",
    [DIALOG_031] = "No way! You beat me...\nagain!! And I just spent\nmy entire savings on\nthese new Koopa\nMach 1 Sprint shoes!\nHere, I guess I have to\nhand over this Star to\nthe winner of the race.\nCongrats, Mario!",
    [DIALOG_033] = "Ciao! You've reached\nPrincess Toadstool's\ncastle via a warp pipe.\nUsing the controller is a\npiece of cake. Press [A] to\njump and [B] to attack.\nPress [B] to read signs,\ntoo. Use the Control Stick\nin the center of the\ncontroller to move Mario\naround. Now, head for\nthe castle.",
    [DIALOG_034] = "Good afternoon. The\nLakitu Bros., here,\nreporting live from just\noutside the Princess's\ncastle.\n\nMario has just arrived\non the scene, and we'll\nbe filming the action live\nas he enters the castle\nand pursues the missing\nPower Stars.\nAs seasoned cameramen,\nwe'll be shooting from the\nrecommended angle, but\nyou can change the\ncamera angle by pressing\nthe [C] Buttons.\nIf we can't adjust the\nview any further, we'll\nbuzz. To take a look at\nthe surroundings, stop\nand press [C]▲.\n\nPress [A] to resume play.\nSwitch camera modes with\nthe [R] Button. Signs along\nthe way will review these\ninstructions.\n\nFor now, reporting live,\nthis has been the\nLakitu Bros.",
    [DIALOG_035] = "There are four camera, or\n『[C],』 Buttons. Press [C]▲\nto look around using the\nControl Stick.\n\nYou'll usually see Mario\nthrough Lakitu's camera.\nIt is the camera\nrecommended for normal\nplay.\nYou can change angles by\npressing [C]▶. If you press\n[R], the view switches to\nMario's camera, which\nis directly behind him.\nPress [R] again to return\nto Lakitu's camera. Press\n[C]▼ to see Mario from\nafar, using either\nLakitu's or Mario's view.",
    [DIALOG_036] = "OBSERVATION PLATFORM\nPress [C]▲ to take a look\naround. Don't miss\nanything!\n\nPress [R] to switch to\nMario's camera. It\nalways follows Mario.\nPress [R] again to switch\nto Lakitu's camera.\nPause the game and\nswitch the mode to 『fix』\nthe camera in place while\nholding [R]. Give it a try!",
    [DIALOG_042] = "Caution! Narrow Bridge!\nCross slowly!\n\n\nYou can jump to the edge\nof the cliff and hang on,\nand you can climb off the\nedge if you move slowly.\nWhen you want to let go,\neither press [Z] or press\nthe Control Stick in the\ndirection of Mario's back.\nTo climb up, press Up on\nthe Control Stick. To\nscurry up quickly, press\nthe [A] Button.",
    [DIALOG_045] = "Whew! I'm just about\nflapped out. You should\nlay off the pasta, Mario!\nThat's it for now. Press\n[A] to let go. Okay,\nbye byyyyyyeeee!",
    [DIALOG_055] = "Hey-ey, Mario, buddy,\nhowzit goin'? Step right\nup. You look like a fast\nsleddin' kind of guy.\nI know speed when I see\nit, yes siree--I'm the\nworld champion sledder,\nyou know. Whaddya say?\nHow about a race?\nReady...\n\n//Go//// Don't Go",
    [DIALOG_058] = "You found my precious,\nprecious baby! Where\nhave you been? How can\nI ever thank you, Mario?\nOh, I do have this...\n...Star. Here, take it\nwith my eternal\ngratitude.",
    [DIALOG_064] = "When you put on the Wing\nCap that comes from a\nred block, do the Triple\nJump to soar high into\nthe sky.\nUse the Control Stick to\nguide Mario. Pull back to\nfly up, press forward to\nnose down, and press [Z]\nto land.",
    [DIALOG_065] = "Swimming Lessons!\nTap [A] to do the breast\nstroke. If you time the\ntaps right, you'll swim\nfast.\n\nPress and hold [A] to do a\nslow, steady flutter kick.\nPress Up on the Control\nStick to dive, and pull\nback on the stick to head\nfor the surface.\nTo jump out of the water,\nhold Down on the Control\nStick, then press [A].\nEasy as pie, right?\n\n\nBut remember:\nMario can't breathe under\nthe water! Return to the\nsurface for air when the\nPower Meter runs low.\n\nAnd one last thing: You\ncan't open doors that\nare underwater.",
    [DIALOG_066] = "Mario, it's Peach!\nPlease be careful! Bowser\nis so wicked! He will try\nto burn you with his\nhorrible flame breath.\nRun around behind and\ngrab him by the tail with\nthe [B] Button. Once you\ngrab hold, swing him\naround in great circles.\nRotate the Control Stick\nto go faster and faster.\nThe faster you swing him,\nthe farther he'll fly.\n\nUse the [C] Buttons to look\naround, Mario. You have\nto throw Bowser into one\nof the bombs in the four\ncorners.\nAim well, then press [B]\nagain to launch Bowser.\nGood luck, Mario! Our\nfate is in your hands.",
    [DIALOG_067] = "Tough luck, Mario!\nPrincess Toadstool isn't\nhere...Gwa ha ha!! Go\nahead--just try to grab\nme by the tail!\nYou'll never be able to\nswing ME around! A wimp\nlike you won't throw me\nout of here! Never! Ha!",
    [DIALOG_068] = "It's Lethal Lava Land!\nIf you catch fire or fall\ninto a pool of flames,\nyou'll be hopping mad, but\ndon't lose your cool.\nYou can still control\nMario--just try to keep\ncalm!",
    [DIALOG_074] = "You can grab on to the\nedge of a cliff or ledge\nwith your fingertips and\nhang down from it.\n\nTo drop from the edge,\neither press the Control\nStick in the direction of\nMario's back or press the\n[Z] Button.\nTo get up onto the ledge,\neither press Up on the\nControl Stick or press [A]\nas soon as you grab the\nledge to climb up quickly.",
    [DIALOG_075] = "Mario!! My castle is in\ngreat peril. I know that\nBowser is the cause...and\nI know that only you can\nstop him!\nThe doors in the castle\nthat have been sealed by\nBowser can be opened only\nwith Star Power.\n\nBut there are secret\npaths in the castle,\npaths that Bowser hasn't\nfound.\n\nOne of those paths is in\nthis room, and it holds\none of the castle's Secret\nStars!\n\nFind that Secret Star,\nMario! It will help you\non your quest. Please,\nMario, you have to\nhelp us!\nRetrieve all of the\nPower Stars in the castle\nand free us from this\nawful prison!\nPlease!",
    [DIALOG_076] = "Thanks to the power of\nthe Stars, life is\nreturning to the castle.\nPlease, Mario, you have\nto give Bowser the boot!\n\nHere, let me tell you a\nlittle something about the\ncastle. In the room with\nthe mirrors, look carefully\nfor anything that's not\nreflected in the mirror.\nAnd when you go to the\nwater town, you can flood\nit with a high jump into\nthe painting. Oh, by the\nway, look what I found!",
    [DIALOG_082] = "Hold on to your hat! If\nyou lose it, you'll be\ninjured easily.\n\nIf you do lose your Cap,\nyou'll have to find it in\nthe course where you\nlost it.\nOh, boy, it's not looking\ngood for Peach. She's\nstill trapped somewhere\ninside the walls.\nPlease, Mario, you have\nto help her! Did you know\nthat there are enemy\nworlds inside the walls?\nYup. It's true. Bowser's\ntroops are there, too.\nOh, here, take this. I've\nbeen keeping it for you.",
    [DIALOG_083] = "There's something strange\nabout that clock. As you\njump inside, watch the\nposition of the big hand.\nOh, look what I found!\nHere, Mario, catch!",
    [DIALOG_092] = "Pestering me again, are\nyou, Mario? Can't you see\nthat I'm having a merry\nlittle time, making\nmischief with my minions?\nNow, return those Stars!\nMy troops in the walls\nneed them! Bwa ha ha!",
    [DIALOG_093] = "Mario! You again! Well\nthat's just fine--I've\nbeen looking for something\nto fry with my fire\nbreath!\nYour Star Power is\nuseless against me!\nYour friends are all\ntrapped within the\nwalls...\nAnd you'll never see the\nPrincess again!\nBwa ha ha ha!",
    [DIALOG_116] = "Whaaa....Whaaat?\nCan it be that a\npipsqueak like you has\ndefused the Bob-omb\nking????\nYou might be fast enough\nto ground me, but you'll\nhave to pick up the pace\nif you want to take King\nBowser by the tail.\nMethinks my troops could\nlearn a lesson from you!\nHere is your Star, as I\npromised, Mario.\n\nIf you want to see me\nagain, select this Star\nfrom the menu. For now,\nfarewell.",
    [DIALOG_121] = "Nooo! It can't be!\nYou've really beaten me,\nMario?!! I gave those\ntroops power, but now\nit's fading away!\nArrgghh! I can see peace\nreturning to the world! I\ncan't stand it! Hmmm...\nIt's not over yet...\n\nC'mon troops! Let's watch\nthe ending together!\nBwa ha ha!",
    [DIALOG_132] = "Whoa, Mario, pal, you\naren't trying to cheat,\nare you? Shortcuts aren't\nallowed.\nNow, I know that you\nknow better. You're\ndisqualified! Next time,\nplay fair!",
    [DIALOG_136] = "Wow! You've already\nrecovered that many\nStars? Way to go, Mario!\nI'll bet you'll have us out\nof here in no time!\n\nBe careful, though.\nBowser and his band\nwrote the book on bad.\nTake my advice: When you\nneed to recover from\ninjuries, collect coins.\nYellow Coins refill one\npiece of the Power Meter,\nRed Coins refill two\npieces, and Blue Coins\nrefill five.\n\nTo make Blue Coins\nappear, pound on Blue\nCoin Blocks.\n\n\n\nAlso, if you fall from\nhigh places, you'll\nminimize damage if you\nPound the Ground as you\nland.",
    [DIALOG_137] = "Thanks, Mario! The castle\nis recovering its energy\nas you retrieve Power\nStars, and you've chased\nBowser right out of here,\non to some area ahead.\nOh, by the by, are you\ncollecting coins? Special\nStars appear when you\ncollect 100 coins in each\nof the 15 courses!",
    [DIALOG_141] = "You've recovered one of\nthe stolen Power Stars!\nNow you can open some of\nthe sealed doors in the\ncastle.\nTry the Princess's room\non the second floor and\nthe room with the\npainting of Whomp's\nFortress on Floor 1.\nBowser's troops are still\ngaining power, so you\ncan't give up. Save us,\nMario! Keep searching for\nStars!",
    [DIALOG_154] = "Hold on to your hat! If\nyou lose it, you'll be\neasily injured. If you\nlose it, look for it in the\ncourse where you lost it.\nSpeaking of lost, the\nPrincess is still stuck in\nthe walls somewhere.\nPlease help, Mario!\n\nOh, you know that there\nare secret worlds in the\nwalls as well as in the\npaintings, right?",
    [DIALOG_155] = "Thanks to the power of\nthe Stars, life is\nreturning to the castle.\nPlease, Mario, you have\nto give Bowser the boot!\n\nHere, let me tell you a\nlittle something about the\ncastle. In the room with\nthe mirrors, look carefully\nfor anything that's not\nreflected in the mirror.\nAnd when you go to the\nwater town, you can flood\nit with a high jump into\nthe painting.",
    [DIALOG_161] = "Mario!!!\nIt that really you???\nIt has been so long since\nour last adventure!\nThey told me that I might\nsee you if I waited here,\nbut I'd just about given\nup hope!\nIs it true? Have you\nreally beaten Bowser? And\nrestored the Stars to the\ncastle?\nAnd saved the Princess?\nI knew you could do it!\nNow I have a very special\nmessage for you.\nThanks for playing Super\nMario 64! This is the\nend of the game, but not\nthe end of the fun.\n\nThe Super Mario 64 Team",
    [DIALOG_163] = "Noooo! You've really\nbeaten me this time,\nMario! I can't stand\nlosing to you!\n\nMy troops...worthless!\nThey've turned over all\nthe Power Stars! What?!\nThere are 120 in all???\n\nAmazing! There were some\nin the castle that I\nmissed??!!\n\n\nNow I see peace\nreturning to the world...\nOooo! I really hate that!\nI can't watch--\nI'm outta here!\nJust you wait until next\ntime. Until then, keep\nthat Control Stick\nsmokin'!\nBuwaa ha ha!",
    [DIALOG_164] = "Mario! What's up, pal?\nI haven't been on the\nslide lately, so I'm out\nof shape.\nStill, I'm always up for a\ngood race, especially\nagainst an old sleddin'\nbuddy.\nWhaddya say?\nReady...set...\n\n//Go//// Don't Go",
}

local DIALOG_LAYOUT = {
    [DIALOG_003] = {1, 5, 95, 200},
    [DIALOG_005] = {2, 3, 30, 200},
    [DIALOG_011] = {1, 4, 30, 200},
    [DIALOG_013] = {1, 5, 30, 200},
    [DIALOG_012] = {1, 4, 30, 200},
    [DIALOG_014] = {1, 4, 30, 200},
    [DIALOG_017] = {1, 4, 30, 200},
    [DIALOG_020] = {1, 6, 95, 150},
    [DIALOG_030] = {1, 6, 30, 200},
    [DIALOG_031] = {1, 5, 30, 200},
    [DIALOG_033] = {1, 6, 30, 200},
    [DIALOG_034] = {1, 6, 30, 200},
    [DIALOG_035] = {1, 5, 30, 200},
    [DIALOG_036] = {1, 5, 30, 200},
    [DIALOG_042] = {1, 4, 30, 200},
    [DIALOG_045] = {1, 6, 95, 200},
    [DIALOG_055] = {1, 4, 30, 200},
    [DIALOG_058] = {1, 4, 30, 200},
    [DIALOG_064] = {1, 5, 30, 200},
    [DIALOG_065] = {1, 6, 30, 200},
    [DIALOG_066] = {1, 5, 30, 200},
    [DIALOG_067] = {1, 5, 30, 200},
    [DIALOG_068] = {1, 5, 30, 200},
    [DIALOG_074] = {1, 5, 30, 200},
    [DIALOG_075] = {1, 5, 30, 200},
    [DIALOG_076] = {1, 6, 30, 200},
    [DIALOG_082] = {1, 4, 30, 200},
    [DIALOG_083] = {1, 6, 30, 200},
    [DIALOG_092] = {1, 5, 30, 200},
    [DIALOG_093] = {1, 5, 30, 200},
    [DIALOG_116] = {1, 5, 95, 200},
    [DIALOG_121] = {1, 5, 30, 200},
    [DIALOG_132] = {1, 4, 30, 200},
    [DIALOG_136] = {1, 6, 30, 200},
    [DIALOG_137] = {1, 6, 30, 200},
    [DIALOG_141] = {1, 5, 150, 200},
    [DIALOG_154] = {1, 5, 30, 200},
    [DIALOG_155] = {1, 6, 30, 200},
    [DIALOG_161] = {1, 4, 30, 200},
    [DIALOG_163] = {1, 5, 30, 200},
    [DIALOG_164] = {1, 4, 30, 200},
}

local function replace_mario_in_dialog(text, character_name, is_yoshi)
    if is_yoshi then
        return text:gsub("Mario", character_name, 1)
    else
        return text:gsub("Mario", character_name)
    end
end

hook_event(HOOK_ON_HUD_RENDER, function()
    local m = gMarioStates[0]
    if not m or not m.character or not m.character.type then return end

    local char_id = m.character.type
    local character_name = CHARACTER_NAMES[char_id]
    
    if not character_name then return end
    
    for dialog_id, original_text in pairs(DIALOGS) do
        local is_yoshi = YOSHI[dialog_id] or false
        local modified_text = replace_mario_in_dialog(original_text, character_name, is_yoshi)
        
        local layout = DIALOG_LAYOUT[dialog_id]
        if layout then
            local linesPerBox = layout[1]
            local leftOffset = layout[2] 
            local width = layout[3]
            local height = layout[4]
            
            smlua_text_utils_dialog_replace(dialog_id, linesPerBox, leftOffset, width, height, modified_text)
        end
    end
end)