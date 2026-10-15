; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $01d", ROMX[$4000], BANK[$1d]

;@ path: text/dialogs
;@ Dialog $180: "Make-up! Jewels! Dresses! I want it all! Sigh... And some new acces..."
Dialog180::
	db "Make-up! Jewels!"
	db "Dresses!  I want"
	db "it all!  Sigh..."
	db "And some new    "
	db "accessories     "
	db "would be nice..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $181: "Make-up! Jewels! Dresses! I want it all! Sigh... And some new acces..."
Dialog181::
	db "Make-up! Jewels!"
	db "Dresses!  I want"
	db "it all!  Sigh..."
	db "And some new    "
	db "accessories     "
	db "would be nice..."
	db "Oh! That Ribbon!"
	db "I need it!  Will"
	db "you trade for my"
	db "dog food?       "
	db "    Yes  No!"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $182: "You exchanged ? for ?! It's full of juicy beef!"
Dialog182::
	db "You exchanged ", $e1, " "
	db "for ", $e2, "! It^s full"
	db "of juicy beef!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $183: "Lucky! Thanks! Well, here's your ?!"
Dialog183::
	db "Lucky!  Thanks! "
	db "Well, here^s    "
	db "your ", $e2, "!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $184: "Eh?! I can't believe it! You are the worst!!"
Dialog184::
	db "Eh?!  I can^t   "
	db "believe it!  You"
	db "are the worst!!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $185: "I am Manbo, child of the Sun Fish! Have you got an Ocarina? Yes No"
Dialog185::
	db "I am Manbo,     "
	db "child of the Sun"
	db "Fish!  Have you "
	db "got an Ocarina? "
	db "    Yes  No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $186: "Very well... Glub Blub Bloop!"
Dialog186::
	db "Very well...    "
	db "Glub Blub Bloop!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $187: "Ahaha! Then I can teach you my song! Bloop!"
Dialog187::
	db "Ahaha!  Then I  "
	db "can teach you my"
	db "song! Bloop!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $188: "You've learned Manbo's Mambo! When you get out of the water, play it!"
Dialog188::
	db "You^ve learned  "
	db "Manbo^s Mambo!  "
	db "When you get out"
	db "of the water,   "
	db "play it!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $189: "I am Manbo, child of the Sun Fish! When you play my Mambo, you can ..."
Dialog189::
	db "I am Manbo,     "
	db "child of the Sun"
	db "Fish!  When you "
	db "play my Mambo,  "
	db "you can warp to "
	db "Manbo Pond!  Try"
	db "this tune in the"
	db "dungeons, too!  "
	db "Cha-cha-cha!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $18A: "Aha... You don't have an Ocarina, so...Glub glub!"
Dialog18A::
	db "Aha... You don^t"
	db "have an Ocarina,"
	db "so...Glub glub!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $18B: "Chickens these days don't have the fighting spirit they used to! In..."
Dialog18B::
	db "Chickens these  "
	db "days don^t have "
	db "the fighting    "
	db "spirit they used"
	db "to!  In the old "
	db "days, they could"
	db "fly, flap flap! "
	db "But now, see?   "
	db "Cluck cluck!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $18C: "Wow! Amazing! That rooster is actually flying! It's just like I sai..."
Dialog18C::
	db "Wow!  Amazing!  "
	db "That rooster is "
	db "actually flying!"
	db "It^s just like I"
	db "said, eh?  Have "
	db "you tried to    "
	db "hold him over   "
	db "your head? Cluck"
	db "Cluck!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $18D: "Wooo! Finally! This flying rooster is the greatest!"
Dialog18D::
	db "Wooo!  Finally! "
	db "This flying     "
	db "rooster is the  "
	db "greatest!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $18E: "Here Sleeps The Flying Rooster"
Dialog18E::
	db " Here Sleeps The"
	db " Flying Rooster"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $18F, $190: "Ennh? Who's this suspicious- looking runt?! Okay boys, let's get ri..."
Dialog18F::
	db "Ennh?  Who^s    "
	db "this suspicious-"
	db "looking runt?!  "
	db "Okay boys, let^s"
	db "get ridda him!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $191: "You must be an assassin sent by Madam MeowMeow to rescue the mutt! ..." (B does not hurry it)
Dialog191::
	db "You must be an  "
	db "assassin sent by"
	db "Madam MeowMeow  "
	db "to rescue the   "
	db "mutt!  You came "
	db "here to get me, "
	db "but it is I who "
	db "will get you!!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $192: "Oh, [NAME]. I often come to this village to sing, too! It seems tha..."
Dialog192::
	db "Oh, #####.  I   "
	db "often come to   "
	db "this village to "
	db "sing, too!  It  "
	db "seems that just "
	db "about everyone  "
	db "loves my ^Ballad"
	db "of the Wind     "
	db "Fish!^  #####,  "
	db "what is your    "
	db "favorite song?"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $193: "Please, don't ever forget this song...or me..."
Dialog193::
	db "Please, don^t   "
	db "ever forget this"
	db "song...or me..."
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $194: "Thank you for everything! [NAME], you are the kindest boy I know. O..." (B does not hurry it)
Dialog194::
	db "Thank you for   "
	db "everything!     "
	db "#####, you are  "
	db "the kindest boy "
	db "I know.  One day"
	db "I made a wish to"
	db "the Wind Fish..."
	db "What was the    "
	db "wish?  It was..."
	db "No, it^s secret!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $195: "[NAME], some day you will leave this island... I just know it in my..."
Dialog195::
	db "#####, some day "
	db "you will leave  "
	db "this island...  "
	db "I just know it  "
	db "in my heart...  "
	db "...Don^t ever   "
	db "forget me... If "
	db "you do, I^ll    "
	db "never forgive   "
	db "you!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $196: "... ... ... ... It seems to be totally absorbed in Marin's song!"
Dialog196::
	db "... ... ... ... "
	db "It seems to be  "
	db "totally absorbed"
	db "in Marin^s song!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $197: "They say the 'Ballad of the Wind Fish' is a song of awaken- ing. I ..."
Dialog197::
	db "They say the    "
	db "^Ballad of the  "
	db "Wind Fish^ is a "
	db "song of awaken- "
	db "ing.  I wonder, "
	db "if the Wind Fish"
	db "wakes up, will  "
	db "he make my wish "
	db "come true?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $198: "Eh? You want me to go in there? No, I think I'll wait out here... T..."
