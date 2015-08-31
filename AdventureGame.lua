--An adventure game.
--Should have random encounters and rpg like combat


--there is a speed stat, but it only applies when attak or defending, items have top priority
	--the player seams to have priority when both characters have the same speed
--there should be some form of lock preventing menus from displaying to far to the right (and maybe left, but I doubt that will be a problem with it being easier to see that limit (1))
--menuOutput should probably be changed to local, instead of relaying on me resetting it everywhere

--'tab' acts as enter when not in inventory, not a big problem but it should be looked into

--When checking for menuOutput, instead use:
	--menuOutputNumerical + (cursorPosY - 2)
		--menuOutputNumerical should change name
	--all the menuOutput = 0's in the code should probably be removed. They remain there for the time being in case something goes wrong.
		
--the defense bonus should be partly reworked to allow for a number dependant on the players skill (maybe a block skill or the quality of the players shield)

--The reason that the inventory screen doesn't update the numbers on how many items you have left in a stack is since the menu it's calling doesn't get updated when another manu is updated, figure out a way to update that menu easily

--only the player is able to recieve a defensive bonus (defBonus), this could be solved by giving the function 2 values instead of one (playerDefBonus, enemyDefBonus)

--a gold stat should be added to allow the usage of gold and determin how much gold enemies drop
--an inventory stat should be created to allow for everything in the game to have an inventory. Should both be used for lootlists and allow for enemies to use items and have equipement.

--BUG: It's possible to equip a piece of equipement when another piece is already in place. "eating" the old equipement

--Kattegori (char):
--1. Player
--2. Mobs
--3. Bosses
--4. Inventory


