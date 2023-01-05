--Random Deck - Rush Duel
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
	local gamemod=Duel.SelectOption(tp,false,table.unpack(Option1))+1

	--If Special then Special Mode
	if gamemod==1 then s.ChooseDeck(e,tp) return end
end
function s.DeleteDeck(tp)
	local del=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0)
	Duel.SendtoDeck(del,tp,-2,REASON_RULE)
end
function s.ChooseDeck(e,tp)
	--Collect All Decks/Packs
	local decklist={}
	for i=1,#s.Pack[5][1] do
		table.insert(decklist,s.Pack[5][1][i][0])
	end
	--Chose a Deck/Pack
	local deckid=Duel.SelectCardsFromCodes(tp,0,1,false,false,table.unpack(decklist))
	if deckid~=nil then
		local deck=deckid-id
		for code,code2 in ipairs(s.Pack[5][1][deck][1]) do
			local tc=Duel.CreateToken(tp,code2)
			Duel.SendtoDeck(tc,tp,1,REASON_RULE)
		end
		local dg=Duel.GetFieldGroup(tp,LOCATION_DECK+LOCATION_EXTRA,0)
		Duel.ConfirmCards(tp,dg)
	end
end

s.Pack[5]={} --Rush Duel
s.Pack[5][1]={} --Structure Deck

--Yuga - Hyper Machine Road
s.Pack[5][1][1]={}
s.Pack[5][1][1][0]=id+1
s.Pack[5][1][1][1]={160202002,160202001,160202003,160002018,160004015,160001022,160402006,160402005,160303009,160303010,160001033,160001033,160406003,160303013,160406002,160003009,160003015,160003015,160001032,160001032,160001019,160001019,160303019,160001010,160001010,160301007,160301007,160301010,160301010,160301010,160001037,160004039,160202024,160003042,160001038,160402001,160402003,160002046,160002048,160303032}
s.Pack[5][1][1][2]={}
s.Pack[5][1][1][3]={}
s.Pack[5][1][1][4]={}
s.Pack[5][1][1][5]={}
s.Pack[5][1][1][10]=40