Dialog198::
	db "Eh?  You want me"
	db "to go in there? "
	db "No, I think I^ll"
	db "wait out here..."
	db "Take care of    "
	db "yourself, #####!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $199: "Ahhh! Ahhh, you are a bad boy, [NAME]!"
Dialog199::
	db "Ahhh!  Ahhh, you"
	db "are a bad boy,  "
	db "#####!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $19A: "Here's some bonus treatment! Behold! Your Hearts are full!"
Dialog19A::
	db "Here^s some     "
	db "bonus treatment!"
	db "Behold!  Your   "
	db "Hearts are full!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $19B: "Ya, I am Schule Donavitch! Zee mermaid statue by zee bay iz my mast..."
Dialog19B::
	db "Ya, I am Schule "
	db "Donavitch!  Zee "
	db "mermaid statue  "
	db "by zee bay iz my"
	db "masterpiece! ..."
	db "To tell you zee "
	db "truth, zis werk "
	db "iz not complete!"
	db "Zee art, it^z..."
	db "difficult for   "
	db "you to grasp, iz"
	db "it not?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $19C: "THE MOURNING MERMAID By SCHULE ? ...A scale is missing..."
Dialog19C::
	db "  THE MOURNING  "
	db "     MERMAID    "
	db "    By SCHULE   "
	db "? ...A scale is "
	db "missing..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $19D: "Seashell Mansion"
Dialog19D::
	db "Seashell Mansion"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $19E: "Entrance to Yarna Desert ?"
Dialog19E::
	db "Entrance to     "
	db "  Yarna Desert ", $f3
	db $ff  ; end
;@ path: text/dialogs
;@ Dialogs $19F, $1A0: "Mysterious Forest (It's a little bit mysterious)"
Dialog19F::
	db "   Mysterious   "
	db "     Forest     "
	db " (It^s a little "
	db " bit mysterious)"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1A1: "Do you want to challenge the river rapids on a raft? Proceed to the..."
Dialog1A1::
	db "Do you want to  "
	db "challenge the   "
	db "river rapids on "
	db "a raft?  Proceed"
	db "to the office at"
	db "once, please!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1A2: "East ? Ukuku Prairie Farther East Animal Village"
Dialog1A2::
	db "East ", $f3, " Ukuku    "
	db "       Prairie  "
	db "Farther East    "
	db "  Animal Village"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $1A3: "Mt. Tamaranch"
Dialog1A3::
	db "Mt. Tamaranch   "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1A4: "? Tail Cave ? Toronbo Shores"
Dialog1A4::
	db $f3, " Tail Cave     "
	db $f1, " Toronbo Shores"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1A5: "? Gopongo Swamp ? Mysterious Forest"
Dialog1A5::
	db $f3, " Gopongo Swamp "
	db $f1, " Mysterious    "
	db "  Forest"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1A6: "Beware of floors with cracks! A heavy person should not stand on th..."
Dialog1A6::
	db "Beware of floors"
	db "with cracks!  A "
	db "heavy person    "
	db "should not stand"
	db "on them!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1A7: "Telephone Booth"
Dialog1A7::
	db "Telephone Booth "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1A8: "DANGER! Keep out! (Except BowWow)"
Dialog1A8::
	db "     DANGER!    "
	db "    Keep out!   "
	db "(Except BowWow)"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1A9: "? GO THIS WAY"
Dialog1A9::
	db $f1, " GO THIS WAY"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1AA: "? GO THIS WAY"
Dialog1AA::
	db $f0, " GO THIS WAY"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1AB: "? GO THIS WAY"
Dialog1AB::
	db $f3, " GO THIS WAY"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1AC: "? GO THIS WAY"
Dialog1AC::
	db $f2, " GO THIS WAY"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1AD: "TRY AGAIN FROM THE START"
Dialog1AD::
	db " TRY AGAIN FROM "
	db "   THE START"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1AE: "GREAT! YOU DID IT! YOUR REWARD IS ? THIS WAY!"
Dialog1AE::
	db "GREAT!  YOU DID "
	db "IT!  YOUR REWARD"
	db "IS ", $f3, " THIS WAY!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1AF: "GONE ON TOUR MAMU"
Dialog1AF::
	db "GONE ON TOUR    "
	db "         MAMU"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1B0: "? Crazy Tracy ? Manbo's Pond"
Dialog1B0::
	db $f3, " Crazy Tracy   "
	db $f1, " Manbo^s Pond"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1B1: "? Animal Village ? Martha's Bay"
Dialog1B1::
	db $f3, " Animal Village"
	db $f1, " Martha^s Bay"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1B2: "? Welcome to the Animal Village!"
Dialog1B2::
	db $f3, " Welcome to the"
	db " Animal Village!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1B3: "? Cemetary ? Ukuku Prairie"
Dialog1B3::
	db $f3, " Cemetary      "
	db $f1, " Ukuku Prairie "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1B4: "Tal Tal Heights"
Dialog1B4::
	db "Tal Tal Heights"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1B5: "? Tamaranch Mt. ? Goponga Swamp"
Dialog1B5::
	db $f3, " Tamaranch Mt. "
	db $f2, " Goponga Swamp "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1B6: "MUSIC, THE FISH STIRS IN THE EGG YOU ARE THERE..."
Dialog1B6::
	db "MUSIC, THE FISH "
	db "STIRS IN THE EGG"
	db "YOU ARE THERE..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1B7: "THE WIND FISH IN NAME ONLY, FOR IT IS NEITHER."
Dialog1B7::
	db "THE WIND FISH IN"
	db "NAME ONLY, FOR  "
	db "IT IS NEITHER."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1B8: "IN SOIL SLEEPS SECRETS, BENEATH YOUR SOLES..."
Dialog1B8::
	db "IN SOIL SLEEPS  "
	db "SECRETS, BENEATH"
	db "YOUR SOLES..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1B9: "IN SOIL SLEEPS SECRETS, BENEATH YOUR SOLES..."
Dialog1B9::
	db "IN SOIL SLEEPS  "
	db "SECRETS, BENEATH"
	db "YOUR SOLES..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1BA: "AROUND HERE, SECRETS ARE NIGH"
