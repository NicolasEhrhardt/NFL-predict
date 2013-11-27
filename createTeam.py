import rpy2.robjects as ro

def createTeams(teamNames,pos):
    allTeams = {}
    for name in teamNames:
        allTeams[name] = list(playerIndex(name,pos))
    return allTeams

def dfs(myTeam, otherTeams, pastTrades, depth):
    print depth
    global solutions
    if depth == MAX_DEPTH:
        print depth, MAX_DEPTH
        cost = getValue(myTeamName)[0]
        print cost
        pastTrades = tuple(pastTrades)
        if solutions['bestWin'] < cost: 
            solutions = {'bestWin':cost,pastTrades:cost}
        elif solutions['bestWin'] == cost:
            solutions[pastTrades] = cost
        return


    #pastTradesCp = pastTrades[:]
    #pastTradesCp.append(trade)

    #preTradeWin = getValue(myTeamName)[0]
    #ro.conversion.ri2py(preTradeWin)
    for playerIndex,player in enumerate(myTeam):
        
        # Remove my player
        myTeam.remove(player)

        for index,(teamName, team) in enumerate(otherTeams.iteritems()):
            for otherPlayerIndex,otherPlayer in enumerate(team):
                if DEBUG:
                    print("\n\nSwapping a different player\n\n")
                # Swap Players
                otherTeams[teamName].remove(otherPlayer)
                # This would allow us to reswap, not necessary
                #otherTeams[teamName].insert(otherPlayerIndex,player)
                myTeam.insert(playerIndex,otherPlayer)
                
                newTrade = "trade %s's %s for %s's %s" % (myTeamName, str(player), teamName, str(otherPlayer))
                if DEBUG:
                    team1 = createTeams(teamNames,"WR")
                    for key,value in team1.iteritems():
                        print key,value
                        print newTrade
                
                swap(player,myTeamName,otherPlayer,teamName)
                
                if DEBUG:
                    team2 = createTeams(teamNames,"WR")
                    for key,value in team2.iteritems():
                        print key,value
                #postTradeWin = getValueAndSwap(player,myTeamName, otherPlayer, teamName)[0]
                

                dfs(myTeam,otherTeams,pastTrades + [newTrade],depth+1)

                #Undo swap
                swap(player,myTeamName,otherPlayer,teamName)
                #otherTeams[teamName].remove(player)
                otherTeams[teamName].insert(otherPlayerIndex,otherPlayer)
                myTeam.remove(otherPlayer)
        
        #Re-add my player
        myTeam.insert(playerIndex,player)


# R Features and Initialization
f = file("search2.R")
code = ''.join(f.readlines())
result = ro.r(code)
swap = ro.r['swap']
playerIndex = ro.r['playerIndex']
getValue = ro.r['getValue']



# Constants
DEBUG = 0
MAX_DEPTH = 2
pos = "WR"
teamNames = ["ARI","ATL","BAL"]
myTeamName = 'ARI'
currWin = getValue(myTeamName)[0]
solutions = {'bestWin':currWin}

# Setup
allTeams = createTeams(teamNames,pos)
print "\n\nStarting Values\n\n"
for key,value in allTeams.iteritems():
    print key,value
myTeam = allTeams[myTeamName]
del allTeams[myTeamName]
numPlayers = sum(len(value) for key,value in allTeams)
print "Will be performing %d swaps\nEstimated times is %d secs" % \
(len(myTeam)*(numPlayers**2),len(myTeam)*(numPlayers**2))


# Begin search and Print Soltuion
dfs(myTeam, allTeams, ["Begin"], depth=0)
print solutions





