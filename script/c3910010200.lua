--Random Deck - TCG
local s,id=GetID()
function s.initial_effect(c)
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	Xyz.AddProcedure(c,nil,4,2)
	Pendulum.AddProcedure(c,false)
	--skill
	local e1=Effect.CreateEffect(c) 
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0x5f)
	e1:SetCost(s.cost)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	aux.GlobalCheck(s,function()
		s[0]=0
		s[1]=0
		s[2]=0
		s[3]=0
	end)
end
function s.cost(e,tp)
	Duel.SendtoDeck(e:GetHandler(),tp,-2,REASON_RULE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	--Delete Your Cards
	s.DeleteDeck(tp)

	if s[tp]==0 then
		--Choose Game Mode
		local Option1={}
		table.insert(Option1,aux.Stringid(id,1)) --Choose Structure Deck
		table.insert(Option1,aux.Stringid(id,2)) --Random Structure Deck
		table.insert(Option1,aux.Stringid(id,3)) --Choose 1 of 3 Random Deck
		table.insert(Option1,aux.Stringid(id,4)) --Choose 2 of 3 Random Deck
		local gamemod=Duel.SelectOption(tp,false,table.unpack(Option1))+1
		for tp=0,1 do s[tp]=gamemod end
	end
	--If Special then Special Mode
	if s[tp]==1 then s.ChooseDeck(e,tp) return end
	if s[tp]==2 then s.RandomDeck(e,tp) return end
	if s[tp]==3 then s.Choose1Random3(e,tp) return end
	if s[tp]==4 then s.Choose2Random3(e,tp) return end
end
function s.DeleteDeck(tp)
	local del=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.SendtoDeck(del,tp,-2,REASON_RULE)
end
function s.PlaceDeck(tp,deckid)
	Duel.Hint(HINT_SKILL,tp,deckid)
end
function s.ChooseDeck(e,tp)
	--Collect All Decks/Packs
	local decklist={}
	for i=1,#s.Pack[2][1] do
		table.insert(decklist,s.Pack[2][1][i][0])
	end
	--Chose a Deck/Pack
	local deckid=Duel.SelectCardsFromCodes(tp,1,1,false,false,table.unpack(decklist))
	s.PlaceDeck(tp,deckid)
	if deckid~=nil then
		local decknum=deckid-id
		local common=s.Pack[2][1][decknum][1]
		local rare=s.Pack[2][1][decknum][2]
		local srare=s.Pack[2][1][decknum][3]
		local urare=s.Pack[2][1][decknum][4]
		if rare~=0 then for _,v in ipairs(rare) do table.insert(common,v) end end
		if srare~=0 then for _,v in ipairs(srare) do table.insert(common,v) end end
		if urare~=0 then for _,v in ipairs(urare) do table.insert(common,v) end end
		for code,code2 in ipairs(common) do
			local tc=Duel.CreateToken(tp,code2)
			Duel.SendtoDeck(tc,tp,1,REASON_RULE)
		end
		local dg=Duel.GetFieldGroup(tp,LOCATION_DECK+LOCATION_EXTRA,0)
		Duel.ConfirmCards(tp,dg)
	end
end
function s.RandomDeck(e,tp)
	--Get Random Deck
	local decknum=Duel.GetRandomNumber(1,#s.Pack[2][1])
	local deckid=s.Pack[2][1][decknum][0]
	s.PlaceDeck(tp,deckid)
	--Add Random Deck
	local common=s.Pack[2][1][decknum][1]
	local rare=s.Pack[2][1][decknum][2]
	local srare=s.Pack[2][1][decknum][3]
	local urare=s.Pack[2][1][decknum][4]
	if rare~=0 then for _,v in ipairs(rare) do table.insert(common,v) end end
	if srare~=0 then for _,v in ipairs(srare) do table.insert(common,v) end end
	if urare~=0 then for _,v in ipairs(urare) do table.insert(common,v) end end
	for code,code2 in ipairs(common) do
		--Debug.AddCard(code2,tp,tp,LOCATION_DECK,1,POS_FACEDOWN):Cover(deckid)
		local tc=Duel.CreateToken(tp,code2)
		--tc:Cover(deckid)
		Duel.SendtoDeck(tc,tp,1,REASON_RULE)
	end
	--Debug.ReloadFieldEnd()
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.ConfirmCards(tp,g)
	Duel.ShuffleDeck(tp)
end
function s.Choose1Random3(e,tp)
	--Get Random Deck
	local num
	local decklist={}
	for i=1,3 do
		num=Duel.GetRandomNumber(1,#s.Pack[2][1])
		table.insert(decklist,s.Pack[2][1][num][0])
	end

	local deckid=Duel.SelectCardsFromCodes(tp,0,1,false,false,table.unpack(decklist))
	s.PlaceDeck(tp,deckid)
	if deckid~=nil then
		local decknum=deckid-id
		local common=s.Pack[2][1][decknum][1]
		local rare=s.Pack[2][1][decknum][2]
		local srare=s.Pack[2][1][decknum][3]
		local urare=s.Pack[2][1][decknum][4]
		if rare~=0 then for _,v in ipairs(rare) do table.insert(common,v) end end
		if srare~=0 then for _,v in ipairs(srare) do table.insert(common,v) end end
		if urare~=0 then for _,v in ipairs(urare) do table.insert(common,v) end end
		for code,code2 in ipairs(common) do
			local tc=Duel.CreateToken(tp,code2)
			Duel.SendtoDeck(tc,tp,1,REASON_RULE)
		end
		local dg=Duel.GetFieldGroup(tp,LOCATION_DECK+LOCATION_EXTRA,0)
		Duel.ConfirmCards(tp,dg)
	end
end
function s.Choose2Random3(e,tp)
	--Get Random Deck
	local num
	local decklist={}
	for i=1,3 do
		num=Duel.GetRandomNumber(1,#s.Pack[2][1])
		table.insert(decklist,s.Pack[2][1][num][0])
	end


	local deckidlist={Duel.SelectCardsFromCodes(tp,2,2,false,false,table.unpack(decklist))}
	for i=1,2 do
		s.PlaceDeck(tp,deckidlist[i])
	end
end














s.Pack={}
s.Pack[2]={} --Rush Duel
s.Pack[2][1]={} --Structure Deck

--Structure Deck: Zombie Madness
s.Pack[2][1][1]={}
s.Pack[2][1][1][0]=id+1
s.Pack[2][1][1][1]={24530661,53839837,89111398,77044671,77044671,77044671,23205979,71200730,71200730,57281778,57281778,63012333,26495087,44436472,70821187,70821187,45986603,5318639,42703248,71044499,55144522,57953380,19613556,31036355,31036355,2204140,2204140,4861205,4861205,4861205,22589918,22589918,60082869,53582587,77414722,37576645,94192409,94192409,94192409}
s.Pack[2][1][1][2]={}
s.Pack[2][1][1][3]={}
s.Pack[2][1][1][4]={22056710}
s.Pack[2][1][1][5]={}
s.Pack[2][1][1][10]=40

--Structure Deck: Dragon's Roar
s.Pack[2][1][2]={}
s.Pack[2][1][2][0]=id+2
s.Pack[2][1][2][1]={74677422,11091375,11091375,43586926,980973,980973,46384672,46384672,36262024,30314994,39191307,39191307,39191307,45986603,5318639,71044499,71044499,70828912,72302403,55144522,19613556,81385346,81385346,81385346,31036355,31036355,22589918,22589918,88089103,97077563,36468556,92408984,54178050,54178050,37576645,36261276,36261276,19252988,66742250}
s.Pack[2][1][2][2]={}
s.Pack[2][1][2][3]={}
s.Pack[2][1][2][4]={96561011}
s.Pack[2][1][2][5]={}
s.Pack[2][1][2][10]=40

--Structure Deck: Fury from the Deep
s.Pack[2][1][3]={}
s.Pack[2][1][3][0]=id+3
s.Pack[2][1][3][1]={23771716,42071342,36119641,57839750,57839750,57839750,8201910,33184167,218704,218704,64342551,37721209,24435369,4929256,92084010,52571838,45986603,5318639,70828912,55144522,19613556,295517,295517,295517,31036355,22589918,22589918,96947648,96947648,26412047,51562916,60082869,97077563,85742772,85742772,18605135,53582587,38275183,76515293}
s.Pack[2][1][3][2]={}
s.Pack[2][1][3][3]={}
s.Pack[2][1][3][4]={10485110}
s.Pack[2][1][3][5]={}
s.Pack[2][1][3][10]=40

--Structure Deck: Blaze of Destruction
s.Pack[2][1][4]={}
s.Pack[2][1][4][0]=id+4
s.Pack[2][1][4][1]={11813953,5464695,60806437,60806437,60806437,68658728,74823665,74823665,4732017,45985838,45985838,67934141,67934141,90810762,26205777,51355346,88753985,45986603,5318639,19384334,19384334,71044499,70828912,55144522,79759861,19613556,85562745,22589918,3136426,3136426,48576971,33767325,60082869,60082869,97077563,83968380,38275183,82705573,82705573}
s.Pack[2][1][4][2]={}
s.Pack[2][1][4][3]={}
s.Pack[2][1][4][4]={19847532}
s.Pack[2][1][4][5]={}
s.Pack[2][1][4][10]=40

--Structure Deck: Warrior's Triumph
s.Pack[2][1][5]={}
s.Pack[2][1][5][0]=id+5
s.Pack[2][1][5][1]={5438492,11321183,78658564,423705,423705,16589042,52077741,10375182,2460565,2460565,74131780,7572887,22609617,47507260,74591968,4041838,57046845,84430950,31423101,45986603,5318639,42703248,55226821,19613556,32807846,32807846,95281259,37684215,68427465,20188127,22589918,22589918,69162969,12923641,75417459,97077563,77414722,51452091,98239899}
s.Pack[2][1][5][2]={}
s.Pack[2][1][5][3]={}
s.Pack[2][1][5][4]={69933858}
s.Pack[2][1][5][5]={}
s.Pack[2][1][5][10]=40

--Structure Deck: Spellcaster's Judgment
s.Pack[2][1][6]={}
s.Pack[2][1][6][0]=id+6
s.Pack[2][1][6][1]={55424270,46986414,69140098,31560081,31560081,73752131,73752131,9156135,9156135,72630549,71413901,70791313,34853266,9596126,81383947,21051146,46128076,6337436,91819979,5318639,71044499,70828912,72302403,83746708,19613556,87880531,22589918,2314238,51481927,69162969,28553439,28553439,25774450,58775978,97077563,38275183,34029630,49010598,62279055}
s.Pack[2][1][6][2]={}
s.Pack[2][1][6][3]={}
s.Pack[2][1][6][4]={29436665}
s.Pack[2][1][6][5]={}
s.Pack[2][1][6][10]=40

--Structure Deck: Invincible Fortress
s.Pack[2][1][7]={}
s.Pack[2][1][7][0]=id+7
s.Pack[2][1][7][1]={92736188,97017120,97017120,97017120,40695128,40659562,47606319,47606319,31812496,52323207,82260502,18654201,45159319,45159319,71544954,75209824,2694423,73648243,28120197,5318639,70828912,72302403,52097679,52097679,85852291,26412047,97342942,87910978,59237154,12607053,80604092,59344077,59344077,88279736,39537362,39537362,37576645,94192409,94192409}
s.Pack[2][1][7][2]={}
s.Pack[2][1][7][3]={}
s.Pack[2][1][7][4]={55737443}
s.Pack[2][1][7][5]={}
s.Pack[2][1][7][10]=40

--Structure Deck: Lord of the Storm
s.Pack[2][1][8]={}
s.Pack[2][1][8][0]=id+8
s.Pack[2][1][8][1]={40384720,84696266,34100324,78636495,84834865,84834865,12206212,12206212,28470714,45547649,73001017,82005435,28143906,91932350,27927359,54415063,81896370,6924874,72892473,5318639,71044499,90219263,90219263,19613556,22589918,75782277,75782277,12181376,69162969,77778835,95132338,60082869,97077563,77414722,1804528,37576645,56120475,70861343,53567095}
s.Pack[2][1][8][2]={}
s.Pack[2][1][8][3]={}
s.Pack[2][1][8][4]={14989021}
s.Pack[2][1][8][5]={}
s.Pack[2][1][8][10]=40

--Structure Deck: Dinosaur's Rage
s.Pack[2][1][9]={}
s.Pack[2][1][9][0]=id+9
s.Pack[2][1][9][1]={51934376,37265642,79870141,45894482,45894482,65287621,2671330,2671330,38670435,83235263,22587018,22587018,58071123,90654356,79409334,15894048,63259351,36042004,84808313,83682725,10080320,22537443,34016756,48642904,5318639,22046459,19613556,69162969,85852291,85852291,11925569,58419204,42175079,79569173,96008713,14315573,69632396,6137095,23869735}
s.Pack[2][1][9][2]={}
s.Pack[2][1][9][3]={}
s.Pack[2][1][9][4]={85520851}
s.Pack[2][1][9][5]={}
s.Pack[2][1][9][10]=40


--Structure Deck: Machine Re-Volt
s.Pack[2][1][10]={}
s.Pack[2][1][10][0]=id+10
s.Pack[2][1][10][1]={86321248,1953925,13316346,7359741,41172955,86445415,13839120,11384280,30190809,23265594,23265594,83104731,10509340,56094445,31557782,31557782,80045583,59811955,37457534,4446672,40830387,30435145,67829249,92001300,5318639,23171610,19613556,98045062,10035717,63995093,67169062,13955608,80604092,56120475,56120475,18190572,12503902,74458486,91597389}
s.Pack[2][1][10][2]={}
s.Pack[2][1][10][3]={}
s.Pack[2][1][10][4]={50933533}
s.Pack[2][1][10][5]={}
s.Pack[2][1][10][10]=40


--Rise of the Dragon Lords Structure Deck
s.Pack[2][1][11]={}
s.Pack[2][1][11][0]=id+11
s.Pack[2][1][11][1]={39343610,66337215,2732323,58551308,36354007,33508719,17444133,17444133,94568601,43586926,68007326,11224103,39191307,39191307,61505339,97093037,41089128,95701283,84290642,38120068,81439173,68005187,42703248,43434803,70828912,28596933,73628505,61127349,80161395,69162969,87910978,80921533,80921533,1224927,60082869,97077563,77414722,56120475,43250041}
s.Pack[2][1][11][2]={}
s.Pack[2][1][11][3]={}
s.Pack[2][1][11][4]={3954901}
s.Pack[2][1][11][5]={}
s.Pack[2][1][11][10]=40

--The Dark Emperor Structure Deck
s.Pack[2][1][12]={}
s.Pack[2][1][12][0]=id+12
s.Pack[2][1][12][1]={36733451,72237166,27408609,54493213,37043180,88240808,40133511,40133511,74131780,7572887,3773196,47829960,36584821,48092532,48092532,82112775,94853057,94853057,70074904,9622164,5318639,71044499,5758500,32807846,70231910,61127349,98045062,69162969,87910978,81674782,81674782,35011819,27174286,53582587,29401950,56120475,71587526,8628798,30241314}
s.Pack[2][1][12][2]={}
s.Pack[2][1][12][3]={}
s.Pack[2][1][12][4]={9748752}
s.Pack[2][1][12][5]={}
s.Pack[2][1][12][10]=40

--Zombie World Structure Deck
s.Pack[2][1][13]={}
s.Pack[2][1][13][0]=id+13
s.Pack[2][1][13][1]={31571902,68670547,77936940,19153634,16509093,77044671,77044671,24530661,23205979,21887179,57281778,70821187,70821187,2326738,87514539,55696885,17259470,17259470,4064256,93260132,60682203,98494543,57953380,31036355,2204140,4861205,73628505,67169062,55713623,7153114,81510157,37534148,72892473,30459350,60082869,29401950,3149764,12607053,96008713}
s.Pack[2][1][13][2]={}
s.Pack[2][1][13][3]={}
s.Pack[2][1][13][4]={5186893}
s.Pack[2][1][13][5]={}
s.Pack[2][1][13][10]=40

--Spellcaster's Command Structure Deck
s.Pack[2][1][14]={}
s.Pack[2][1][14][0]=id+14
s.Pack[2][1][14][1]={76137614,2525268,5640330,423585,45462639,73752131,9156135,9156135,45141844,8034697,71413901,7802006,70791313,21051146,55424270,47731128,82099401,6061630,39910367,75014062,36045450,47529357,99597615,42703248,66788016,72302403,83746708,73628505,98045062,14087893,91819979,28553439,45939841,7153114,50755,34029630,34029630,94256039,62279055}
s.Pack[2][1][14][2]={}
s.Pack[2][1][14][3]={}
s.Pack[2][1][14][4]={40732515}
s.Pack[2][1][14][5]={}
s.Pack[2][1][14][10]=40

--Warriors' Strike Structure Deck
s.Pack[2][1][15]={}
s.Pack[2][1][15][0]=id+15
s.Pack[2][1][15][1]={68366996,93187568,49681811,2460565,74131780,7572887,85087012,19041767,16984449,16984449,37043180,90642597,90642597,89529919,83269557,95750695,37520316,44947065,42534368,52105192,58775978,5318639,69954399,32807846,61127349,31423101,43422537,78794994,96765646,73567374,77538567,37390589,56120475,92924317,62271284,35539880,67045174}
s.Pack[2][1][15][2]={}
s.Pack[2][1][15][3]={96872283,32271987}
s.Pack[2][1][15][4]={69488544}
s.Pack[2][1][15][5]={}
s.Pack[2][1][15][10]=40

--Machina Mayhem Structure Deck
s.Pack[2][1][16]={}
s.Pack[2][1][16][0]=id+16
s.Pack[2][1][16][1]={4334811,22666164,60999392,23782705,96384007,58054262,79853073,26302522,23265594,23265594,70095154,26439287,41172955,86445415,13839120,67159705,67159705,3657444,34004470,31828916,43711255,72302403,55713623,46181000,63995093,12247206,74519184,48712195,86780027,80987696,70342110,68540059,12503902,36468556,94192409,91597389,91597389}
s.Pack[2][1][16][2]={}
s.Pack[2][1][16][3]={42940404,78349103}
s.Pack[2][1][16][4]={5556499}
s.Pack[2][1][16][5]={}
s.Pack[2][1][16][10]=40

--Structure Deck: Marik (TCG)
s.Pack[2][1][17]={}
s.Pack[2][1][17][0]=id+17
s.Pack[2][1][17][1]={38445524,83011278,56043447,99747800,90980792,4335645,24317029,24317029,50712728,37101832,37101832,63695531,62473983,99877698,25262697,25262697,99050989,52090844,17393207,3825890,30213599,5318639,58775978,31036355,14087893,85562745,47355498,47355498,81439173,98494543,1475311,41356845,44095762,98139712,65830223,54704216,26905245,1224927,5562461}
s.Pack[2][1][17][2]={}
s.Pack[2][1][17][3]={}
s.Pack[2][1][17][4]={102380,89194033,29762407}
s.Pack[2][1][17][5]={}
s.Pack[2][1][17][10]=40

--Dragunity Legion Structure Deck
s.Pack[2][1][18]={}
s.Pack[2][1][18][0]=id+18
s.Pack[2][1][18][1]={28183605,54578613,81962318,13361027,81661951,18060565,54455664,80549379,82199284,51962254,12800777,84834865,31553716,43586926,980973,46384672,39191307,39191307,62265044,99659159,56747793,83746708,55991637,81385346,31036355,74848038,81439173,72892473,59744639,37507488,30461781,52503575,44095762,54178050,29401950,79333300,53567095}
s.Pack[2][1][18][2]={}
s.Pack[2][1][18][3]={876330,36870345}
s.Pack[2][1][18][4]={63487632}
s.Pack[2][1][18][5]={}
s.Pack[2][1][18][10]=40

--Lost Sanctuary Structure Deck
s.Pack[2][1][19]={}
s.Pack[2][1][19][0]=id+19
s.Pack[2][1][19][1]={91345518,38730226,64734921,91123920,39552864,5645210,87148330,75162696,48964966,31305911,74968065,95956346,77527210,18036057,48783998,12171659,37742478,20450925,2980764,54977057,1353770,73628505,97169186,56433456,56433456,28890974,48976825,80921533,86780027,92223641,81066751,27174286,53582587,16255442,80551130,80551130,41420027}
s.Pack[2][1][19][2]={}
s.Pack[2][1][19][3]={91188343,28573958}
s.Pack[2][1][19][4]={55794644}
s.Pack[2][1][19][5]={}
s.Pack[2][1][19][10]=40

--Gates of the Underworld Structure Deck
s.Pack[2][1][20]={}
s.Pack[2][1][20][0]=id+20
s.Pack[2][1][20][1]={7459013,60606759,5498296,25847467,51232472,79126789,33731070,6214884,32619583,78004197,99458769,33655493,98777036,26202165,4335645,18590133,48343627,4694209,19665973,33017655,93554166,93431518,93431518,74117290,1475311,72892473,73628505,674561,69402394,29826127,35027493,54974237,15800838,65824822,46652477,31550470,77538567}
s.Pack[2][1][20][2]={}
s.Pack[2][1][20][3]={60228941,7623640}
s.Pack[2][1][20][4]={34230233}
s.Pack[2][1][20][5]={}
s.Pack[2][1][20][10]=40

--Dragons Collide Structure Deck
s.Pack[2][1][21]={}
s.Pack[2][1][21][0]=id+21
s.Pack[2][1][21][1]={89631139,74677422,79814787,36262024,84914462,54343893,21785144,12298909,65192027,88264978,9596126,17985575,83011278,423585,84290642,66337215,96235275,22624373,34627841,21502796,94243005,17655904,52684508,43973174,28596933,14087893,98494543,58577036,43040603,48712195,9622164,94886282,20638610,80163754,97077563,36261276,31550470}
s.Pack[2][1][21][2]={}
s.Pack[2][1][21][3]={51858306}
s.Pack[2][1][21][4]={99365553,25460258}
s.Pack[2][1][21][5]={}
s.Pack[2][1][21][10]=40

--Samurai Warlords Structure Deck
s.Pack[2][1][22]={}
s.Pack[2][1][22][0]=id+22
s.Pack[2][1][22][1]={44430454,83039729,69025477,95519486,31904181,64398890,90397998,27782503,63176202,99675356,38280762,65685470,90642597,52035300,78792195,49721904,75116619,33883834,98162021,61737116,98126725,53129443,403847,32807846,95281259,27178262,72345736,27970830,53819808,47436247,90846359,46874015,21007444,50078509,41458579,77847678,23212990,75525309}
s.Pack[2][1][22][2]={}
s.Pack[2][1][22][3]={2511717,54031490}
s.Pack[2][1][22][4]={1828513}
s.Pack[2][1][22][5]={}
s.Pack[2][1][22][10]=40

--Realm of the Sea Emperor Structure Deck
s.Pack[2][1][23]={}
s.Pack[2][1][23][0]=id+23
s.Pack[2][1][23][1]={706925,37104630,26976414,8078366,95231062,20470500,42463414,78868119,4252828,65496056,43797906,18318842,27655513,91133740,81306586,93920745,17559367,30276969,57839750,93830681,295517,295517,73628505,49669730,7653207,33057951,22123627,96947648,53129443,51562916,7935043,43889633,18605135,53582587,6540606,85742772,25642998}
s.Pack[2][1][23][2]={}
s.Pack[2][1][23][3]={74311226,73199638}
s.Pack[2][1][23][4]={47826112}
s.Pack[2][1][23][5]={}
s.Pack[2][1][23][10]=40

--Onslaught of the Fire Kings Structure Deck
s.Pack[2][1][24]={}
s.Pack[2][1][24][0]=id+24
s.Pack[2][1][24][1]={69000994,96594609,61441708,77121851,23116808,31303283,123709,23297235,28332833,91554542,54040221,76459806,66436257,4732017,13522325,90810762,88753985,66499018,68658728,60806437,60806437,74845897,69537999,61166988,98645731,74519184,31036355,44947065,82705573,60718396,63356631,21350571,98239899,42945701,79544790,54704216,97077563}
s.Pack[2][1][24][2]={}
s.Pack[2][1][24][3]={22993208,59388357}
s.Pack[2][1][24][4]={23015896}
s.Pack[2][1][24][5]={}
s.Pack[2][1][24][10]=40

--Saga of Blue-Eyes White Dragon Structure Deck
s.Pack[2][1][25]={}
s.Pack[2][1][25][0]=id+25
s.Pack[2][1][25][1]={95788410,43096270,11091375,21615956,14235211,57662975,52824910,77901552,15960641,20277376,79814787,34627841,66337215,17444133,37742478,95956346,95956346,87025064,17655904,81385346,28596933,38120068,39701395,18756904,2295440,83764719,72549351,68005187,72302403,98045062,13513663,50078509,37390589,28378427,97077563,94192409,82382815}
s.Pack[2][1][25][2]={}
s.Pack[2][1][25][3]={88241506,41620959}
s.Pack[2][1][25][4]={89631139,40908371}
s.Pack[2][1][25][5]={}
s.Pack[2][1][25][10]=40

--Cyber Dragon Revolution Structure Deck
s.Pack[2][1][26]={}
s.Pack[2][1][26][0]=id+26
s.Pack[2][1][26][1]={70095154,70095154,5373478,5373478,26439287,26439287,3657444,35050257,35050257,3370104,39439590,33093439,67159705,50400231,33911264,44364207,86170989,2851070,15717011,95956346,86686671,52875873,48130397,37630732,23171610,22046459,9622164,5318639,2362787,31828916,12670770,92773018,47594192,59616123,70342110,1224927,12607053,97077563}
s.Pack[2][1][26][2]={}
s.Pack[2][1][26][3]={23893227,59281922}
s.Pack[2][1][26][4]={74157028,58069384}
s.Pack[2][1][26][5]={}
s.Pack[2][1][26][10]=40

--Realm of Light Structure Deck
s.Pack[2][1][27]={}
s.Pack[2][1][27][0]=id+27
s.Pack[2][1][27][1]={43096270,57774843,21785144,94381039,96235275,96235275,22624373,22624373,59019082,58996430,44178886,95503687,95503687,7183277,2420921,21502796,21502796,37742478,30126992,38737148,74064212,47217354,82888408,14785765,4906301,36099620,36099620,691925,94886282,74848038,81439173,61962135,22201234,32233746,16255442,73729209,78474168}
s.Pack[2][1][27][2]={}
s.Pack[2][1][27][3]={40164421,77558536}
s.Pack[2][1][27][4]={52665542,4779823}
s.Pack[2][1][27][5]={}
s.Pack[2][1][27][10]=40

--Geargia Rampage Structure Deck
s.Pack[2][1][28]={}
s.Pack[2][1][28][0]=id+28
s.Pack[2][1][28][1]={71786742,71786742,1045143,1045143,47030842,73428497,923596,41172955,41172955,86445415,86445415,13839120,13839120,86321248,50933533,42851643,24419823,85087012,18964575,31768112,23265594,97017120,97017120,37694547,37694547,23171610,25518020,66788016,97169186,43422537,31036355,73628505,6148016,13955608,68540059,12503902,91597389,28912357}
s.Pack[2][1][28][2]={}
s.Pack[2][1][28][3]={45286019,72370114}
s.Pack[2][1][28][4]={47687766,19891310}
s.Pack[2][1][28][5]={}
s.Pack[2][1][28][10]=40

--HERO Strike Structure Deck
s.Pack[2][1][29]={}
s.Pack[2][1][29][0]=id+29
s.Pack[2][1][29][1]={37195861,75434695,9327502,98266377,21844576,89943723,69884162,59793705,89252153,86188410,79979666,80344569,37742478,85087012,57116033,423585,40410110,93600443,84536654,87819421,21143940,24094653,45906428,54283059,8949584,75141056,74825788,213326,37318031,63703130,32807846,95281259,98645731,22020907,37412656,97077563,29401950,94192409,78621186,3642509}
s.Pack[2][1][29][2]={}
s.Pack[2][1][29][3]={50720316,50608164,22093873,58481572}
s.Pack[2][1][29][4]={23204029}
s.Pack[2][1][29][5]={}
s.Pack[2][1][29][10]=40

--Synchron Extreme Structure Deck
s.Pack[2][1][30]={}
s.Pack[2][1][30][0]=id+30
s.Pack[2][1][30][1]={36736723,62125438,63977008,63977008,20932152,56286179,67270095,15310033,19642774,36643046,9365703,17932494,53855409,23571046,92676637,18964575,57421866,97268402,19182751,64034255,33420078,99234526,61901281,35014241,1003840,96363153,32807846,95281259,674561,2295440,89882100,75652080,48497555,98427577,92450185,97077563,30459350,84749824,60800381}
s.Pack[2][1][30][2]={}
s.Pack[2][1][30][3]={9742784,8529136,37675907}
s.Pack[2][1][30][4]={74892653,286392}
s.Pack[2][1][30][5]={}
s.Pack[2][1][30][10]=40

--Master of Pendulum Structure Deck
s.Pack[2][1][31]={}
s.Pack[2][1][31][0]=id+31
s.Pack[2][1][31][1]={15146890,51531505,40318957,94415058,20409757,16178681,26270847,44364077,91584698,89189982,97940434,51632798,22624373,97396380,62953041,60666820,40894584,25259669,90508760,36750412,58695102,27813661,53208660,69982329,74926274,45725480,79816536,5318639,73915051,96864811,24094653,73628505,76660409,84298614,29616929,53582587,54974237,1516510}
s.Pack[2][1][31][2]={}
s.Pack[2][1][31][3]={88935103,14920218,72714461}
s.Pack[2][1][31][4]={80696379,16691074}
s.Pack[2][1][31][5]={}
s.Pack[2][1][31][10]=40

--Emperor of Darkness Structure Deck
s.Pack[2][1][32]={}
s.Pack[2][1][32][0]=id+32
s.Pack[2][1][32][1]={9748752,51945556,60229110,4929256,26205777,73125233,58786132,22404675,95993388,24326617,59808784,22382087,35073065,98777036,15341821,41386308,57421866,19665973,2830693,84171830,19870120,61466310,79844764,5795980,33609262,68005187,98045062,3493058,54447022,54241725,8522996,18235309,26822796,48716527,35011819,44509898}
s.Pack[2][1][32][2]={}
s.Pack[2][1][32][3]={59463312,95457011,22842126}
s.Pack[2][1][32][4]={96570609,23064604}
s.Pack[2][1][32][5]={}
s.Pack[2][1][32][10]=40

--Rise of the True Dragons Structure Deck
s.Pack[2][1][33]={}
s.Pack[2][1][33][0]=id+33
s.Pack[2][1][33][1]={6075801,33460840,3954901,39343610,66337215,2732323,88264978,67300516,79473793,57662975,29330706,3536537,51858306,99234526,61901281,66752837,35629124,96235275,44178886,77558536,85087012,62265044,28596933,38120068,81439173,74519184,32807846,95281259,94886282,73628505,20638610,80163754,84968490,78474168,97077563,39122311}
s.Pack[2][1][33][2]={}
s.Pack[2][1][33][3]={87835759,69868555,6853254}
s.Pack[2][1][33][4]={33282498,60681103}
s.Pack[2][1][33][5]={}
s.Pack[2][1][33][10]=40

--Structure Deck: Yugi Muto
s.Pack[2][1][34]={}
s.Pack[2][1][34][0]=id+34
s.Pack[2][1][34][1]={78355370,75347539,99785935,39256679,11549357,46986414,38033121,78193831,90876561,25652259,64788463,77207191,5818798,52077741,13039848,40640057,73752131,46363422,43586926,4740489,41735184,2314238,99789342,25774450,72302403,93260132,24094653,95286165,12923641,83715234,77133792,50755,44095762,62279055,37383714,20781762,6150044,98502113,4796100,86240887}
s.Pack[2][1][34][2]={}
s.Pack[2][1][34][3]={42023223,79418928,15502037}
s.Pack[2][1][34][4]={42901635,4628897}
s.Pack[2][1][34][5]={}
s.Pack[2][1][34][10]=40

--Structure Deck: Seto Kaiba
s.Pack[2][1][35]={}
s.Pack[2][1][35][0]=id+35
s.Pack[2][1][35][1]={39890958,62651957,65622692,64500000,23265594,89631139,52824910,17985575,53839837,76909279,81985784,52624755,52624755,25206027,61802346,66752837,11091375,66399653,2783661,17655904,43973174,42534368,55713623,98045062,22046459,23171610,46181000,39778366,57728570,14315573,83555666,36261276,86871614,52503575,97077563,91597389,50078509,91998119,2111707,99724761}
s.Pack[2][1][35][2]={}
s.Pack[2][1][35][3]={30012506,77411244,3405259}
s.Pack[2][1][35][4]={65172015,1561110}
s.Pack[2][1][35][5]={}
s.Pack[2][1][35][10]=40

--Pendulum Domination Structure Deck
s.Pack[2][1][36]={}
s.Pack[2][1][36][0]=id+36
s.Pack[2][1][36][1]={19302550,46796664,47198668,39153655,12822541,48210156,74605254,11609969,74069667,44186624,81571633,17979378,65192027,14536035,28985331,94283662,16404809,13521194,50732780,45974017,46372010,73360025,10833828,81439173,2295440,1475311,674561,53046408,71069715,8643186,72648577,9765723,37209439,46259438,72497366,31550470,80036543,3758046}
s.Pack[2][1][36][2]={}
s.Pack[2][1][36][3]={72181263,19580308,44852429}
s.Pack[2][1][36][4]={83303851,8463720}
s.Pack[2][1][36][5]={}
s.Pack[2][1][36][10]=40

--Machine Reactor Structure Deck
s.Pack[2][1][37]={}
s.Pack[2][1][37][0]=id+37
s.Pack[2][1][37][1]={50933533,83104731,86321248,10509340,1953925,39303359,56094445,60953949,60953949,47687766,97526666,24419823,85087012,85087012,47606319,61156777,68473226,93187568,23434538,70147689,92001300,59811955,37694547,80921533,77584012,23171610,63995093,12247206,5133471,73628505,98954106,164710,70406920,50078509,97077563,99188141}
s.Pack[2][1][37][2]={}
s.Pack[2][1][37][3]={81269231,17663375,44052074}
s.Pack[2][1][37][4]={18486927,44874522}
s.Pack[2][1][37][5]={}
s.Pack[2][1][37][10]=40

--Dinosmasher's Fury Structure Deck
s.Pack[2][1][38]={}
s.Pack[2][1][38][0]=id+38
s.Pack[2][1][38][1]={81823360,81823360,37265642,37265642,85520851,15894048,6849042,41753322,83235263,50896944,63259351,45894482,36042004,38572779,4058065,99733359,12275533,89362180,7392745,85138716,47325505,84808313,43898403,48976825,12923641,1033312,911883,73628505,58272005,23869735,95676943,29843091,42956963,40838625,1637760,18252559}
s.Pack[2][1][38][2]={}
s.Pack[2][1][38][3]={44335251,17228908,44612603}
s.Pack[2][1][38][4]={82946847,18940556}
s.Pack[2][1][38][5]={}
s.Pack[2][1][38][10]=40

--Structure Deck: Cyberse Link
s.Pack[2][1][39]={}
s.Pack[2][1][39][0]=id+39
s.Pack[2][1][39][1]={32295838,18789533,45778242,71172240,8567955,44956694,70950698,36033786,63528891,9523599,35911108,98777036,423585,85087012,14943837,41386308,28637168,31560081,8487449,67441435,45452224,54447022,14816688,9622164,75500286,37520316,8267140,19508728,51405049,70238111,21636650,84298614,95083785,50277973,87772572,5650082,83326048,51099515}
s.Pack[2][1][39][2]={}
s.Pack[2][1][39][3]={7445307,43839002,79016563}
s.Pack[2][1][39][4]={6622715,32617464}
s.Pack[2][1][39][5]={}
s.Pack[2][1][39][10]=40

--Structure Deck: Wave of Light
s.Pack[2][1][40]={}
s.Pack[2][1][40][0]=id+40
s.Pack[2][1][40][1]={53666449,12510878,18036057,49905576,85399281,32296881,67468948,98301564,59509952,5645210,48964966,87148330,74968065,11662742,48783998,37742478,17266660,21074344,94689635,69865139,16638212,20450925,56433456,54977057,28890974,1353770,40450317,44595286,80551130,16946849,81066751,77538567,84749824,38891741,4440873,96404912}
s.Pack[2][1][40][2]={}
s.Pack[2][1][40][3]={89055154,15449853,42444868}
s.Pack[2][1][40][4]={40177746,16261341}
s.Pack[2][1][40][5]={}
s.Pack[2][1][40][10]=40

--Structure Deck: Lair of Darkness
s.Pack[2][1][41]={}
s.Pack[2][1][41][0]=id+41
s.Pack[2][1][41][1]={12766474,29424328,55818463,82213171,28423537,87288189,12338068,47084486,28601770,47754278,92039899,13521194,30312361,55696885,81035362,16404809,10802915,60990740,50185950,81191584,1475311,74519184,35726888,96704974,46173679,90434926,57728570,35027493,54974237,4931121,29876529,79766336,15800838,19254117,84970821,72497366}
s.Pack[2][1][41][2]={}
s.Pack[2][1][41][3]={86377375,59160188,85555787}
s.Pack[2][1][41][4]={23898021,50383626}
s.Pack[2][1][41][5]={}
s.Pack[2][1][41][10]=40

--Structure Deck: Powercode Link
s.Pack[2][1][42]={}
s.Pack[2][1][42][0]=id+42
s.Pack[2][1][42][1]={84816244,11801343,43583400,89571015,645087,59546797,67922702,10028593,10028593,67750322,25259669,12958919,64034255,97268402,32362575,27450400,35911108,42461852,89882100,19230408,25789292,73915051,72302403,58577036,46173679,2295440,73628505,78859567,47766694,29616929,75249652,59616123,38296564,97077563,37576645,65703851,41248270,77637979}
s.Pack[2][1][42][2]={}
s.Pack[2][1][42][3]={53309998,80794697,16188701}
s.Pack[2][1][42][4]={15066114,15844566}
s.Pack[2][1][42][5]={}
s.Pack[2][1][42][10]=40

--Structure Deck: Zombie Horde
s.Pack[2][1][43]={}
s.Pack[2][1][43][0]=id+43
s.Pack[2][1][43][1]={52512994,5186893,31571902,7845138,68670547,32485518,17259470,96163807,92826944,52467217,65422840,77044671,63665875,22657402,94801854,49959355,87514539,83903521,67284107,38363525,65357623,4064256,60577362,2204140,4861205,81439173,43040603,16435215,48976825,1372887,91742238,39033131,80955168,84968490,89208725,58921041,29549364}
s.Pack[2][1][43][2]={}
s.Pack[2][1][43][3]={3096468,66570171,92964816}
s.Pack[2][1][43][4]={39185163,28240337}
s.Pack[2][1][43][5]={}
s.Pack[2][1][43][10]=40

--Structure Deck: Soulburner
s.Pack[2][1][44]={}
s.Pack[2][1][44][0]=id+44
s.Pack[2][1][44][1]={53490455,89484053,89662401,25166510,67225377,94620082,20618081,56003780,13173832,59577547,86962245,96746083,93332803,23297235,97396380,74823665,14558127,40975574,33365932,33365932,50366775,88540324,1295111,64178424,74848038,59388357,5288597,51335426,1073952,14934922,20788863,46652477,36361633,56526564,82705573,53334471,41463181,49847524,37880706}
s.Pack[2][1][44][2]={}
s.Pack[2][1][44][3]={26889158,52277807,52155219,51339637}
s.Pack[2][1][44][4]={41463181,87327776,14812471}
s.Pack[2][1][44][5]={}
s.Pack[2][1][44][10]=40

--Structure Deck: Order of the Spellcasters
s.Pack[2][1][45]={}
s.Pack[2][1][45][0]=id+45
s.Pack[2][1][45][1]={66104644,92559258,40732515,73853830,2525268,55424270,54965929,43930492,6061630,10239627,76137614,9156135,40737112,86937530,423585,14824019,30608985,31560081,94145021,65342096,39910367,75014062,75014062,17896384,89739383,25123082,88616795,91819979,28553439,73628505,86541496,35261759,24429467,34029630,94937430,18446701,50755}
s.Pack[2][1][45][2]={}
s.Pack[2][1][45][3]={39000945,38943357,24721709}
s.Pack[2][1][45][4]={3611830,91336701}
s.Pack[2][1][45][5]={}
s.Pack[2][1][45][10]=40

--Structure Deck: Rokket Revolt
s.Pack[2][1][46]={}
s.Pack[2][1][46][0]=id+46
s.Pack[2][1][46][1]={5969957,31353051,94136469,53266486,80250185,26655293,5087128,32472237,48355999,91482773,58582979,84976088,62514770,6075801,87835759,66752837,84899094,77558536,30131474,67526112,54458867,31443476,36668118,6556178,41620959,69868555,6853254,24094653,43898403,20419926,23002292,55034079,29649320,44095762,62279055,61740673,31833038,49725936,12023931}
s.Pack[2][1][46][2]={}
s.Pack[2][1][46][3]={32476603,68464358,67748760,93014827}
s.Pack[2][1][46][4]={66403530,92892239,29296344}
s.Pack[2][1][46][5]={}
s.Pack[2][1][46][10]=40

--Structure Deck: Shaddoll Showdown
s.Pack[2][1][47]={}
s.Pack[2][1][47][0]=id+47
s.Pack[2][1][47][1]={37445295,4939890,30328508,77723643,3717252,52551211,58016954,95401059,72989439,102380,65192027,42921475,67696066,28985331,73176465,34710660,41386308,16404809,69764158,81788994,6417578,60226558,48130397,1845204,1475311,81439173,34959756,67169062,43898403,4904633,77505534,78942513,74003290,69452756,81223446,73575650,74009824,19261966,86938484}
s.Pack[2][1][47][2]={}
s.Pack[2][1][47][3]={24635329,51023024,97518132,23912837,94977269,74822425,44394295}
s.Pack[2][1][47][4]={48424886,50907446,20366274}
s.Pack[2][1][47][5]={}
s.Pack[2][1][47][10]=40

--Structure Deck: Mechanized Madness
s.Pack[2][1][48]={}
s.Pack[2][1][48][0]=id+48
s.Pack[2][1][48][1]={50863093,5556499,42940404,78349103,58054262,51617185,39284521,60999392,23782705,96384007,22666164,63941210,24731453,64034255,4334811,79538761,60071928,44935634,94693857,75944053,13247801,31828916,64662453,34559295,80352158,23171610,40450317,67169062,8267140,17626381,59741415,63477921,59919307,80101899,20374520,40605147}
s.Pack[2][1][48][2]={}
s.Pack[2][1][48][3]={23469398,86852702,12524259}
s.Pack[2][1][48][4]={87074380,85136114}
s.Pack[2][1][48][5]={}
s.Pack[2][1][48][10]=40

--Structure Deck: Sacred Beasts
s.Pack[2][1][49]={}
s.Pack[2][1][49][0]=id+49
s.Pack[2][1][49][1]={54040484,81034083,27439792,87917187,30312361,12958919,31034919,48343627,79407975,98777036,28674152,97940434,41442341,13521194,36553319,82888408,16209941,80312545,13301895,93224848,74402414,73628505,73468603,269012,2295440,73680966,35261759,9720537,7153114,12923641,5318639,53701259,31550470,92099232,9995766,59305593,9064354,95463814}
s.Pack[2][1][49][2]={}
s.Pack[2][1][49][3]={54828837,16317140,89190953}
s.Pack[2][1][49][4]={28651380,6007213,32491822,69890967,43378048}
s.Pack[2][1][49][5]={}
s.Pack[2][1][49][10]=40

--Structure Deck: Spirit Charmers
s.Pack[2][1][50]={}
s.Pack[2][1][50][0]=id+50
s.Pack[2][1][50][1]={37970940,74364659,759393,37744402,60666820,40894584,62953041,44680819,42921475,52022648,86937530,71074418,62312469,78010363,97268402,13974207,62256492,68462976,23314220,73628505,35480699,43898403,54693926,25704359,70156997,6540606,42945701,79333300,89208725,83326048,84749824,31887905,68881649,4376658,31764353}
s.Pack[2][1][50][2]={}
s.Pack[2][1][50][3]={12580477,65046521}
s.Pack[2][1][50][4]={65268179,92652813,38057522,31887905,68881649,4376658,31764353,91530236}
s.Pack[2][1][50][5]={}
s.Pack[2][1][50][10]=40

--Structure Deck: Freezing Chains
s.Pack[2][1][51]={}
s.Pack[2][1][51][0]=id+51
s.Pack[2][1][51][1]={81825063,70703416,60161788,23950192,50088247,82498947,18482591,73061465,50032342,59546528,41090784,81275309,88494899,53921056,9056100,68505803,4904812,40916023,46239604,1357146,66853752,13959634,90303176,43582229,64990807,84206435,10691144,96947648,33057951,51405049,43262273,50078509,54059040,68937720,23924608,36975314,6075533}
s.Pack[2][1][51][2]={}
s.Pack[2][1][51][3]={50321796,65749035,52687916}
s.Pack[2][1][51][4]={18319762,44308317,43256007,17197110,70980824,70583986}
s.Pack[2][1][51][5]={}
s.Pack[2][1][51][10]=40

--Structure Deck: Cyber Strike
s.Pack[2][1][52]={}
s.Pack[2][1][52][0]=id+52
s.Pack[2][1][52][1]={79875526,70095154,5373478,59281922,29975188,1142880,23893227,29719112,3657444,3370104,41230939,77625948,3019642,45078193,82562802,70298454,63941210,71197066,16229315,32768230,86686671,60600126,55704856,80033124,44352516,77565204,59432181,63995093,23171610,1157683,18597560,76403456,97077563,98414735,82428674,64599569,18967507,40418351,37630732,3659803}
s.Pack[2][1][52][2]={}
s.Pack[2][1][52][3]={56364287,6498706,10045474}
s.Pack[2][1][52][4]={5370235,64753988,1546123,37542782,63031396}
s.Pack[2][1][52][5]={}
s.Pack[2][1][52][10]=40

--Structure Deck: Albaz Strike
s.Pack[2][1][53]={}
s.Pack[2][1][53][0]=id+53
s.Pack[2][1][53][1]={68468459,25451383,69680031,88264978,48770333,55878038,28674152,20292186,99234526,61901281,15381421,48048590,423585,59438930,97268402,8972398,18973184,34995106,62022479,33550694,22829942,74335036,75500286,49238328,24224830,54693926,67100549,93595154,81223446,59919307,11429811,24207889,83326048,10813327,41373230,34848821,1906812,87746184}
s.Pack[2][1][53][2]={}
s.Pack[2][1][53][3]={44362883,81767888,17751597}
s.Pack[2][1][53][4]={19096726,45484331,82489470,44146295,70534340}
s.Pack[2][1][53][5]={}
s.Pack[2][1][53][10]=40

--Structure Deck: Legend of the Crystal Beasts
s.Pack[2][1][54]={}
s.Pack[2][1][54][0]=id+54
s.Pack[2][1][54][1]={32710364,32933942,68215963,95600067,69937550,21698716,7093411,79407975,87475570,14469229,32491822,91800273,87170768,14558127,73642296,12877076,58371671,34487429,63945693,95326659,35486099,72881007,8275702,47408488,10004783,60876124,40854824,12644061,48800175,35726888,8267140,85766789,11155484,47149093,47121070,87259933,36328300,11136371,31044787,89208725}
s.Pack[2][1][54][2]={}
s.Pack[2][1][54][3]={37440988}
s.Pack[2][1][54][4]={79856792,10034401,36795102,10938846,9334391}
s.Pack[2][1][54][5]={}
s.Pack[2][1][54][10]=40

--Structure Deck: Dark World
s.Pack[2][1][55]={}
s.Pack[2][1][55][0]=id+55
s.Pack[2][1][55][1]={99458769,34968834,15667446,78004197,32619583,6214884,33731070,79126789,5498296,25847467,51232472,7623640,7459013,60606759,43316238,90807199,52350806,99745551,23898021,47217354,60990740,74117290,85325774,93431518,93554166,16435215,72892473,29826127,10131855,41930553,15800838,35027493,38761908,82732705,34230233,60228941,33017655}
s.Pack[2][1][55][2]={}
s.Pack[2][1][55][3]={77895328,3289027,3167439}
s.Pack[2][1][55][4]={41406613,30284022,76672730,39552584,65956182}
s.Pack[2][1][55][5]={}
s.Pack[2][1][55][10]=40