Dialog1BA::
	db "AROUND HERE,    "
	db "SECRETS ARE NIGH"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1BB: "SECRETS ARE LIKE WATER WHEN IT COMES TO BRIDGES"
Dialog1BB::
	db "SECRETS ARE LIKE"
	db "WATER WHEN IT   "
	db "COMES TO BRIDGES"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1BC: "NOW YOU NEED LOOK FAR FOR A SECRET..."
Dialog1BC::
	db "NOW YOU NEED    "
	db "LOOK FAR FOR    "
	db "A SECRET..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1BD: "THE WIND FISH SLUMBERS LONG... THE HERO'S LIFE GONE..."
Dialog1BD::
	db "THE WIND FISH   "
	db "SLUMBERS LONG..."
	db "THE HERO^S LIFE "
	db "GONE..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1BE: "SEA BEARS FOAM, SLEEP BEARS DREAMS. BOTH END IN THE SAME WAY CRASSSH!"
Dialog1BE::
	db "SEA BEARS FOAM, "
	db "SLEEP BEARS     "
	db "DREAMS. BOTH END"
	db "IN THE SAME WAY "
	db "CRASSSH!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $1BF, $1C0: "Oh?! [NAME], I see ya have a nice stick... Can I borrow it for a se..."
Dialog1BF::
	db "Oh?!  #####, I  "
	db "see ya have a   "
	db "nice stick...   "
	db "Can I borrow it "
	db "for a second?   "
	db "    Can  Can^t"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $1C1: "? became the honeycomb ?! You're not sure how it happened, but take..." (B does not hurry it)
Dialog1C1::
	db $e4, " became the    "
	db "honeycomb ", $e5, "!    "
	db "You^re not sure "
	db "how it happened,"
	db "but take it!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1C2: "Hmmm, [NAME], you are mean!"
Dialog1C2::
	db "Hmmm, #####, you"
	db "are mean!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1C3: "Beware of Sea Urchins! Don't touch them with your bare hands!"
Dialog1C3::
	db "Beware of Sea   "
	db "Urchins!  Don^t "
	db "touch them with "
	db "your bare hands!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $1C4, $1C5: "I was hungry somethin' fierce so I went and got bananas at the beac..."
Dialog1C4::
	db "I was hungry    "
	db "somethin^ fierce"
	db "so I went and   "
	db "got bananas at  "
	db "the beach...    "
	db "#####, if you   "
	db "want some, you  "
	db "should go and   "
	db "get some!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1C6: "Welcome to Sale's House O' Bananas! I'm Sale, this is my house! Act..."
Dialog1C6::
	db "Welcome to      "
	db "Sale^s House O^ "
	db "Bananas!  I^m   "
	db "Sale, this is my"
	db "house! Actually,"
	db "my hobby is col-"
	db "lecting rare and"
	db "unusual canned  "
	db "food. My brother"
	db "is an artist, so"
	db "I guess strange "
	db "hobbies run in  "
	db "the family!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $1C7: "What's that you have?! It's canned food! For heaven's sake, man, gi..."
Dialog1C7::
	db "What^s that you "
	db "have?!  It^s    "
	db "canned food! For"
	db "heaven^s sake,  "
	db "man, give that ", $e2
	db "to ME!!  PLEASE!"
	db "He^s hysterical!"
	db "What do you do? "
	db "    Give Don^t"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $1C8: "Oh thank you! I'll take that!"
Dialog1C8::
	db "Oh thank you!   "
	db "I^ll take that!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1C9: "I don't suppose it would do any good to beg? Well, if you change yo..."
Dialog1C9::
	db "I don^t suppose "
	db "it would do any "
	db "good to beg?    "
	db "Well, if you    "
	db "change your     "
	db "mind, tell me."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1CA: "MUNCH MUNCH!! ... ... ... ... That was great! I know it's not a fai..."
Dialog1CA::
	db "  MUNCH MUNCH!! "
	db "... ... ... ... "
	db "That was great! "
	db "I know it^s not "
	db "a fair trade,   "
	db "but here^s some "
	db "bananas! YUM..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1CB: "You gave him ? and got bananas ? in return! Good deal!"
Dialog1CB::
	db "You gave him ", $e2, "  "
	db "and got bananas "
	db $e3, " in return!    "
	db "Good deal!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1CC: "Thank you again! That was yummy!"
Dialog1CC::
	db "Thank you again!"
	db "That was yummy!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1CD: "Hey friend! Have you ever ridden the rapids on a raft? You can, nea..."
Dialog1CD::
	db "Hey friend! Have"
	db "you ever ridden "
	db "the rapids on a "
	db "raft?  You can, "
	db "near Tal Tal    "
	db "Heights!  You   "
	db "ought to try it!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1CE: "Rik'm rak'm! I ran out of ingredients! If I had honey, I could make..."
Dialog1CE::
	db "Rik^m rak^m! I  "
	db "ran out of      "
	db "ingredients!  If"
	db "I had honey, I  "
	db "could make this "
	db "fit for a king!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1CF: "Hi ho! Hey you! Is that possibly a ? you have? I just ran out! Will..."
Dialog1CF::
	db "Hi ho! Hey you! "
	db "Is that possibly"
	db "a ", $e5, " you have?   "
	db "I just ran out! "
	db "Will you swap it"
	db "for a pineapple?"
	db "    Yes  No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $1D0: "You exchanged ? for ?! It's not as sweet, but it is delicious!"
Dialog1D0::
	db "You exchanged ", $e5, " "
	db "for ", $e6, "!  It^s not"
	db "as sweet, but it"
	db "is delicious!   "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1D1: "That's a crying shame, but I realize those are a rare delicacy!"
Dialog1D1::
	db "That^s a crying "
	db "shame, but I    "
	db "realize those   "
	db "are a rare      "
	db "delicacy!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1D2: "Hi ho! Yeah, I know, that tub of goo is asleep right in the way to ..."
Dialog1D2::
	db "Hi ho! Yeah, I  "
	db "know, that tub  "
	db "of goo is asleep"
	db "right in the way"
	db "to Yarna Desert!"
	db "Once he^s asleep"
	db "he won^t budge  "
	db "for a loooooonng"
	db "time.  But hey! "
	db "Take Little     "
	db "Marin and wake  "
	db "him up with her "
	db "song!  That slob"
	db "would wake up   "
	db "with a jump if  "
	db "he heard her    "
	db "sing, for sure! "
	db "Heh heh heh!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1D3: "My ultimate plan is to open a branch in Mabe Village!"
