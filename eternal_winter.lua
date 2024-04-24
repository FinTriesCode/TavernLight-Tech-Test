--set up local arrays
local combats = {}
local areas = {

	--areas created here instead of inside 'spells.lua' for marking readability

	--area 1
	{
	{0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 1, 1, 0, 1, 1, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0},
	{1, 1, 1, 1, 2, 1, 1, 1, 1},
	{0, 0, 0, 0, 0, 0, 0, 0, 0},
	{0, 0, 1, 1, 0, 1, 1, 0, 0},
	{0, 0, 0, 0, 0, 0, 0, 0, 0}
	},

	--area 2
	{
	{0, 0, 0, 0, 1, 0, 0, 0, 0},
	{0, 0, 0, 0, 1, 0, 0, 0, 0},
	{0, 0, 0, 0, 1, 0, 0, 0, 0},
	{1, 1, 1, 0, 0, 0, 1, 1, 1},
	{0, 0, 0, 0, 2, 0, 0, 0, 0},
	{1, 1, 1, 0, 0, 0, 1, 1, 1},
	{0, 0, 0, 0, 1, 0, 0, 0, 0},
	{0, 0, 0, 0, 1, 0, 0, 0, 0},
	{0, 0, 0, 0, 1, 0, 0, 0, 0}
	},
}

--loop used to set up both areas
for i = 1, #areas do
	combats[i] = Combat()
	combats[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
	combats[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)

	combats[i]:setArea(createCombatArea(areas[i]))

	--included funciton to calculate the level/magicLevel -min & -max
	function onGetFormulaValues(player, level, magicLevel)
		local min = (level / 5) + (magicLevel * 8) + 50
		local max = (level / 5) + (magicLevel * 12) + 75
		return -min, -max
	end

	--setup callbacks (in loop to set up both)
	combats[i]:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")
end

--function to cast the spell, altered to handle multiple areas/combats using the combatIndex
local function castSpell(creatureId, variant, combatIndex)
        combats[combatIndex]:execute(creature, variant) --execute the instance(s) of the combat(s)
end


function onCastSpell(creature, variant)
    for i = 2, #areas do
        addEvent(castSpell, 250 * i, creature.uid, variant, i)
    end
    return combats[1]:execute(creature, variant)
end
 
--this technique was used as it allowed me to make use of multiple attack areas. This approach had me 
--loop through x combats and y areas when setting up, ensuring all set up was applied ot both combats and 
--attack areas.
 