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
end
function s.cost(e,tp)
	Duel.SendtoDeck(e:GetHandler(),tp,-2,REASON_RULE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	--Delete Your Cards
	s.DeleteDeck(tp)

	--Choose Game Mode
	local Option1={}
	table.insert(Option1,aux.Stringid(id,1)) --Choose Structure Deck
	table.insert(Option1,aux.Stringid(id,2)) --Random Structure Deck
	local gamemod=Duel.SelectOption(tp,false,table.unpack(Option1))+1

	--If Special then Special Mode
	if gamemod==1 then s.ChooseDeck(e,tp) return end
	if gamemod==2 then s.RandomDeck(e,tp) return end
end
function s.DeleteDeck(tp)
	local del=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.SendtoDeck(del,tp,-2,REASON_RULE)
end
function s.ChooseDeck(e,tp)
	--Collect All Decks/Packs
	local decklist={}
	for i=1,#s.Pack[2][1] do
		table.insert(decklist,s.Pack[2][1][i][0])
	end
	--Chose a Deck/Pack
	local deckid=Duel.SelectCardsFromCodes(tp,0,1,false,false,table.unpack(decklist))
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