Dialog1D3::
	db "My ultimate plan"
	db "is to open a    "
	db "branch in Mabe  "
	db "Village!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1D4: "HI HO! Little Marin! Welcome! ... ... ... ... Oh, shucks! You are h..."
Dialog1D4::
	db "HI HO!  Little  "
	db "Marin!  Welcome!"
	db "... ... ... ... "
	db "Oh, shucks!  You"
	db "are here too... "
	db "Sorry..."
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $1D5: "Oh, [NAME], I'm glad you found this place. Will you stay and talk t..." (B does not hurry it)
Dialog1D5::
	db "Oh, #####, I^m  "
	db "glad you found  "
	db "this place.     "
	db "Will you stay   "
	db "and talk to me  "
	db "for a while?    "
	db "    Yes! No..."
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $1D6: "Okay, I'll just watch the waves for a while..."
Dialog1D6::
	db "Okay, I^ll just "
	db "watch the waves "
	db "for a while..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1D7: "At the beach... Marin ?"
Dialog1D7::
	db "At the beach... "
	db " Marin  ", $de
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1D8: "I wonder where these coconut trees come from? ...Tarin says there i..." (B does not hurry it)
Dialog1D8::
	db "I wonder where  "
	db "these coconut   "
	db "trees come from?"
	db "...Tarin says   "
	db "there is nothing"
	db "beyond the sea, "
	db "but I believe   "
	db "there must be   "
	db "something over  "
	db "there...  When I"
	db "discovered you, "
	db "#####, my heart "
	db "skipped a beat! "
	db "I thought, this "
	db "person has come "
	db "to give us a    "
	db "message..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1D9: "... ... ... ... ... ... ... ... If I was a sea gull, I would fly as..." (B does not hurry it)
Dialog1D9::
	db "... ... ... ... "
	db "... ... ... ... "
	db "If I was a sea  "
	db "gull, I would   "
	db "fly as far as I "
	db "could!  I would "
	db "fly to far away "
	db "places and sing "
	db "for many people!"
	db "...If I wish to "
	db "the Wind Fish,  "
	db "I wonder if my  "
	db "dream will come "
	db "true... ... ..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1DA: "Hey! Are you listening? [NAME], are you listening to me? Yeah No..."
Dialog1DA::
	db "Hey!  Are you   "
	db "listening?      "
	db "#####, are you  "
	db "listening to me?"
	db "    Yeah No..."
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $1DB: "I want to know everything about you...Err...Uhh, Ha ha ha ha!"
Dialog1DB::
	db "I want to know  "
	db "everything about"
	db "you...Err...Uhh,"
	db "Ha ha ha ha!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1DC: "Hunh? The walrus wants me to go to him? It doesn't matter, I will g..."
Dialog1DC::
	db "Hunh? The walrus"
	db "wants me to go  "
	db "to him?  It     "
	db "doesn^t matter, "
	db "I will go with  "
	db "you to him..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1DD: "Unnnngh! Owwwww! ... ... ... ... I've sure lost my taste for honey!"
Dialog1DD::
	db "Unnnngh! Owwwww!"
	db "... ... ... ... "
	db "I^ve sure lost  "
	db "my taste for    "
	db "honey!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1DE: "Humph! Your head is always in the clouds! Will you please listen to..."
Dialog1DE::
	db "Humph! Your head"
	db "is always in the"
	db "clouds! Will you"
	db "please listen to"
	db "me next time?!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $1DF, $1E0: "ZZZ ZZZ ZZZ ZZZ ... ? ... ? ..."
Dialog1DF::
	db "ZZZ ZZZ ZZZ ZZZ "
	db " ... ", $de, " ... ", $de, " ..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1E1: "Yes, it's that lazy walrus! Shall we give him a little surprise? Ye..."
Dialog1E1::
	db "Yes, it^s that  "
	db "lazy walrus!    "
	db "Shall we give   "
	db "him a little    "
	db "surprise?       "
	db "    Yes  No..."
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $1E2: "Aha ha ha! Wow! He certainly woke with a start!"
Dialog1E2::
	db "Aha ha ha!  Wow!"
	db "He certainly    "
	db "woke with a     "
	db "start!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1E3: "Hunh? Oh, he's calling me... It's the same as always... Ha ha!"
Dialog1E3::
	db "Hunh?  Oh, he^s "
	db "calling me...   "
	db "It^s the same as"
	db "always... Ha ha!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1E4: "You're right, it would be mean to wake him up now! Let's let him sl..."
Dialog1E4::
	db "You^re right, it"
	db "would be mean to"
	db "wake him up now!"
	db "Let^s let him   "
	db "sleep some more!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1E5: "[NAME], I'm going to the Animal Village! Please drop by, okay?"
Dialog1E5::
	db "#####, I^m going"
	db "to the Animal   "
	db "Village!  Please"
	db "drop by, okay?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1E6: "Arfh! Arfh! Arf! ? ?! ? ?! ..... ???"
Dialog1E6::
	db "Arfh! Arfh! Arf!"
	db " ", $de, "  ", $de, "!  ", $de, "   ", $de, "!  "
	db "..... ", $dd, "?? "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1E7: "It's no use, little buddy! A fish took my hook... I keep casting my..."
Dialog1E7::
	db "It^s no use,    "
	db "little buddy!  A"
	db "fish took my    "
	db "hook... I keep  "
	db "casting my line "
	db "into the water, "
	db "but I haven^t   "
	db "got a bite... I "
	db "thought this    "
	db "would happen..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1E8: "Oh! What is that you have in your hand? It's not a fishing hook, is..."
Dialog1E8::
	db "Oh! What is that"
	db "you have in your"
	db "hand?  It^s not "
	db "a fishing hook, "
	db "is it?  You had "
	db "better let me   "
	db "have it.  I^ll  "
	db "give you my next"
	db "catch if you let"
	db "me have it...   "
	db "    Okay No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $1E9: "All right, boy, feast your eyes on a display of fishing skill!"
Dialog1E9::
	db "All right, boy, "
	db "feast your eyes "
	db "on a display of "
	db "fishing skill!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1EA: "You should be more kind to me! I thought we were buddies!"
