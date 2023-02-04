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
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
s.listed_series={0x8e}
function s.costfilter(c,e,tp,lp)
	return c:IsSetCard(0x8e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsAttackBelow(lp)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)
	local t={}
	if chk==0 then return Duel.CheckLPCost(tp,100)
		and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil,e,tp,lp) end
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_HAND,0,nil,e,tp,lp)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		table.insert(t,tc:GetAttack())
	end
	local cost=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,cost)
	e:SetLabel(cost)
end
function s.spfilter(c,e,tp,val)
	return c:IsSetCard(0x8e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:GetAttack()==val
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local val=e:GetLabel()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,e,tp,val) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local val=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,val)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end