--{"name", str, def, HP, MaxHP, Speed, LVL, EXP, gold, inv(0 for none, for now), run Chanse (%)}
--What inventory should what mob have, what should even the player have there? Should the players inventory be used or should the current solution continue to be used
--LVL could be used for determening how much EXP each enemy should drop
--gold is how much money the player have and how much money the enemies may drop
--inv is used to show what inventory every mob have. (maybe also for the player, but that's not in use ATM). The lists will show what equipement they have, what they will drop and some stronger monsters may use potions

inventoryTable = {
{{"Materials", "none", "iron", "stel", "gold"},				--materials list, keep these 4 long
{"Equipement", "Helmet", "ChestP", "Sword ", "Shield"}	--diferent types of equipement, keep these 6 long
}
}

char = {		--Evertything with stats in the game
{{"player", 5, 1, 5, 5, 3, 1, 0, 20, 1, 0}},		 --players
{{"a rabbit", 3, 1, 5, 5, 5, 1, 0, 5, 0, 50}, {"a carrot", 0, 0, 7, 7, 1, 1, 0, 1, 0, 75}},	--monster list 1										char[2][1] - char[2][2]
{{"an Elder Dragon", 10, 10, 20, 20, 6, 5, 0, 10, 0, 0}},	--boss list 1
{{"inventory", 5, 3, inventoryTable[1][1][3].." "..inventoryTable[1][2][2], inventoryTable[1][1][4].." "..inventoryTable[1][2][2]},		--"inventory", potions, carrots			char[4][1]
{}}																					--"all different types of equipement" 	char[4][2]
}

--BUG: displays the || on the second line to far to the left
menu = {	--all options MUST be the same length in characters (space counts), 	21 characters is the longest an option can be, and only if there is > 9 options. The menu need to start at 1 then
{"ATK ", "DEF ", "ITEM", "RUN "},										--Standard combat menu
{"Start", "Leave"},														--Start menu
{" potion x "..char[4][1][2], " carrot x "..char[4][1][3], char[4][1][4], char[4][1][5], " Leave INV "},				--inventory, the values on how many are left does not update when they change above. This should be fixed
{inventoryTable[1][2][2]..": "..inventoryTable[1][1][2], inventoryTable[1][2][3]..": "..inventoryTable[1][1][2], inventoryTable[1][2][4]..": "..inventoryTable[1][1][2], inventoryTable[1][2][5]..": "..inventoryTable[1][1][2]},												--Equiped equipement
{"Enemy", "Item ", "Leave", "Boss "}
}

--menu[3] = {" potion x "..char[4][1][2], " carrot x "..char[4][1][3], " Leave INV ", char[4][1][4]}


--print("What is your name?")
--char[1][1][1] = read()

--curChar, current enemy
--tabChar, which enemy table that the enemy should come from


--ASCIIchar(35, 0, 1, 1) to spawn the player at default position, this should probably be changed up to be a bit fancier instead of manual input


tabChar = 2
--curChar = math.floor((math.random() * 2) + 1)	--creates the first enemy
curChar = 1
--defBonus = 0
curItem = 1
playerPosX = 2
playerPosY = 2
playerRan = false	--if the player has ran from the battle or not. And it won't give EXP if the player ran

function keyInput()
    while true do
       sEvent, param = os.pullEvent("key")
        if sEvent == "key" then
            if param == 200 then	--up
                break
            end
			if param == 208 then	--down
                break
            end
			if param == 203 then	--left
                break
            end
			if param == 205 then	--right
                break
            end
			if param == 15 then		--tab
				break
			end
			if param == 57 then	--allows for space to be used in place of enter
				param = 28
				break
			end
				break
            end
        end	
end

function ASCIIchar(charX, charY, tabChar, curChar)
--Input:
	--charX
	--CharY	Where the character should appear
	--tabChar
	--curChar	Which character that should appear
	--enter x = 1 y = 0 for the character to spawn in the upper right corner
--text under it can begin at 12

ASCIIart = {
{
		{
		"   .-'~ -.      ",
		"  / '-    \\    ",
		" />  '.  -.|    ",
		"/_     '-.__)   ",
		" |-  _.' \\ |   ",
		"  '~~;     \\\\ ",
		"    /      \\\\)",
		"   '.___.-''    "
		}

}	--end of player
, {
	{
	" _                  ",
	"/ '.        .--.    ",
	"|   \\     .'-,  |  ",
	"\\    \\___/    \\_/",
	" '._.'   '._.'      ",
	"   /  . .  \\       ",
	"   |=  Y  =|        ",
	"   \\   ^   /       ",
	"    ''---''         "
	}, {
	"\\||/      ",
	" \\|       ",
	"  ==       ",
	" /  \\     ",
	"| O\\O\\   ",
	" \\  _ \\ ",
	"  \\_   \\",
	"    \\_  \\ ",
    "      \\__>  "
	--"       _____                    ",	--old carrot here until a resting place is found
	--"'-._\\ /     '~~''--.,_         ",
	--"------>|              '~~''--.,_",
	--"_.-'/ '.____,,,,----''''~~''''  "
	}
},{		--end of enemies
	{
	".-.        .-.     ",
	" \\_//|    /_(     ",
	" _/(o)/  .'_(      ",
	"/o_.-. \\/__(  .   ",
	"     \\-\\--'   |\\",
	"    3\\-3\\ \\   .|",
	"     /--\\  '.'/   ",
	"  __//_//__.-'     ",
	" '-'-'-'-'         "
	}
}, {	--end of "bosses", start of items: everything that shouldn't have a health bar goes in this category
{
	" /",
	" |",
	" |",
	" |",
	"( ",
	" |",
	" |",
	" |",
	" \\"
	},	{
	"  O",
	" )=(",
	"/   \\",
	"|__ |",
	"|+3||",
	"|__||",
	"|   |",
	"|___|"
	}, {
	"       _____                    ",
	"'-._\\ /     '~~''--.,_         ",
	"------>|              '~~''--.,_",
	"_.-'/ '.____,,,,----''''~~''''  "
	}
}	--end of items
}	--end of ASCIIart



local h = 0

if tabChar == 1 then	--This excist so that the player and a monster can be displayed at the same time. And so that the play head will be on the other side of the screen
	h = 1
	else
	h = curChar
end

function enemyHP(artPrint)
	if tabChar ~= 4 then
	term.setCursorPos(charX + 3, artPrint + charY)
	--write(tabChar.." "..curChar)		--debug
	write(char[tabChar][curChar][4].."/"..char[tabChar][curChar][5].." HP")
	end		--if not tabChar ~= 4 then
end
	
function enemyLifebar(artPrint, partLife, h)	--only run this within ASCIIchar!
	if tabChar ~= 4 then
	partLife = char[tabChar][h][4] / char[tabChar][h][5] * 10
	extraLife = 0

if partLife < 1  then partLife = 1  end

if partLife > 10 then
	while partLife > 10 do
		extraLife = partLife - 10 
		partLife = partLife - 10
	end
end
	
for lifebar = 1, partLife do
	term.setCursorPos(charX + lifebar + 1, artPrint + charY)
	write("*")			
end	--for lifebar = 1, char[2][n][4] do
	
	
if extraLife > 0 then
	for extrabar = 1, extraLife do
		term.setCursorPos(charX + extrabar + 1, artPrint + charY)
		write("x")
	end	--for extrabar = 1, extraLife do
	for remaining = extraLife + 1, 10 do
		write("*")
	end
end	--if extraLife > 0 then
end	--if not tabChar ~= 4
end	--function enemyLifebar(artPrint)

	
	for artPrint = 1, 11 do
	extra1 = 0
	extra2 = 0
		--term.setCursorPos(x, artPrint + y)
		if artPrint == 1 then
--			if not defBonus > 0 then													--NOTE
			enemyHP(artPrint)
--			end			
		end
		if artPrint == 2 then
			enemyLifebar(artPrint, partLife, h)
		end
		

	term.setCursorPos(charX, artPrint + charY + 0)			--change the '0' to a '1' if an empty line is desired between the lifebar and the enemy.
		print(ASCIIart[tabChar][curChar][artPrint - 2])
	end

end	--of function ASCIIchar(x)

function fMenu(menuNo, menuX, menuY, allowUsage)

--input:
	--menuNo		Which menu that should be used from the table
	--menuX
	--menuY		Where the box should appear, 30, 9 is recomended
	--output:
	--menuOutput = cursorPosY * 10 + cursorPosX		--What should be used for the output
	--cursorPosX	Where the cursor is on the horisontal axis, max 3
	--cursorPosY	Same but on the Y axis.		Note that these are global
	
--Note that the program doesn't reset you cursor postion after running, and that need to be done manually
menuLength = 0	--resets menuLength, this shouldn't be nesesary but it's good to have anyways
menuLength = #menu[menuNo]

menuOutput = 0

local optionLength = string.len(menu[menuNo][1])		--determines how long each number in the table is. needed to allow different lengths of options




local number = 0
		cursorPosX = 1		--should be local			--but is local to be able to work, but this resets it between runnings
		cursorPosY = 1		--should be local
local n
LoL = 0			--Length of Line			How long each line should be


while true do

if menuLength >= 9 then LoL = 3 else LoL = 2 end

local menuItem = 1
	
		for menuBar = 0, LoL * optionLength + (LoL - 1) * 2 + 5 do			--renders the top bar of the menu
			term.setCursorPos(menuX + menuBar, menuY)
			write("=")
		end		--for menuBar = 0, LoL...
		 

for menuRender = 1, (menuLength / LoL) + 1 do
term.setCursorPos(menuX, menuRender + menuY)
if menuItem > menuLength then break end
	write("||")
		for menuPrint = 1, LoL do			--Prints each line of the menu. 2 or 3 wide depending on how elemets are in it
				if LoL == 3 then n = -1 else  n = 0 end
				if menuItem > menuLength then term.setCursorPos(menuX + LoL * 7 + n, menuRender + menuY) break end
			
				write(" "..menu[menuNo][menuItem].." ")
				menuItem = menuItem + 1
			
		end

	write("||\n")
	menuRenderCon = menuRender
end

		
		for menuBar = 0, LoL * optionLength + (LoL - 1) * 2 + 5 do			--prints the bottom bar of the menu
			term.setCursorPos(menuX + menuBar, menuY + menuRenderCon + 1)
			write("=")
		end	--for menuBar = 0, LoL...

number = number + 1

param = 0
 if not allowUsage == false then																									-------------------

if number == 1 then
optionX = menuX + 2			--optionX shows where the different menu items should be displayed, where menuX is where the menu should start
optionY = menuY + 1
end
	while param ~= 28 and param ~= 200 and param ~= 203 and param ~= 205 and param ~= 208 and param ~= 15 do		--ends the menu if enter is pressed
	
		term.setCursorPos(optionX, optionY)
			write("[")
		term.setCursorPos(optionX + (optionLength + 1), optionY)
			write"]"
			
		if math.floor(menuLength/LoL) == menuLength/LoL then m = 0 else m = 1 end
		lastLine = menuLength - math.floor(menuLength/LoL) * LoL
	

		
	keyInput()
		
		
		if param == 208 then optionY = optionY + 1 cursorPosY = cursorPosY + 1 end
		if param == 200 then optionY = optionY - 1 cursorPosY = cursorPosY - 1 end
		if param == 203 then optionX = optionX - (optionLength + 2) cursorPosX = cursorPosX - 1 end
		if param == 205 then optionX = optionX + (optionLength + 2) cursorPosX = cursorPosX + 1 end
		if param == 15  then --switchMenu = true break end
			switchMenu = true term.setCursorPos(1,1) print("You have choosen option: "..cursorPosX..cursorPosY) break end
		if param == 28  then
			term.setCursorPos(1,1) print("You have choosen option: "..cursorPosX..cursorPosY) break end				--This line is if you want to test the menu. The cursorPosX is where it is on the horisontal axis, cursorPosY on the vertical.
--		break end
		
			
		
		if cursorPosX > LoL then optionX = optionX - (optionLength + 2) cursorPosX = LoL end
		if cursorPosX < 1 then optionX = optionX + (optionLength + 2) cursorPosX = 1 end
		if cursorPosY > math.floor(menuLength/LoL)+ m then optionY = optionY - 1 cursorPosY = math.floor(menuLength/LoL) + m end
		if cursorPosY < 1 then optionY = optionY + 1 cursorPosY = 1 end

			if param == 205 and lastLine ~= 0 and cursorPosX > lastLine and cursorPosY == math.floor(menuLength/LoL) + 1 then	--makes it so that the cursor can't go into an empty slot from the left
					cursorPosX = lastLine
					optionX = optionX - (optionLength + 2)			
			end
	
			if param == 208 and lastLine ~= 0 and cursorPosX > lastLine and cursorPosY == math.floor(menuLength/LoL) + 1 then	--Makes it so that the cursor can't go inte an empty slot from above
				cursorPosY = cursorPosY - 1
				optionY = optionY - 1
			end

	end
	

	if param == 28 then break end
	if param == 15 then break end

end	--if allowUsage	
	--print("test")
	if allowUsage == false then break end
end		--while true do

menuOutput = cursorPosY * 10 + cursorPosX
menuOutputNumerical = cursorPosY + cursorPosX + (cursorPosY - 2)

end	--function menu()

function playerAttack(defBonus)

if enemyAlive == false then return end
if playerAlive == false then return end

for x = 8, 1, -1 do
	term.clear()
	if defBonus > 0 then
		ASCIIchar(x + 24, 0, 4, 1)
	end
	ASCIIchar(x + 27, 0, 1, 1)
	ASCIIchar(1, 0, tabChar, curChar)
	os.sleep(0.01)						--Speeded up for the emulator
end
os.sleep(0.2)

char[tabChar][curChar][4] = char[tabChar][curChar][4] - math.max(1, (char[1][1][2] - defBonus) - char[tabChar][curChar][3])		--player attack monster
if char[tabChar][curChar][4] <= 0 then
	char[tabChar][curChar][4] = 0
	enemyAlive = false
end

for shake = 1, 6 do
	if 1-(-1)^shake == 0 then			--alternates between 0 and 2
		term.clear()
			if defBonus > 0 then
				ASCIIchar(25, 0, 4, 1)
			end
		ASCIIchar(28, 0, 1, 1)
		ASCIIchar(3, 0, tabChar, curChar)
		os.sleep(0.01)						--Speeded up for the emulator
		
	else
		term.clear()
			if defBonus > 0 then
				ASCIIchar(25, 0, 4, 1)
			end
		ASCIIchar(28, 0, 1, 1)
		ASCIIchar(1, 0, tabChar, curChar)
		os.sleep(0.01)						--Speeded up for the emulator
	end
end

for x = 1, 8 do
	term.clear()
	if defBonus > 0 then
		ASCIIchar(x + 24, 0, 4, 1)
	end
	ASCIIchar(x + 27, 0, 1, 1)
	ASCIIchar(1, 0, tabChar, curChar)
	os.sleep(0.01)						--Speeded up for the emulator
end
end	--function playerAttack()

function enemyAttack(defBonus)

if enemyAlive == false then return end
if playerAlive == false then return end

for x = 1, 8 do
	term.clear()
		if defBonus > 0 then
			ASCIIchar(32, 0, 4, 1)
		end
	ASCIIchar(x, 0, tabChar, curChar)
	ASCIIchar(35, 0, 1, 1)
	os.sleep(0.01)						--Speeded up for the emulator
end
os.sleep(0.2)

char[1][1][4] = char[1][1][4] - math.max(1, char[tabChar][curChar][2] - (char[1][1][3] + defBonus))								--monster attack player
if char[1][1][4] <= 0 then
	char[1][1][4] = 0
	playerAlive = false
end

for shake = 1, 6 do
	if 1-(-1)^shake == 0 then			--alternates between 0 and 2
		term.clear()
			if defBonus > 0 then
				ASCIIchar(32, 0, 4, 1)
			end
		ASCIIchar(8, 0, tabChar, curChar)
		ASCIIchar(35, 0, 1, 1)
		os.sleep(0.01)						--Speeded up for the emulator
		
	else
		term.clear()
			if defBonus > 0 then
				ASCIIchar(30, 0, 4, 1)
			end
		ASCIIchar(8, 0, tabChar, curChar)
		ASCIIchar(33, 0, 1, 1)
		os.sleep(0.01)						--Speeded up for the emulator
	end
end

for x = 8, 1, -1 do
	term.clear()
		if defBonus > 0 then
			ASCIIchar(32, 0, 4, 1)
		end
	ASCIIchar(x, 0, tabChar, curChar)
	ASCIIchar(35, 0, 1, 1)
	os.sleep(0.01)						--Speeded up for the emulator
end




--ASCIIchar(1, 0, tabChar, curChar)
--term.setCursorPos(1, 12)
--print("You fighted")		--combat log, if I want it
end	--function enemyAttack()

function potionUse()	--These two should be remade to only be one function
	if char[4][1][2] < 1 then print(char[1][1][1].." is out of potions") os.sleep(0.5) return end
	char[4][1][2] = char[4][1][2] - 1	--lowers the number of potions in you inventory
	menu[3] = {" potion x "..char[4][1][2], " carrot x "..char[4][1][3], " Leave INV ", char[4][1][4]}	--TEST
	if enemyAlive == true then	--this makes it so that the enemy only is spawned if it's alive
		ASCIIchar(1, 0, tabChar, curChar)	--spawns the enemy, this should be tweaked so it can be used outside of battle without spawning an enemy
	end
	ASCIIchar(35, 0, 1, 1)				--spwans the player
	ASCIIchar(30, 0, 4, 2)				--spawns the potion
	os.sleep(0.5)
	char[1][1][4] = math.min(char[1][1][4] + 3, char[1][1][5])
	term.clear()
	if enemyAlive == true then	--Also makes it so that the enemy only renders when it's alive
		ASCIIchar(1, 0, tabChar, curChar)	--Make sure no enemy is shovn outside of battle
	end
	ASCIIchar(35, 0, 1, 1)
	term.setCursorPos(1, 12)
	print(char[1][1][1].. " used a potion and healed 3 HP. "..char[4][1][2].." potions remaining")
	os.sleep(1.5)
	
end

function carrotUse()	--These two should be remade to only be one function
	if char[4][1][3] < 1 then print(char[1][1][1].." is out of carrots") os.sleep(0.5) return end
	char[4][1][3] = char[4][1][3] - 1	--lowers the number of potions in you inventory
	menu[3] = {" potion x "..char[4][1][2], " carrot x "..char[4][1][3], " Leave INV ", char[4][1][4]}	--TEST
	if enemyAlive == true then	--this makes it so that the enemy only is spawned if it's alive
		ASCIIchar(1, 0, tabChar, curChar)	--spawns the enemy, this should be tweaked so it can be used outside of battle without spawning an enemy
	end
	ASCIIchar(35, 0, 1, 1)				--spwans the player
	ASCIIchar(20, 0, 4, 3)				--spawns the carrot
	os.sleep(0.5)
	char[1][1][4] = math.min(char[1][1][4] + 1, char[1][1][5])
	term.clear()
	if enemyAlive == true then	--Also makes it so that the enemy only renders when it's alive
		ASCIIchar(1, 0, tabChar, curChar)	--Make sure no enemy is shovn outside of battle
	end
	ASCIIchar(35, 0, 1, 1)
	term.setCursorPos(1, 12)
	print(char[1][1][1].. " ate a carrot and healed 1 HP. "..char[4][1][3].." carrots remaining")
	os.sleep(1.5)
	
end

function inventory()
	local callMenu = 4		--which of the two "inventories" should be displayed.		3 = inventory	4 = equipment
	param = 0				--this is a problem since I use global variables, look into using local variables
	fMenu(callMenu, 10, callMenu * 10 - 25, false)
callMenu = 3
local otherMenu = 4
while param ~= 28 do
	fMenu(otherMenu, 10, otherMenu * 10 - 25, false)	--This allows the [] markers to disapear from the menu not currently in use
	fMenu(callMenu, 10, callMenu * 10 - 25, true)
		if switchMenu == true and callMenu == 3 then
			callMenu = 4
			otherMenu = 3
			switchMenu = false
		end
		if switchMenu == true and callMenu == 4 then
			callMenu = 3
			otherMenu = 4
			switchMenu = false
		end
		
	if callMenu == 3 and param ~= 15 then	--reads the answers if the player is in "inventory" mode, the param ~= 15 makes it so that no option is chosen when the player presses tab
		if menuOutputNumerical == 1 then
			term.clear()
			potionUse()
			enemyAttack(0)
			menuOutput = 0
			
		end
		if menuOutputNumerical == 2 then
			term.clear()
			carrotUse()
			enemyAttack(0)
			menuOutput = 0
			
		end
		
		if menuOutputNumerical > 2 and menuOutputNumerical < menuLength then	--All the options in between the consumables and the option to leave the menu. The consumable items might be added here later
			for x = 2, 5 do	--cycles through the different equipement types
				if string.sub(char[4][1][menuOutputNumerical + 1], 6, 11) == inventoryTable[1][2][x] and string.sub(menu[4][x], 9, 12) == inventoryTable[1][1][2] then	--if it's a helmet and the current helmet is "none" then 
					for y = 3, 5 do	--goes through the different materials
						if string.sub(char[4][1][menuOutputNumerical + 1], 1, 4) == inventoryTable[1][1][y] then	--Checks what material it is made of
							menu[4][x - 1] = inventoryTable[1][2][x]..": "..inventoryTable[1][1][y]	--Equips he equipement of the material chosen
							table.remove(char[4][1], menuOutputNumerical + 1)
							table.remove(menu[3], menuOutputNumerical)
							shouldBrake = true
							break	--Breaks if the applicable material has been found
						end	--if string.sub(char[4][1][menuOutputNumerical + 1]...
					end	--for y = 3, 5 do
				end		--if string.sub(char[4][1][menuOutputNumerical + 1]...
				if shouldBrake == true then break end
			end			--for x = 2, 5 do
		end	--if menuOutputNumerical > 2 and menuOutputNumerical < menuLength then
		
		if menuOutputNumerical == menuLength then	--leaves the inventory if the last option is selected
			--leaves inventory, this works if left alone
			menuOutput = 0
		end
		menuOutputNumerical = 0
	end	--if callMenu == 3 and param ~= 15 then
	
	if callMenu == 4 and param ~= 15 then	--reads the answers if the player is in "equipement" mode
	--The 4 equipement types is located in this order. Should I write the code to suport '4' or 'n' types of equipement?
		--helmet
		--Chestplate
		--Sword
		--Shield
	end	--if callMenu == 4 and param ~= 15 then
			
		
		
end	--while param ~= 28 do
end	--function inventory()

function battleReport()
	--this function is badly written and should probably be rewritten. But it's here for the enjoyment and bugtesting abilities of anyone running the program.

	term.clear()
	ASCIIchar(35, 0, 1, 1)
	term.setCursorPos(1, 12)
	print(char[tabChar][curChar][1].." was defeated")
	write(char[1][1][1].." leveled up from level "..char[1][1][7].. " to level ")
	char[1][1][7] = char[1][1][7] + 1
	print(char[1][1][7])
	print("Stats where increased...")
	term.setCursorPos(1, 18)
	write("press any key to continue")
	os.pullEvent("key")
	term.clear()
	term.setCursorPos(1, 1)
	--STR, DEF, MHP, SPD
	oldStats = {char[1][1][2], char[1][1][3], char[1][1][5], char[1][1][6], char[1][1][4]}
	hpMissing = char[1][1][5] - oldStats[4]	--checks how much HP the player is missing, to be able to heal him the amount he got extra from the level up. Currently this could be done in the level up menu but it wouldn't work after randomizers where added
	char[1][1][2] = char[1][1][2] + 1	--STR
	char[1][1][3] = char[1][1][3] + 1	--DEF
	char[1][1][5] = char[1][1][5] + 1	--MHP
	char[1][1][6] = char[1][1][6] + 1	--SPD
	char[1][1][4] = char[1][1][5] - hpMissing
	print("STR: "..oldStats[1].." + "..char[1][1][2] - oldStats[1].." = "..char[1][1][2])
	print("DEF: "..oldStats[2].." + "..char[1][1][3] - oldStats[2].." = "..char[1][1][3])
	print("MHP: "..oldStats[3].." + "..char[1][1][5] - oldStats[3].." = "..char[1][1][5])
	print("SPD: "..oldStats[4].." + "..char[1][1][6] - oldStats[4].." = "..char[1][1][6])
	
	term.setCursorPos(1, 18)
	write("press any key to continue")
	os.pullEvent("key")
	term.clear()
	
	
--local inMenu = true					--This part is disabled due to it being replaced by cave()
--while inMenu == true do	--makes it so that the player can return to this menu after being in a sub menu (inventory)
--	term.clear()
--	ASCIIchar(35, 0, 1, 1)
--	fMenu(5, 30, 12, true)
--	
--	if menuOutputNumerical == 1 then
--		tabChar = 2
--		--curChar = 1
--		curChar = math.floor((math.random() * 2) + 1) --spawns the next enemy
--		char[tabChar][curChar][4] = char[tabChar][curChar][5]	--resets the enemy just fought's HP back to top. Maybe this should be done just before the start of the fight higher up in the code
--		enemyAlive = true
--		inMenu = false
--		menuOutputNumerical = 0
--	end
--	if menuOutputNumerical == 2 then
--		term.clear()
--		ASCIIchar(35, 0, 1, 1)
--		inventory()
--		menuOutputNumerical = 0
--	end
--	if menuOutputNumerical == 3 then
--		playing = false
--		inMenu = false
--		menuOutputNumerical = 0
--	end
--	if menuOutputNumerical == 4 then
--		tabChar = 3
--		curChar = 1
--		char[tabChar][curChar][4] = char[tabChar][curChar][5]
--		enemyAlive = true
--		inMenu = false
--		menuOutputNumerical = 0
--	end
--end	--while inMenu == true do


end	--function battleReport()

function cave()			--this is really badluy written and should be poperly be integrated with the rest of the program

caveLayout = {
{"1","1","1","1","1","1","1","1"," ","1"," ","1","1","1","1","1","1","1","1"},
{"1"," "," "," "," "," "," "," "," ","1"," "," "," "," "," "," "," "," ","1"},
{"1"," ","1","1"," ","1","1","1"," ","1"," ","1","1","1"," ","1","1"," ","1"},
{"1"," ","1","1"," ","1","1","1"," ","1"," ","1","1","1"," ","1","1"," ","1"},
{"1"," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ","1"},
{"1"," ","1","1"," ","1"," ","1","1","1","1","1"," ","1"," ","1","1"," ","1"},
{"1"," "," "," "," ","1"," "," "," ","1"," "," "," ","1"," "," "," "," ","1"},
{"1","1","1","1"," ","1","1","1"," ","1"," ","1","1","1"," ","1","1","1","1"},
{" "," "," ","1"," ","1"," "," "," "," "," "," "," ","1"," ","1"," "," "," "},
{"1","1","1","1"," ","1"," ","1","1"," ","1","1"," ","1"," ","1","1","1","1"},
{" "," "," "," "," "," "," ","1"," ","."," ","1"," "," "," "," "," "," "," "},
{"1","1","1","1"," ","1"," ","1","1","1","1","1"," ","1"," ","1","1","1","1"},
{" "," "," ","1"," ","1"," "," "," "," "," "," "," ","1"," ","1"," "," "," "},
{"1","1","1","1","1","1","1","1"," ","1"," ","1","1","1","1","1","1","1","1"}
}




term.clear()


for y = math.max(playerPosY - 2, 1), math.min(playerPosY + 2, #caveLayout) do
	for x = math.max(playerPosX - 2, 1), math.min(playerPosX + 2, #caveLayout[1]) do
		term.setCursorPos(x, y)
		write(caveLayout[y][x])
	end
end



term.setCursorPos(playerPosX, playerPosY)
write("X")

term.setCursorPos(1, 6)


while true do
--param = 0
keyInput()
--Detects how to move the player
	if param == 200 then	--up
		playerPosY = playerPosY - 1	
	end
	if param == 203 then	--left
		playerPosX = playerPosX - 1
		
	end
	if param == 205 then	--right
		playerPosX = playerPosX + 1
		
	end
	if param == 208 then	--down
		playerPosY = playerPosY + 1
	end
	if param == 15 then
		inventory()
	end

--loops the player if he exits the screen
if param == 203 or param == 205 then
	if playerPosX > #caveLayout[playerPosY] then
		playerPosX = 1
	end
	if playerPosX < 1 then
		playerPosX = #caveLayout[playerPosY]
	end
end
if param == 200 or param == 208 then
	if playerPosY > #caveLayout then
		playerPosY = 1
	end
	if playerPosY < 1 then
		playerPosY = #caveLayout
	end
end


--Makes sure that the player can't noclip
if caveLayout[playerPosY][playerPosX] == "1" then
	if param == 200 then
		playerPosY = playerPosY + 1
	end
	if param == 203 then
		playerPosX = playerPosX + 1
	end
	if param == 205 then
		playerPosX = playerPosX - 1
	end
	if param == 208 then
		playerPosY = playerPosY - 1
	end
end


	
term.clear()


for y = math.max(playerPosY - 2, 1), math.min(playerPosY + 2, #caveLayout) do
	for x = math.max(playerPosX - 2, 1), math.min(playerPosX + 2, #caveLayout[1]) do
		term.setCursorPos(x, y)
		write(caveLayout[y][x])
	end
end

term.setCursorPos(playerPosX, playerPosY)
write("X")


if caveLayout[playerPosY][playerPosX] == " " then	--with a chance of 1/10 spawns an enemy whenever you move
	if math.floor(math.random() * 10 + 1) == 1 then
		enemyAlive = true
		tabChar = 2
		curChar = math.floor(math.random() * 2 + 1)
		break
	end
end
if caveLayout[playerPosY][playerPosX] == "." then	--spawns the dragon if you enter its lair
	enemyAlive = true
	tabChar = 3
	curChar = 1
	break
end


end	--while true do
end	--function cave()


term.clear()
term.setCursorPos(1, 1)
print("Welcome to AdventureGame!")
print("The game is currently in early Alpha and should be treated as such")
print("What do you want to do first?")
fMenu(2, 30, 9, true)				--start menu
	if menuOutputNumerical == 1 then
		term.setCursorPos(1, 1)
		term.clear()
		print("Welcome")
		menuOutput = 0
		menuOutputNumerical = 0
--		os.sleep(1)
	else if menuOutputNumerical == 2 then
		term.setCursorPos(1, 1)
		term.clear()
		print("Goodbye")
		os.sleep(1)
		menuOutput = 0
		menuOutputNumerical = 0
		error("Program quited")
		end
	end


--Combat

playerAlive = true
enemyAlive = false
playing = true
battleOngoing = false

while playing do	--makes it so that the game loops as long as the player is playing. This loop should be removed or reworked
playerRan = false
cave()

if enemyAlive and not battleOngoing then
char[tabChar][curChar][4] = char[tabChar][curChar][5]	--resets the enemy just fought's HP back to top.
battleOngoing = true
end

while enemyAlive and playerAlive do

term.clear()
ASCIIchar(35, 0, 1, 1)				--Spawns the player at the right side of the screen
ASCIIchar(1, 0, tabChar, curChar)	--Spawns the enemy at the left side of the screen
term.setCursorPos(1, 12)
print("An enemy apear! It's " .. char[tabChar][curChar][1])
fMenu(1, 34, 12, true)

term.clear()	--Important when opening the inventory
--term.setCursorPos(1, 1)

if menuOutputNumerical == 1 then			--attack
	if char[tabChar][curChar][6] > char[1][1][6] then		--checks speed and makes the one with the highest speed go first, this should be implemented for all combat actions, and maybe there should be some modifiers to it
		enemyAttack(0)
		playerAttack(0)
	else 
		playerAttack(0)
		enemyAttack(0)
	end	--if char[tabChar][curChar][6] > char[1][1][6] then
	menuOutputNumerical = 0
	menuOutput = 0
end
if menuOutputNumerical == 2 then			--defence
	if char[tabChar][curChar][6] > char[1][1][6] - 2 then		--checks speed and makes the one with the highest speed go first, this should be implemented for all combat actions, and maybe there should be some modifiers to it
		enemyAttack(2)		--all these '2' are the players defensive bonus, this should soon allow for monsters to have a bonus too
		playerAttack(2)
	else 
		playerAttack(2)
		enemyAttack(2)
	end	--if char[tabChar][curChar][6] > char[1][1][6] then
menuOutputNumerical = 0
menuOutput = 0
end

if menuOutputNumerical == 3 then			--item
inventory()
menuOutput = 0
menuOutputNumerical = 0
--potionUse()
--enemyAttack(0)
end

if menuOutputNumerical == 4 then			--run
	if char[tabChar][curChar][11] >= math.floor(math.random() * 100 + 1) then
		term.clear()
		ASCIIchar(1, 0, tabChar, curChar)
		term.setCursorPos(1, 12)
		menuOutputNumerical = 0
		menuOutput = 0
		print("you ran away")
		os.sleep(1)
		enemyAlive = false
		playerRan = true
	else
		term.clear()
		ASCIIchar(1, 0, tabChar, curChar)
		ASCIIchar(35, 0, 1, 1)
		term.setCursorPos(1, 12)
		menuOutputNumerical = 0
		menuOutput = 0
		print("You couldn't escape")
		os.sleep(1)
		enemyAttack(0)
	end
end

if char[tabChar][curChar][4] < 0 then
	enemyAlive = false
	
end
if char[1][1][4] <= 0 then -- the <= could be replaced by == but it's better to keep as is to ad an extra layer of protection
	playerAlive = false
	playing = false
	term.setCursorPos(1, 1)
	term.clear()
	print(char[1][1][1].." died.")
	print("Please restart to play again")
	--break	--this break was removed to not return to the game after death. This might be changed but for now it's a rougelike
	error("YOU DIED")
end


end	--while enemyAlive and playerAlive do

if playerAlive == true and enemyAlive == false and playerRan == false then
	battleReport()
end
	battleOngoing = false

end	--while playing do