Dialog1EA::
	db "You should be   "
	db "more kind to me!"
	db "I thought we    "
	db "were buddies!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1EB: "Whoooah nellie!! It's a big one!! Big! Big! Yaaah!" (B does not hurry it)
Dialog1EB::
	db "Whoooah nellie!!"
	db "It^s a big one!!"
	db "Big! Big! Yaaah!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $1EC: "The ? became a necklace ?! L-l-lucky!"
Dialog1EC::
	db "The ", $e9, " became a  "
	db "necklace ", $ea, "!     "
	db "L-l-lucky!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1ED: "I can't wait to see what I'll catch next!"
Dialog1ED::
	db "I can^t wait to "
	db "see what I^ll   "
	db "catch next!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $1EE, $1EF, $1F0: "When I was swim- ming in the bay, the waves took a very important n..."
Dialog1EE::
	db "When I was swim-"
	db "ming in the bay,"
	db "the waves took a"
	db "very important  "
	db "necklace from   "
	db "around my neck! "
	db "If you find it, "
	db "I will let you  "
	db "take a scale    "
	db "from my tail!   "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1F1: "I have already looked around here!"
Dialog1F1::
	db "I have already  "
	db "looked around   "
	db "here!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1F2: "Ahh! That's it! That's my neck- lace! Give it! Give it back! I will..."
Dialog1F2::
	db "Ahh!  That^s it!"
	db "That^s my neck- "
	db "lace!  Give it! "
	db "Give it back!  I"
	db "will give you a "
	db "scale as I said!"
	db "    Give Keep"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $1F3: "Promise! You'll only take one!"
Dialog1F3::
	db "Promise!  You^ll"
	db "only take one!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1F4: "You are heart- less and cruel!"
Dialog1F4::
	db "You are heart-  "
	db "less and cruel!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1F5: "You returned the necklace ? and got a scale ? of the mermaid's tail..." (B does not hurry it)
Dialog1F5::
	db "You returned the"
	db "necklace ", $ea, " and  "
	db "got a scale ", $eb, " of"
	db "the mermaid^s   "
	db "tail.  How will "
	db "you use this?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $1F6, $1F7: "An artist once asked me to pose for him, and he wanted a scale, too..."
Dialog1F6::
	db "An artist once  "
	db "asked me to pose"
	db "for him, and he "
	db "wanted a scale, "
	db "too...  Can the "
	db "legend of the   "
	db "Magnifying Lens "
	db "be true...?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $1F8, $1F9: "Richard's Villa"
Dialog1F8::
	db "Richard^s Villa "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1FA: "Kanalet Castle 10 Min. ? ?"
Dialog1FA::
	db "Kanalet Castle  "
	db "10 Min. ", $f3, " ", $f0
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1FB: "Kanalet Castle 5 Min. ?"
Dialog1FB::
	db "Kanalet Castle  "
	db "5 Min. ", $f3
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1FC: "Kanalet Castle 50 Paces ?"
Dialog1FC::
	db "Kanalet Castle  "
	db "50 Paces ", $f0
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $1FD: "'BRRING! BRRING! BRRING! CLICK! Yeees! It's the Bucket Mouse! Thank..."
Dialog1FD::
	db "^BRRING! BRRING!"
	db " BRRING! CLICK! "
	db "Yeees!  It^s the"
	db "Bucket Mouse!   "
	db "Thanks for call-"
	db "ing! ...Well... "
	db "CLICK!^  ??? ..."
	db "You must have   "
	db "dialed a wrong  "
	db "number..."
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $1FE: "Oh! It's a big one! And it has a Piece of Heart, too! You get a 20 ..." (B does not hurry it)
Dialog1FE::
	db "Oh!  It^s a big "
	db "one!  And it has"
	db "a Piece of      "
	db "Heart, too!  You"
	db "get a 20 Rupee  "
	db "prize on top of "
	db "that! Try again?"
	db "    Yes  No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $1FF: "Oh! It's a big one! And it has a Piece of Heart, too! You have comp..." (B does not hurry it)
Dialog1FF::
	db "Oh!  It^s a big "
	db "one!  And it has"
	db "a Piece of      "
	db "Heart, too!  You"
	db "have completed  "
	db "another Heart   "
	db "Container!  On  "
	db "top of that, you"
	db "get a 20 Rupee  "
	db "prize! Want to  "
	db "try again?      "
	db "    Yes  No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $200: "'How To Handle Your Shield Like A Pro!' Read this book? Read Don't"
Dialog200::
	db " ^How To Handle "
	db "   Your Shield  "
	db "   Like A Pro!^ "
	db "Read this book? "
	db "    Read Don^t"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $201: "'If you hold the Button down, you can defend your- self from enemy ..."
Dialog201::
	db "^If you hold the"
	db "Button down, you"
	db "can defend your-"
	db "self from enemy "
	db "attacks, and you"
	db "can fillip some "
	db "enemies, too... "
	db "Besides the     "
	db "standard shield "
	db "there is also a "
	db "mirrored variety"
	db "which can defend"
	db "against beams!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $202: "'Selecting The Item That's Right For You' Read this book? Read Don't"
Dialog202::
	db " ^Selecting The "
	db "   Item That^s  "
	db "  Right For You^"
	db "Read this book? "
	db "    Read Don^t"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $203: "'You can select your favorite item for the A and B Buttons on the S..."
Dialog203::
	db "^You can select "
	db "your favorite   "
	db "item for the A  "
	db "and B Buttons on"
	db "the Sub-Screen. "
	db "Using different "
	db "items, you can  "
	db "fight without a "
	db "sword!  Try many"
	db "different things"
	db "to find what^s  "
	db "right for you!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $204: "'Auto Map and Memo Guide Book' Read this book? Read Don't"
Dialog204::
	db " ^Auto Map and  "
	db "Memo Guide Book^"
	db "Read this book? "
	db "    Read Don^t"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $205: "'You can see an island map by pressing the SELECT Button. The dark ..."
Dialog205::
	db "^You can see an "
	db "island map by   "
	db "pressing the    "
	db "SELECT Button.  "
	db "The dark parts  "
	db "of the map are  "
	db "places you have "
	db "not yet visited."
	db "Move the cursor "
	db "and press the A "
	db "Button to get   "
	db "more information"
	db "about an area,  "
	db "or to replay the"
	db "message you got "
	db "there...^  Ahhh!"
	db "How convenient!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $206: "'Secrets Of The Whirling Blade' Read this book? Read Don't"
