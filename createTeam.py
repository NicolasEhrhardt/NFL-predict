import rpy2.robjects as ro

def createTeams(teamNames,pos):
    global allTeams
    for name in teamNames:
        allTeams[name] = list(playerIndex(name,pos))


def dfs(myTeam, otherTeams, pastTrades, trade, depth):
    print depth
    global solutions
    if depth == MAX_DEPTH:
        print depth, MAX_DEPTH
        cost = getValue(myTeamName)[0]
        print cost
        if solutions['bestWin'] < cost: 
            solutions = {'bestWin':cost,tuple(pastTrades):cost}
        elif solutions['bestWin'] == cost:
            solutions[tuple(pastTrades)] = cost
        return


    pastTradesCp = pastTrades[:]
    pastTradesCp.append(trade)

    #preTradeWin = getValue(myTeamName)[0]
    #ro.conversion.ri2py(preTradeWin)
    for playerIndex,player in enumerate(myTeam):
        
        # Remove my player
        myTeam.remove(player)

        for index,(teamName, team) in enumerate(otherTeams.iteritems()):
            for otherPlayerIndex,otherPlayer in enumerate(team):
                
                # Swap Players
                otherTeams[teamName].remove(otherPlayer)
                # This would allow us to reswap, not necessary
                #otherTeams[teamName].insert(otherPlayerIndex,player)
                myTeam.insert(playerIndex,otherPlayer)
                swap(player,myTeamName,otherPlayer,teamName)
                #postTradeWin = getValueAndSwap(player,myTeamName, otherPlayer, teamName)[0]
                
                newTrade = "trade %s's %s for %s's %s" % (myTeamName, str(player), teamName, str(otherPlayer))
                print newTrade
                dfs(myTeam,otherTeams,pastTradesCp,\
                    trade + [newTrade],depth+1)

                #Undo swap
                swap(player,myTeamName,otherPlayer,teamName)
                #otherTeams[teamName].remove(player)
                otherTeams[teamName].insert(otherPlayerIndex,otherPlayer)
                myTeam.remove(otherPlayer)
        
        #Re-add my player
        myTeam.insert(playerIndex,player)


f = file("search.R")
code = ''.join(f.readlines())
result = ro.r(code)
swap = ro.r['swap']
playerIndex = ro.r['playerIndex']
getValue = ro.r['getValue']
getValueAndSwap = ro.r['getValueAndSwap']

#ariIndex = playerIndex("ARI","WR")
#atlIndex = playerIndex("ATL","WR")




MAX_DEPTH = 1
allTeams = {}
pos = "WR"
teamNames = ["ARI","ATL","BAL"]
myTeamName = 'ARI'
currWin = getValue(myTeamName)[0]
print currWin
solutions = {'bestWin':currWin}

createTeams(teamNames,pos)
myTeam = allTeams[myTeamName]
del allTeams[myTeamName]
dfs(myTeam, allTeams, [], ["Begin"], depth=0)
print solutions





