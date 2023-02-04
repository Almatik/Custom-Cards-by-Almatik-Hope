--Blood-Caster Vladimir
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	c:RegisterEffect(e1)
end
s.listed_series={0x8e}
function s.costfilter(c,lp)
	return c:IsSetCard(0x8e) and c:IsAttackBelow(lp)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP()
	local t={}
	if chk==0 then return Duel.CheckLPCost(tp,100)
		and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil,lp) end
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_HAND,0,nil,lp)
	local tc=g:GetFirst()
	for tc in aix.Next(g) do
		table.insert(t,tc:GetAttack())
	end
	local cost=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,cost)
	e:SetLabel(cost)
end