Dialog206::
	db " ^Secrets Of The"
	db " Whirling Blade^"
	db "Read this book? "
	db "    Read Don^t"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $207: "'The Whirling Blade technique has been handed down from gener- atio..."
Dialog207::
	db "^The Whirling   "
	db "Blade technique "
	db "has been handed "
	db "down from gener-"
	db "ation to gener- "
	db "ation by the    "
	db "family of the   "
	db "hero. To use it,"
	db "hold down the   "
	db "Sword Button and"
	db "build up your   "
	db "power.  When you"
	db "have enough, you"
	db "can release the "
	db "Button!  Can you"
	db "master this?^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $208: "'The Properties Of Warp Holes' Read this book? Read Don't"
Dialog208::
	db "^The Properties "
	db "  Of Warp Holes^"
	db "Read this book? "
	db "    Read Don^t"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $209: "'There are some Warp Holes on Koholint Island. You can warp to and ..."
Dialog209::
	db "^There are some "
	db "Warp Holes on   "
	db "Koholint Island."
	db "You can warp to "
	db "and fro using   "
	db "these holes.  If"
	db "you jump into   "
	db "the Warp Hole   "
	db "at which you    "
	db "arrived, you    "
	db "will go to the  "
	db "next one in the "
	db "sequence.  You  "
	db "can only warp to"
	db "a hole you have "
	db "seen with your  "
	db "own eyes...^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $20A: "'Fun With Bombs' Read this book? Read Don't"
Dialog20A::
	db "^Fun With Bombs^"
	db "Read this book? "
	db "    Read Don^t"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $20B: "'After you put a Bomb down, you can pick it up by pressing the Butt..."
Dialog20B::
	db "^After you put a"
	db "Bomb down, you  "
	db "can pick it up  "
	db "by pressing the "
	db "Button again.   "
	db "You can then    "
	db "throw it by     "
	db "pushing the     "
	db "Button one more "
	db "time.  Did you  "
	db "know that?^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $20C: "'Atlas Of Koholint Island' You can move the cursor and look up the ..."
Dialog20C::
	db "   ^Atlas Of    "
	db "Koholint Island^"
	db "You can move the"
	db "cursor and look "
	db "up the name of a"
	db "place...  Do you"
	db "want to look at "
	db "this map?       "
	db "    Look Don^t"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $20D: "'Dark Secrets And Mysteries Of Koholint' Do you really want to read..."
Dialog20D::
	db " ^Dark Secrets  "
	db "  And Mysteries "
	db "   Of Koholint^ "
	db "Do you really   "
	db "want to read it?"
	db "    Yes! N-No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $20E: "Gasp! Wha-What's this! ... ... You can't read the tiny print withou..."
Dialog20E::
	db "Gasp! Wha-What^s"
	db "this! ... ...   "
	db "You can^t read  "
	db "the tiny print  "
	db "without the aid "
	db "of a magnifying "
	db "glass..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $20F, $210: "...my grave... ...take me... ...my grave..."
Dialog20F::
	db "...my grave...  "
	db "...take me...   "
	db "...my grave..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $211: "...the house... ...take me... ...the house... ...at the bay..." (B does not hurry it)
Dialog211::
	db "...the house... "
	db " ...take me...  "
	db "...the house... "
	db "...at the bay..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $212: "...N-N-No!... ...N-not there!"
Dialog212::
	db "...N-N-No!...   "
	db "...N-not there!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $213: "...Here!... ...enter... ...my house..." (B does not hurry it)
Dialog213::
	db "   ...Here!...  "
	db "   ...enter...  "
	db " ...my house..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $214: "...Nostalgia... ...unchanged... ...boo hoo..." (B does not hurry it)
Dialog214::
	db " ...Nostalgia..."
	db " ...unchanged..."
	db " ...boo hoo..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $215: "...Enough... ...cemetary... ...take me... ...my grave..." (B does not hurry it)
Dialog215::
	db "  ...Enough...  "
	db " ...cemetary... "
	db "  ...take me... "
	db " ...my grave..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $216: "...Thank you... ...a jar... ...in my home... ...look inside.. ...by..." (B does not hurry it)
Dialog216::
	db "...Thank you... "
	db " ...a jar...    "
	db "...in my home..."
	db "...look inside.."
	db "...bye...bye..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $217: "Round and round, the passageways of the Egg... ? ? ? ? ? ? ? ? ?? ...."
Dialog217::
	db "Round and round,"
	db "the passageways "
	db "of the Egg...   "
	db $f2, " ", $f2, " ", $f0, " ", $f3, " ", $f3, " ", $f0, " ", $f2, " ", $f0, " "
	db "??  ...Hmmmmmm, "
	db "this book reeks "
	db "of secrets..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $218: "Round and round, the passageways of the Egg... ? ? ? ? ? ? ? ? ?? ...."
Dialog218::
	db "Round and round,"
	db "the passageways "
	db "of the Egg...   "
	db $f3, " ", $f0, " ", $f0, " ", $f3, " ", $f0, " ", $f0, " ", $f3, " ", $f0, " "
	db "??  ...Hmmmmmm, "
	db "this book reeks "
	db "of secrets..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $219: "Round and round, the passageways of the Egg... ? ? ? ? ? ? ? ? ?? ...."
Dialog219::
	db "Round and round,"
	db "the passageways "
	db "of the Egg...   "
	db $f2, " ", $f0, " ", $f3, " ", $f0, " ", $f2, " ", $f0, " ", $f3, " ", $f0, " "
	db "??  ...Hmmmmmm, "
	db "this book reeks "
	db "of secrets..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $21A: "Round and round, the passageways of the Egg... ? ? ? ? ? ? ? ? ?? ...."
Dialog21A::
	db "Round and round,"
	db "the passageways "
	db "of the Egg...   "
	db $f3, " ", $f3, " ", $f3, " ", $f3, " ", $f0, " ", $f0, " ", $f0, " ", $f0, " "
	db "??  ...Hmmmmmm, "
	db "this book reeks "
	db "of secrets..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $21B: "...You're late! I thought you'd never come back!"
