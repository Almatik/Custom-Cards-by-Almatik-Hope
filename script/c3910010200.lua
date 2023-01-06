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
	local decknum=Duel.GetRandomNumber(1,#s.Pack[2][1][i][0])
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
s.Pack[2][1][1][1]={2204140,4861205,19613556,5318639,23205979,22589918,26495087,37576645,44436472,24530661,31036355,42703248,45986603,53582587,53839837,55144522,57281778,60082869,57953380,63012333,71044499,70821187,71200730,77044671,77414722,89111398,94192409}
s.Pack[2][1][1][2]={}
s.Pack[2][1][1][3]={}
s.Pack[2][1][1][4]={22056710}
s.Pack[2][1][1][5]={}
s.Pack[2][1][1][10]=40