Dialog21B::
	db "...You^re late! "
	db "I thought you^d "
	db "never come back!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $21C: "...EEEK! You're hurt! Arrrgh! Don't be so reckless!"
Dialog21C::
	db "...EEEK!  You^re"
	db "hurt!  Arrrgh!  "
	db "Don^t be so     "
	db "reckless!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $21D: "[NAME]! You're back! Are you hurt?"
Dialog21D::
	db "#####! You^re   "
	db "back!  Are you  "
	db "hurt?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $21E: "...You idiot! I told you this would happen... Eh?! What? I didn't s..."
Dialog21E::
	db "...You idiot!   "
	db "I told you this "
	db "would happen... "
	db "Eh?!  What?  I  "
	db "didn^t say any- "
	db "thing, really!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $21F, $220: "Hey buddy! It's serious! Yeah, really serious!! Yeah, it is! The Mo..."
Dialog21F::
	db "Hey buddy!  It^s"
	db "serious!  Yeah, "
	db "really serious!!"
	db "Yeah, it is!    "
	db "The Moblins came"
	db "to the village! "
	db "Yeah, that^s    "
	db "right!  A whole "
	db "gang of Moblins!"
	db "Then... It^s for"
	db "real!  They all "
	db "went to the     "
	db "house...  Yeah, "
	db "that house, and "
	db "then they did   "
	db "something at Bow"
	db "Wow^s house!!   "
	db "It was a really "
	db "bad scene, with "
	db "the M-m-moblins!"
	db "So, I mean, ahh!"
	db "... ... ... ... "
	db "... ... ... ... "
	db "It might be     "
	db "faster to find  "
	db "out for yourself"
	db "what happened!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $221: "I found a good item washed up on the beach... I'll trade it to you ..."
Dialog221::
	db "I found a good  "
	db "item washed up  "
	db "on the beach... "
	db "I^ll trade it to"
	db "you for what you"
	db "have in your B  "
	db "Button...       "
	db "    Okay No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $222: "Okay, let's do it! When you don't want the Boomerang any more, come..."
Dialog222::
	db "Okay, let^s do  "
	db "it!  When you   "
	db "don^t want the  "
	db "Boomerang any   "
	db "more, come back!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $223: "Oh, yeah, uh... okay, whatever."
Dialog223::
	db "Oh, yeah, uh... "
	db "okay, whatever."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $224: "You got the Boomerang in exchange for the item you had."
Dialog224::
	db "You got the     "
	db "Boomerang in    "
	db "exchange for the"
	db "item you had."
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $225: "Give me back the Boomerang, I beg you! I'll return the item you gav..."
Dialog225::
	db "Give me back the"
	db "Boomerang, I beg"
	db "you! I^ll return"
	db "the item you    "
	db "gave to me!     "
	db "    Okay Not Now"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $226: "The item came back to you. You returned the Boomerang."
Dialog226::
	db "The item came   "
	db "back to you. You"
	db "returned the    "
	db "Boomerang."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $227: "Ah... Don't give me that item... How about some- thing else?"
Dialog227::
	db "Ah... Don^t give"
	db "me that item... "
	db "How about some- "
	db "thing else?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $228, $229, $22A, $22B, $22C, $22D, $22E, $22F, $230: "Hunh? A keyhole here? It says, 'Tale Keyhole'"
Dialog228::
	db "Hunh?  A keyhole"
	db "here?  It says, "
	db "^Tale Keyhole^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $231: "Hunh? A keyhole here? It says, 'Slime Keyhole'"
Dialog231::
	db "Hunh?  A keyhole"
	db "here?  It says, "
	db "^Slime Keyhole^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $232: "Hunh? A keyhole here? It says, 'Angler Keyhole'"
Dialog232::
	db "Hunh?  A keyhole"
	db "here?  It says, "
	db "^Angler Keyhole^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $233: "Hunh? A keyhole here? It says, 'Bird Keyhole'"
Dialog233::
	db "Hunh?  A keyhole"
	db "here?  It says, "
	db "^Bird Keyhole^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $234: "Hunh? A keyhole here? It says, 'Face Keyhole'"
Dialog234::
	db "Hunh?  A keyhole"
	db "here?  It says, "
	db "^Face Keyhole^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $235: "Somebody, HELP!" (B does not hurry it)
Dialog235::
	db "Somebody, HELP!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $236: "Hey! [NAME]! Some monsters put me up here! What should I do?! I'm a..." (B does not hurry it)
Dialog236::
	db "Hey!  #####!    "
	db "Some monsters   "
	db "put me up here! "
	db "What should I   "
	db "do?!  I^m afraid"
	db "of heights!!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $237: "Yow! That was a surprise! [NAME], thank you!" (B does not hurry it)
Dialog237::
	db "Yow!  That was a"
	db "surprise! #####,"
	db "thank you!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $238: "... ... ... ... ... ... ... ... Say... [NAME]..." (B does not hurry it)
Dialog238::
	db "... ... ... ... "
	db "... ... ... ... "
	db "Say... #####... "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $239: "Uhh... I don't know how to say this... but..." (B does not hurry it)
Dialog239::
	db "Uhh... I don^t  "
	db "know how to say "
	db "this... but..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $23A: "Hunh?! Tarin??! ... ... ... ... Uh... Nevermind, I... I gotta go!" (B does not hurry it)
Dialog23A::
	db "Hunh?!  Tarin??!"
	db "... ... ... ... "
	db "Uh... Nevermind,"
	db "I... I gotta go!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $23B: "MAAAAAAARINNNN!!" (B does not hurry it)
Dialog23B::
	db "MAAAAAAARINNNN!!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialogs $23C, $23D, $23E, $23F, $240: "'BRRING! BRRING! This is Ulrira! Oh, I heard from grandma that ther..."
Dialog23C::
	db "^BRRING! BRRING!"
	db "This is Ulrira! "
	db "Oh, I heard from"
	db "grandma that    "
	db "there is some-  "
	db "thing hidden    "
	db "behind the falls"
	db "in the Tal Tal  "
	db "Mountains.  Does"
	db "that help?  Bye!"
	db "CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $241: "'BRRING! BRRING! Ulrira here... Yes, when I was just a lad, I recal..."
Dialog241::
	db "^BRRING! BRRING!"
	db "Ulrira here...  "
	db "Yes, when I was "
	db "just a lad, I   "
	db "recall seeing a "
	db "high tower in   "
	db "the mountains!  "
	db "You should go   "
	db "there!  Is that "
	db "helpful for you?"
	db "Bye! CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $242: "'BRRING! BRRING! Hello, this is Ulrira speaking! [NAME], it's time ..."
Dialog242::
	db "^BRRING! BRRING!"
	db "Hello, this is  "
	db "Ulrira speaking!"
	db "#####, it^s time"
	db "for you to face "
	db "the Egg on Mt.  "
	db "Tamaranch!  Be  "
	db "careful, #####! "
	db "Bye!  CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $243: "'BRRING! BRRING! This is Ulrira! You're lost in the Egg? Hmmmm. No ..."
Dialog243::
	db "^BRRING! BRRING!"
	db "This is Ulrira! "
	db "You^re lost in  "
	db "the Egg?  Hmmmm."
	db "No sir, I can^t "
	db "help you on that"
	db "one.  How about "
	db "the library?    "
	db "And hey, don^t  "
	db "stop calling me "
	db "because I didn^t"
	db "know one little "
	db "answer!  CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $244: "'BRRING! BRRING! Ulrira at your service! Oh? You should take BowWow..."
Dialog244::
	db "^BRRING! BRRING!"
	db "Ulrira at your  "
	db "service!  Oh?   "
	db "You should take "
	db "BowWow home now,"
	db "Madam MeowMeow  "
	db "would appreciate"
	db "it! Bye! CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $245: "'BRRING! BRRING! Yeah, this is Ulrira! You are starting to like to ..."
Dialog245::
	db "^BRRING! BRRING!"
	db "Yeah, this is   "
	db "Ulrira!  You are"
	db "starting to like"
	db "to music, eh?   "
	db "Well, a frog    "
	db "named Mamu, who "
	db "lives in the    "
	db "Signpost Maze,  "
	db "might know some "
	db "new songs, but  "
	db "he charges a lot"
	db "to play them!   "
	db "Bye!  CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $246: "'BRRING! BRRING! Hi, it's Ulrira! You are doing great! Your efforts..."
Dialog246::
	db "^BRRING! BRRING!"
	db "Hi, it^s Ulrira!"
	db "You are doing   "
	db "great!  Your    "
	db "efforts will end"
	db "soon... By the  "
	db "way, have you   "
	db "visited the Hen "
	db "House on the    "
	db "mountain?  There"
	db "is a cave nearby"
	db "with something  "
	db "important in it."
	db "Bye!  CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $247: "'BRRING! BRRING! Ulrira speaking! Are your enemies too strong for y..."
Dialog247::
	db "^BRRING! BRRING!"
	db "Ulrira speaking!"
	db "Are your enemies"
	db "too strong for  "
	db "you?  In that   "
	db "case, you better"
	db "collect all the "
	db "Seashells...Just"
	db "believe in your-"
	db "self and do your"
	db "best!  CLICK!^"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $248: "'BRRING! BRRING! Ulrira here! ... Go for it! You're almost there! I..."
Dialog248::
	db "^BRRING! BRRING!"
	db "Ulrira here! ..."
	db "Go for it!      "
	db "You^re almost   "
	db "there! I^m pull-"
	db "ing for you!    "
	db "Bye!  CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $249, $24A: "Yarna Desert? There's a way to get there to the south, but you migh..."
Dialog249::
	db "Yarna Desert?   "
	db "There^s a way to"
	db "get there to the"
	db "south, but you  "
	db "might not be    "
	db "able to get     "
	db "through if that "
	db "lazy walrus is  "
	db "in the way!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $24B: "Ahhh... Sigh... On such a nice day, we need a song from Marin!"
Dialog24B::
	db "Ahhh... Sigh... "
	db "On such a nice  "
	db "day, we need a  "
	db "song from Marin!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $24C: "Hey! Did ya know Animal Village and Mabe Village are sister cities?..."
Dialog24C::
	db "Hey! Did ya know"
	db "Animal Village  "
	db "and Mabe Village"
	db "are sister      "
	db "cities?  Yes,   "
	db "even though they"
	db "aren^t large    "
	db "enough to be    "
	db "called cities..."
	db "Anyway, I heard "
	db "from a very good"
	db "source that they"
	db "have a Dream    "
	db "Shrine in Mabe, "
	db "and that it has "
	db "something good  "
	db "inside...  Is   "
	db "that true?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $24D: "Lately there have been a lot of monsters in the area, so we can't g..."
Dialog24D::
	db "Lately there    "
	db "have been a lot "
	db "of monsters in  "
	db "the area, so we "
	db "can^t go to Mabe"
	db "Village...  I   "
	db "wonder how Marin"
	db "is doing?"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $24E: "Have you heard of the Flying Rooster? They say it lived in Mabe Vil..."
Dialog24E::
	db "Have you heard  "
	db "of the Flying   "
	db "Rooster?  They  "
	db "say it lived in "
	db "Mabe Village a  "
	db "long time ago..."
	db "I wonder if it^s"
	db "true..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $24F: "Aaaah, Little Marin... I want her to come back again...Her song is ..."
Dialog24F::
	db "Aaaah, Little   "
	db "Marin... I want "
	db "her to come back"
	db "again...Her song"
	db "is the best..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $250: "I dreamed that I turned into a carrot last night... What an odd dre..."
Dialog250::
	db "I dreamed that  "
	db "I turned into a "
	db "carrot last     "
	db "night...  What  "
	db "an odd dream..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $251: "Eh? How can an animal talk? How? Hey, I'm just a rabbit, so I don't..."
Dialog251::
	db "Eh?  How can an "
	db "animal talk?    "
	db "How?  Hey, I^m  "
	db "just a rabbit,  "
	db "so I don^t know!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $252: "Ahhh! It's her! Little Marin!!"
Dialog252::
	db "Ahhh!  It^s her!"
	db "Little Marin!!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $253, $254, $255, $256, $257, $258, $259, $25A, $25B, $25C, $25D, $25E, $25F, $260, $261, $262, $263, $264, $265, $266, $267, $268, $269, $26A, $26B, $26C, $26D, $26E, $26F, $270, $271, $272, $273, $274, $275: ""
Dialog253::
	db $ff  ; end
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
